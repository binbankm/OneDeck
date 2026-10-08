// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

class CommandInfo {
  final String command;
  final String groupBelong;
  final int groupID;
  final int id;
  final String name;
  final String type;

  const CommandInfo({
    this.command = '',
    this.groupBelong = '',
    this.groupID = 0,
    this.id = 0,
    this.name = '',
    this.type = '',
  });

  factory CommandInfo.fromJson(Map<String, dynamic> json) {
    return CommandInfo(
      command: json['command'] as String? ?? '',
      groupBelong: json['groupBelong'] as String? ?? '',
      groupID: (json['groupID'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'command': command,
      'groupBelong': groupBelong,
      'groupID': groupID,
      'id': id,
      'name': name,
      'type': type,
  };
}

class CommandOperate {
  final String command;
  final String groupBelong;
  final int groupID;
  final int id;
  final String name;
  final String type;

  const CommandOperate({
    this.command = '',
    this.groupBelong = '',
    this.groupID = 0,
    this.id = 0,
    this.name = '',
    this.type = '',
  });

  factory CommandOperate.fromJson(Map<String, dynamic> json) {
    return CommandOperate(
      command: json['command'] as String? ?? '',
      groupBelong: json['groupBelong'] as String? ?? '',
      groupID: (json['groupID'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'command': command,
      'groupBelong': groupBelong,
      'groupID': groupID,
      'id': id,
      'name': name,
      'type': type,
  };
}

class CommandTree {
  final List<CommandTree> children;
  final String label;
  final String value;

  const CommandTree({
    this.children = const [],
    this.label = '',
    this.value = '',
  });

  factory CommandTree.fromJson(Map<String, dynamic> json) {
    return CommandTree(
      children: (json['children'] as List<dynamic>?)?.map((e) => CommandTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'children': children.map((e) => e.toJson()).toList(),
      'label': label,
      'value': value,
  };
}

class OperateByIDs {
  final List<int> ids;

  const OperateByIDs({
    this.ids = const [],
  });

  factory OperateByIDs.fromJson(Map<String, dynamic> json) {
    return OperateByIDs(
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'ids': ids,
  };
}

class OperateByType {
  final String type;

  const OperateByType({
    this.type = '',
  });

  factory OperateByType.fromJson(Map<String, dynamic> json) {
    return OperateByType(
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'type': type,
  };
}

class PageResult {
  final dynamic items;
  final int total;

  const PageResult({
    this.items,
    this.total = 0,
  });

  factory PageResult.fromJson(Map<String, dynamic> json) {
    return PageResult(
      items: json['items'],
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'items': items,
      'total': total,
  };
}

class SearchWithPage {
  final bool excludeAppStore;
  final String info;
  final int page;
  final int pageSize;

  const SearchWithPage({
    this.excludeAppStore = false,
    this.info = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory SearchWithPage.fromJson(Map<String, dynamic> json) {
    return SearchWithPage(
      excludeAppStore: json['excludeAppStore'] as bool? ?? false,
      info: json['info'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'excludeAppStore': excludeAppStore,
      'info': info,
      'page': page,
      'pageSize': pageSize,
  };
}
