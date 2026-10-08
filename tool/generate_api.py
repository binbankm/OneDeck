import os
import sys
import json
import re

FEATURE_TAG_MAP = {
    'auth': ['Auth'],
    'dashboard': ['Dashboard', 'Monitor', 'Health'],
    'container': [
        'Container', 'Container Compose', 'Container Compose-template',
        'Container Docker', 'Container Image', 'Container Image-repo',
        'Container Network', 'Container Volume'
    ],
    'host': ['Host', 'Host tool', 'Disk Management', 'Firewall', 'Process', 'File', 'SSH', 'Device'],
    'database': [
        'Database', 'Database Common', 'Database Mongodb',
        'Database Mysql', 'Database PostgreSQL', 'Database Redis'
    ],
    'website': [
        'Website', 'Website Acme', 'Website CA', 'Website DNS',
        'Website Domain', 'Website HTTPS', 'Website Nginx', 'Website PHP',
        'Website SSL', 'Website Template', 'OpenResty', 'PHP Extensions'
    ],
    'cronjob': ['Cronjob', 'ScriptLibrary'],
    'app_store': ['App'],
    'terminal': ['Terminal', 'Command'],
    'toolbox': ['FTP', 'Fail2ban', 'Clam', 'Runtime', 'RuntimeDiagnostics'],
    'log': ['Logs', 'TaskLog'],
    'setting': ['System Setting', 'Menu Setting', 'System Group', 'Backup Account'],
    'ai': ['AI', 'McpServer', 'TensorRT LLM'],
    'alert': ['Alert']
}

SWAGGER_PATH = '1panel/core/cmd/server/docs/swagger.json'

DART_KEYWORDS = {
    'default', 'switch', 'case', 'break', 'class', 'enum', 'in', 'is', 'new',
    'super', 'this', 'continue', 'return', 'try', 'catch', 'finally', 'throw',
    'rethrow', 'void', 'dynamic', 'null', 'var', 'const', 'final', 'abstract',
    'extends', 'with', 'implements', 'mixin', 'part', 'import', 'export',
    'library', 'typedef', 'function', 'operator', 'set', 'get', 'sync', 'async',
    'yield', 'await', 'assert', 'runtimeType', 'hashCode'
}

def to_upper_camel(s):
    if s.startswith('#/definitions/'):
        s = s.split('/')[-1]
    for prefix in ['dto.', 'request.', 'response.', 'model.', 'service.', 'filter.']:
        if s.startswith(prefix):
            s = s[len(prefix):]
    if '_' in s or '-' in s or '.' in s:
        parts = re.split(r'[^a-zA-Z0-9]', s)
        res = "".join([p.capitalize() for p in parts if p])
    else:
        res = s[0].upper() + s[1:]
    if res and res[0].isdigit():
        res = f"Model{res}"
    return res or "ItemModel"

def to_camel_case(s):
    s = s.strip()
    if not s:
        return 'item'
    if '_' in s or '-' in s or '.' in s:
        parts = re.split(r'[^a-zA-Z0-9]', s)
        parts = [p for p in parts if p]
        if not parts:
            return 'item'
        res = parts[0].lower() + "".join([p.capitalize() for p in parts[1:]])
    else:
        res = s[0].lower() + s[1:]
    if res and res[0].isdigit():
        res = f"val{res}"
    if res in DART_KEYWORDS:
        res = f"${res}"
    return res

def find_all_refs(schema, out_set):
    if isinstance(schema, dict):
        if '$ref' in schema:
            out_set.add(schema['$ref'].split('/')[-1])
        for v in schema.values():
            find_all_refs(v, out_set)
    elif isinstance(schema, list):
        for item in schema:
            find_all_refs(item, out_set)

def resolve_dart_type(prop, definitions, collected_defs):
    if '$ref' in prop:
        ref_raw = prop['$ref'].split('/')[-1]
        collected_defs.add(ref_raw)
        return to_upper_camel(ref_raw)
    t = prop.get('type')
    if t == 'string':
        return 'String'
    elif t == 'integer':
        return 'int'
    elif t == 'number':
        return 'double'
    elif t == 'boolean':
        return 'bool'
    elif t == 'array':
        items = prop.get('items', {})
        inner = resolve_dart_type(items, definitions, collected_defs)
        return f'List<{inner}>'
    elif t == 'object':
        return 'Map<String, dynamic>'
    return 'dynamic'

def generate_dart_class(def_name, schema, definitions, collected_defs):
    class_name = to_upper_camel(def_name)
    properties = schema.get('properties', {})
    
    fields = []
    from_json_lines = []
    to_json_lines = []
    
    for prop_name, prop_spec in properties.items():
        dart_field_name = to_camel_case(prop_name)
        dart_type = resolve_dart_type(prop_spec, definitions, collected_defs)
        fields.append((dart_field_name, dart_type, prop_name))
        
        # fromJson logic
        if dart_type == 'String':
            from_json_lines.append(f"      {dart_field_name}: json['{prop_name}'] as String? ?? '',")
        elif dart_type == 'int':
            from_json_lines.append(f"      {dart_field_name}: (json['{prop_name}'] as num?)?.toInt() ?? 0,")
        elif dart_type == 'double':
            from_json_lines.append(f"      {dart_field_name}: (json['{prop_name}'] as num?)?.toDouble() ?? 0.0,")
        elif dart_type == 'bool':
            from_json_lines.append(f"      {dart_field_name}: json['{prop_name}'] as bool? ?? false,")
        elif dart_type.startswith('List<List<'):
            from_json_lines.append(f"      {dart_field_name}: const [],")
        elif dart_type.startswith('List<'):
            inner = dart_type[5:-1]
            if inner in ['String', 'int', 'double', 'bool']:
                from_json_lines.append(f"      {dart_field_name}: (json['{prop_name}'] as List<dynamic>?)?.map((e) => e as {inner}).toList() ?? const [],")
            elif inner == 'dynamic':
                from_json_lines.append(f"      {dart_field_name}: (json['{prop_name}'] as List<dynamic>?) ?? const [],")
            else:
                from_json_lines.append(f"      {dart_field_name}: (json['{prop_name}'] as List<dynamic>?)?.map((e) => {inner}.fromJson(e as Map<String, dynamic>)).toList() ?? const [],")
        elif dart_type == 'Map<String, dynamic>':
            from_json_lines.append(f"      {dart_field_name}: json['{prop_name}'] as Map<String, dynamic>? ?? const {{}},")
        elif dart_type == 'dynamic':
            from_json_lines.append(f"      {dart_field_name}: json['{prop_name}'],")
        else: # Nested Model
            from_json_lines.append(f"      {dart_field_name}: json['{prop_name}'] != null ? {dart_type}.fromJson(json['{prop_name}'] as Map<String, dynamic>) : null,")
            
        # toJson logic
        if dart_type.startswith('List<List<'):
            to_json_lines.append(f"      '{prop_name}': const [],")
        elif dart_type in ['String', 'int', 'double', 'bool', 'Map<String, dynamic>', 'dynamic']:
            to_json_lines.append(f"      '{prop_name}': {dart_field_name},")
        elif dart_type.startswith('List<'):
            inner = dart_type[5:-1]
            if inner in ['String', 'int', 'double', 'bool', 'dynamic']:
                to_json_lines.append(f"      '{prop_name}': {dart_field_name},")
            else:
                to_json_lines.append(f"      '{prop_name}': {dart_field_name}.map((e) => e.toJson()).toList(),")
        else:
            to_json_lines.append(f"      if ({dart_field_name} != null) '{prop_name}': {dart_field_name}!.toJson(),")

    out = []
    out.append(f"class {class_name} {{")
    for field_name, dart_type, _ in fields:
        is_optional = (dart_type not in ['String', 'int', 'double', 'bool', 'dynamic'] and not dart_type.startswith('List<') and dart_type != 'Map<String, dynamic>')
        type_str = f"{dart_type}?" if is_optional else dart_type
        out.append(f"  final {type_str} {field_name};")
    
    out.append("")
    if not fields:
        out.append(f"  const {class_name}();")
    else:
        out.append(f"  const {class_name}({{")
        for field_name, dart_type, _ in fields:
            is_optional = (dart_type not in ['String', 'int', 'double', 'bool', 'dynamic'] and not dart_type.startswith('List<') and dart_type != 'Map<String, dynamic>')
            if is_optional:
                out.append(f"    this.{field_name},")
            elif dart_type == 'String':
                out.append(f"    this.{field_name} = '',")
            elif dart_type == 'int':
                out.append(f"    this.{field_name} = 0,")
            elif dart_type == 'double':
                out.append(f"    this.{field_name} = 0.0,")
            elif dart_type == 'bool':
                out.append(f"    this.{field_name} = false,")
            elif dart_type.startswith('List<'):
                out.append(f"    this.{field_name} = const [],")
            elif dart_type == 'Map<String, dynamic>':
                out.append(f"    this.{field_name} = const {{}},")
            else:
                out.append(f"    this.{field_name},")
        out.append("  });")
    
    out.append("")
    out.append(f"  factory {class_name}.fromJson(Map<String, dynamic> json) {{")
    out.append(f"    return {class_name}(")
    out.extend(from_json_lines)
    out.append("    );")
    out.append("  }")
    
    out.append("")
    out.append("  Map<String, dynamic> toJson() => {")
    out.extend(to_json_lines)
    out.append("  };")
    out.append("}")
    return "\n".join(out)

def generate_feature(feature_key, swagger_data):
    tags = FEATURE_TAG_MAP.get(feature_key, [])
    if not tags:
        print(f"Unknown feature: {feature_key}")
        return

    print(f"\n==========================================")
    print(f"🚀 Generating Feature: {feature_key} (tags: {len(tags)})")
    print(f"==========================================")

    definitions = swagger_data.get('definitions', {})
    paths = swagger_data.get('paths', {})

    feature_endpoints = []
    collected_defs = set()

    for path, methods in paths.items():
        for m, spec in methods.items():
            if not isinstance(spec, dict):
                continue
            spec_tags = spec.get('tags', [])
            if any(t in tags for t in spec_tags):
                feature_endpoints.append((path, m.upper(), spec))
                find_all_refs(spec, collected_defs)

    # Transitively collect all referenced definitions recursively
    prev_len = 0
    while len(collected_defs) > prev_len:
        prev_len = len(collected_defs)
        new_batch = set(collected_defs)
        for def_name in new_batch:
            d_spec = definitions.get(def_name, {})
            find_all_refs(d_spec, collected_defs)

    print(f"📦 Collected {len(feature_endpoints)} endpoints, {len(collected_defs)} DTO models.")

    # 1. Generate Models
    models_dir = f"lib/features/{feature_key}/data/models"
    api_dir = f"lib/features/{feature_key}/data/api"
    os.makedirs(models_dir, exist_ok=True)
    os.makedirs(api_dir, exist_ok=True)

    models_code = ["// GENERATED CODE - DO NOT MODIFY BY HAND", "// 1Panel V2 OpenAPI Generated Models", ""]
    seen_classes = set()
    for def_name in sorted(list(collected_defs)):
        class_name = to_upper_camel(def_name)
        if class_name in seen_classes:
            continue
        seen_classes.add(class_name)
        d_spec = definitions.get(def_name)
        if d_spec:
            models_code.append(generate_dart_class(def_name, d_spec, definitions, collected_defs))
            models_code.append("")

    models_file_path = f"{models_dir}/{feature_key}_models.dart"
    with open(models_file_path, "w") as f:
        f.write("\n".join(models_code))
    print(f"✅ Models written to: {models_file_path}")

    # 2. Generate API Client
    class_api_name = "".join([part.capitalize() for part in feature_key.split('_')]) + "Api"
    api_lines = [
        "// GENERATED CODE - DO NOT MODIFY BY HAND",
        "// 1Panel V2 OpenAPI Generated API Client",
        "",
        "import '../../../../core/network/dio_client.dart';",
        "import '../../../../core/network/api_response.dart';",
        f"import '../models/{feature_key}_models.dart';",
        "",
        f"class {class_api_name} {{",
        "  final DioClient client;",
        "",
        f"  const {class_api_name}(this.client);",
        ""
    ]

    method_seen = set()
    for path, method, spec in feature_endpoints:
        summary = spec.get('summary', path)
        raw_op_id = spec.get('operationId', '')
        if not raw_op_id:
            clean_p = re.sub(r'[:{}]', '', path)
            parts = [p for p in clean_p.split('/') if p and p not in ['api', 'v2', 'core', feature_key]]
            if not parts:
                parts = [p for p in clean_p.split('/') if p]
            raw_op_id = method.lower() + "".join([p.capitalize() for p in parts])

        op_name = to_camel_case(raw_op_id)
        if op_name in method_seen:
            idx = 2
            while f"{op_name}{idx}" in method_seen:
                idx += 1
            op_name = f"{op_name}{idx}"
        method_seen.add(op_name)

        # Check body param
        body_param = None
        for p in spec.get('parameters', []):
            if p.get('in') == 'body':
                body_schema = p.get('schema', {})
                if '$ref' in body_schema:
                    body_param = to_upper_camel(body_schema['$ref'])
                elif body_schema.get('type') == 'object':
                    body_param = 'Map<String, dynamic>'

        # Check return schema
        resp_type = 'void'
        resp_schema = spec.get('responses', {}).get('200', {}).get('schema', {})
        if '$ref' in resp_schema:
            resp_type = to_upper_camel(resp_schema['$ref'])

        # Build method
        api_lines.append(f"  /// {summary}")
        dart_path = path
        path_params = re.findall(r':([a-zA-Z0-9_]+)', path)

        args = []
        for pp in path_params:
            var_name = to_camel_case(pp)
            dart_path = dart_path.replace(f':{pp}', f'${var_name}')
            args.append(f"String {var_name}")

        if body_param:
            args.append(f"{body_param} request")
        pass

        if args:
            args_str = ", ".join([a for a in args if a]) + ", {Map<String, dynamic>? queryParameters}"
        else:
            args_str = "{Map<String, dynamic>? queryParameters}"

        if method == 'POST':
            if resp_type == 'void':
                api_lines.append(f"  Future<ApiResponse<void>> {op_name}({args_str}) async {{")
                if body_param:
                    api_lines.append(f"    return client.post<void>('{dart_path}', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);")
                else:
                    api_lines.append(f"    return client.post<void>('{dart_path}', queryParameters: queryParameters);")
            else:
                api_lines.append(f"  Future<ApiResponse<{resp_type}>> {op_name}({args_str}) async {{")
                if body_param:
                    api_lines.append(f"    return client.post<{resp_type}>('{dart_path}', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => {resp_type}.fromJson(d as Map<String, dynamic>));")
                else:
                    api_lines.append(f"    return client.post<{resp_type}>('{dart_path}', queryParameters: queryParameters, fromData: (d) => {resp_type}.fromJson(d as Map<String, dynamic>));")
            api_lines.append("  }")
        elif method == 'GET':
            if resp_type == 'void':
                api_lines.append(f"  Future<ApiResponse<void>> {op_name}({args_str}) async {{")
                api_lines.append(f"    return client.get<void>('{dart_path}', queryParameters: queryParameters);")
            else:
                api_lines.append(f"  Future<ApiResponse<{resp_type}>> {op_name}({args_str}) async {{")
                api_lines.append(f"    return client.get<{resp_type}>('{dart_path}', queryParameters: queryParameters, fromData: (d) => {resp_type}.fromJson(d as Map<String, dynamic>));")
            api_lines.append("  }")
        elif method == 'DELETE':
            api_lines.append(f"  Future<ApiResponse<void>> {op_name}({args_str}) async {{")
            api_lines.append(f"    return client.post<void>('{dart_path}', queryParameters: queryParameters);")
            api_lines.append("  }")
        api_lines.append("")

    api_lines.append("}")
    api_file_path = f"{api_dir}/{feature_key}_api.dart"
    with open(api_file_path, "w") as f:
        f.write("\n".join(api_lines))
    print(f"✅ API Client written to: {api_file_path}")

def main():
    if not os.path.exists(SWAGGER_PATH):
        print(f"Error: Swagger file not found at {SWAGGER_PATH}")
        sys.exit(1)

    with open(SWAGGER_PATH, 'r') as f:
        swagger_data = json.load(f)

    if len(sys.argv) > 1 and sys.argv[1] == '--all':
        features = list(FEATURE_TAG_MAP.keys())
    elif len(sys.argv) > 1:
        features = [f.strip() for f in sys.argv[1].split(',') if f.strip()]
    else:
        features = list(FEATURE_TAG_MAP.keys())

    for feat in features:
        generate_feature(feat, swagger_data)

if __name__ == '__main__':
    main()
