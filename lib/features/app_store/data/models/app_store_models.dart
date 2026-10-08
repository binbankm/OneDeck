// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

class AppConfigVersion {
  final dynamic additionalProperties;
  final String downloadCallBackUrl;
  final String downloadUrl;
  final int lastModified;
  final String name;

  const AppConfigVersion({
    this.additionalProperties,
    this.downloadCallBackUrl = '',
    this.downloadUrl = '',
    this.lastModified = 0,
    this.name = '',
  });

  factory AppConfigVersion.fromJson(Map<String, dynamic> json) {
    return AppConfigVersion(
      additionalProperties: json['additionalProperties'],
      downloadCallBackUrl: json['downloadCallBackUrl'] as String? ?? '',
      downloadUrl: json['downloadUrl'] as String? ?? '',
      lastModified: (json['lastModified'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'additionalProperties': additionalProperties,
      'downloadCallBackUrl': downloadCallBackUrl,
      'downloadUrl': downloadUrl,
      'lastModified': lastModified,
      'name': name,
  };
}

class AppDefine {
  final AppProperty? additionalProperties;
  final String icon;
  final int lastModified;
  final String name;
  final String readMe;
  final List<AppConfigVersion> versions;

  const AppDefine({
    this.additionalProperties,
    this.icon = '',
    this.lastModified = 0,
    this.name = '',
    this.readMe = '',
    this.versions = const [],
  });

  factory AppDefine.fromJson(Map<String, dynamic> json) {
    return AppDefine(
      additionalProperties: json['additionalProperties'] != null ? AppProperty.fromJson(json['additionalProperties'] as Map<String, dynamic>) : null,
      icon: json['icon'] as String? ?? '',
      lastModified: (json['lastModified'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      readMe: json['readMe'] as String? ?? '',
      versions: (json['versions'] as List<dynamic>?)?.map((e) => AppConfigVersion.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      if (additionalProperties != null) 'additionalProperties': additionalProperties!.toJson(),
      'icon': icon,
      'lastModified': lastModified,
      'name': name,
      'readMe': readMe,
      'versions': versions.map((e) => e.toJson()).toList(),
  };
}

class AppInstallInfo {
  final int id;
  final String key;
  final String name;

  const AppInstallInfo({
    this.id = 0,
    this.key = '',
    this.name = '',
  });

  factory AppInstallInfo.fromJson(Map<String, dynamic> json) {
    return AppInstallInfo(
      id: (json['id'] as num?)?.toInt() ?? 0,
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'key': key,
      'name': name,
  };
}

class AppList {
  final ExtraProperties? additionalProperties;
  final List<AppDefine> apps;
  final int lastModified;
  final bool valid;
  final List<String> violations;

  const AppList({
    this.additionalProperties,
    this.apps = const [],
    this.lastModified = 0,
    this.valid = false,
    this.violations = const [],
  });

  factory AppList.fromJson(Map<String, dynamic> json) {
    return AppList(
      additionalProperties: json['additionalProperties'] != null ? ExtraProperties.fromJson(json['additionalProperties'] as Map<String, dynamic>) : null,
      apps: (json['apps'] as List<dynamic>?)?.map((e) => AppDefine.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      lastModified: (json['lastModified'] as num?)?.toInt() ?? 0,
      valid: json['valid'] as bool? ?? false,
      violations: (json['violations'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      if (additionalProperties != null) 'additionalProperties': additionalProperties!.toJson(),
      'apps': apps.map((e) => e.toJson()).toList(),
      'lastModified': lastModified,
      'valid': valid,
      'violations': violations,
  };
}

class AppProperty {
  final List<String> required;
  final List<String> architectures;
  final bool batchInstallSupport;
  final bool crossVersionUpdate;
  final double deprecated;
  final Locale? description;
  final String document;
  final String github;
  final bool gpuSupport;
  final String key;
  final int limit;
  final int memoryRequired;
  final String name;
  final int recommend;
  final String shortDescEn;
  final String shortDescZh;
  final List<String> tags;
  final String type;
  final double version;
  final String website;

  const AppProperty({
    this.required = const [],
    this.architectures = const [],
    this.batchInstallSupport = false,
    this.crossVersionUpdate = false,
    this.deprecated = 0.0,
    this.description,
    this.document = '',
    this.github = '',
    this.gpuSupport = false,
    this.key = '',
    this.limit = 0,
    this.memoryRequired = 0,
    this.name = '',
    this.recommend = 0,
    this.shortDescEn = '',
    this.shortDescZh = '',
    this.tags = const [],
    this.type = '',
    this.version = 0.0,
    this.website = '',
  });

  factory AppProperty.fromJson(Map<String, dynamic> json) {
    return AppProperty(
      required: (json['Required'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      architectures: (json['architectures'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      batchInstallSupport: json['batchInstallSupport'] as bool? ?? false,
      crossVersionUpdate: json['crossVersionUpdate'] as bool? ?? false,
      deprecated: (json['deprecated'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] != null ? Locale.fromJson(json['description'] as Map<String, dynamic>) : null,
      document: json['document'] as String? ?? '',
      github: json['github'] as String? ?? '',
      gpuSupport: json['gpuSupport'] as bool? ?? false,
      key: json['key'] as String? ?? '',
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      memoryRequired: (json['memoryRequired'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      recommend: (json['recommend'] as num?)?.toInt() ?? 0,
      shortDescEn: json['shortDescEn'] as String? ?? '',
      shortDescZh: json['shortDescZh'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      type: json['type'] as String? ?? '',
      version: (json['version'] as num?)?.toDouble() ?? 0.0,
      website: json['website'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'Required': required,
      'architectures': architectures,
      'batchInstallSupport': batchInstallSupport,
      'crossVersionUpdate': crossVersionUpdate,
      'deprecated': deprecated,
      if (description != null) 'description': description!.toJson(),
      'document': document,
      'github': github,
      'gpuSupport': gpuSupport,
      'key': key,
      'limit': limit,
      'memoryRequired': memoryRequired,
      'name': name,
      'recommend': recommend,
      'shortDescEn': shortDescEn,
      'shortDescZh': shortDescZh,
      'tags': tags,
      'type': type,
      'version': version,
      'website': website,
  };
}

class AppResource {
  final String name;
  final String type;

  const AppResource({
    this.name = '',
    this.type = '',
  });

  factory AppResource.fromJson(Map<String, dynamic> json) {
    return AppResource(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'type': type,
  };
}

class AppVersion {
  final int detailId;
  final String dockerCompose;
  final String version;

  const AppVersion({
    this.detailId = 0,
    this.dockerCompose = '',
    this.version = '',
  });

  factory AppVersion.fromJson(Map<String, dynamic> json) {
    return AppVersion(
      detailId: (json['detailId'] as num?)?.toInt() ?? 0,
      dockerCompose: json['dockerCompose'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'detailId': detailId,
      'dockerCompose': dockerCompose,
      'version': version,
  };
}

class AppstoreConfig {
  final String installAllowPort;
  final String uninstallDeleteBackup;
  final String uninstallDeleteImage;
  final String upgradeBackup;
  final String upgradeDeleteImage;

  const AppstoreConfig({
    this.installAllowPort = '',
    this.uninstallDeleteBackup = '',
    this.uninstallDeleteImage = '',
    this.upgradeBackup = '',
    this.upgradeDeleteImage = '',
  });

  factory AppstoreConfig.fromJson(Map<String, dynamic> json) {
    return AppstoreConfig(
      installAllowPort: json['installAllowPort'] as String? ?? '',
      uninstallDeleteBackup: json['uninstallDeleteBackup'] as String? ?? '',
      uninstallDeleteImage: json['uninstallDeleteImage'] as String? ?? '',
      upgradeBackup: json['upgradeBackup'] as String? ?? '',
      upgradeDeleteImage: json['upgradeDeleteImage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'installAllowPort': installAllowPort,
      'uninstallDeleteBackup': uninstallDeleteBackup,
      'uninstallDeleteImage': uninstallDeleteImage,
      'upgradeBackup': upgradeBackup,
      'upgradeDeleteImage': upgradeDeleteImage,
  };
}

class AppstoreUpdate {
  final String scope;
  final String status;

  const AppstoreUpdate({
    this.scope = '',
    this.status = '',
  });

  factory AppstoreUpdate.fromJson(Map<String, dynamic> json) {
    return AppstoreUpdate(
      scope: json['scope'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'scope': scope,
      'status': status,
  };
}

class ExtraProperties {
  final List<Tag> tags;
  final String version;

  const ExtraProperties({
    this.tags = const [],
    this.version = '',
  });

  factory ExtraProperties.fromJson(Map<String, dynamic> json) {
    return ExtraProperties(
      tags: (json['tags'] as List<dynamic>?)?.map((e) => Tag.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'tags': tags.map((e) => e.toJson()).toList(),
      'version': version,
  };
}

class Locale {
  final String en;
  final String esEs;
  final String fa;
  final String ja;
  final String ko;
  final String lo;
  final String ms;
  final String ptBr;
  final String ru;
  final String tr;
  final String zh;
  final String zhHant;

  const Locale({
    this.en = '',
    this.esEs = '',
    this.fa = '',
    this.ja = '',
    this.ko = '',
    this.lo = '',
    this.ms = '',
    this.ptBr = '',
    this.ru = '',
    this.tr = '',
    this.zh = '',
    this.zhHant = '',
  });

  factory Locale.fromJson(Map<String, dynamic> json) {
    return Locale(
      en: json['en'] as String? ?? '',
      esEs: json['es-es'] as String? ?? '',
      fa: json['fa'] as String? ?? '',
      ja: json['ja'] as String? ?? '',
      ko: json['ko'] as String? ?? '',
      lo: json['lo'] as String? ?? '',
      ms: json['ms'] as String? ?? '',
      ptBr: json['pt-br'] as String? ?? '',
      ru: json['ru'] as String? ?? '',
      tr: json['tr'] as String? ?? '',
      zh: json['zh'] as String? ?? '',
      zhHant: json['zh-hant'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'en': en,
      'es-es': esEs,
      'fa': fa,
      'ja': ja,
      'ko': ko,
      'lo': lo,
      'ms': ms,
      'pt-br': ptBr,
      'ru': ru,
      'tr': tr,
      'zh': zh,
      'zh-hant': zhHant,
  };
}

class OperationWithNameAndType {
  final String name;
  final String type;

  const OperationWithNameAndType({
    this.name = '',
    this.type = '',
  });

  factory OperationWithNameAndType.fromJson(Map<String, dynamic> json) {
    return OperationWithNameAndType(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
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

class Tag {
  final String key;
  final Locale? locales;
  final String name;
  final int sort;

  const Tag({
    this.key = '',
    this.locales,
    this.name = '',
    this.sort = 0,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      key: json['key'] as String? ?? '',
      locales: json['locales'] != null ? Locale.fromJson(json['locales'] as Map<String, dynamic>) : null,
      name: json['name'] as String? ?? '',
      sort: (json['sort'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'key': key,
      if (locales != null) 'locales': locales!.toJson(),
      'name': name,
      'sort': sort,
  };
}

class App {
  final String architectures;
  final bool batchInstallSupport;
  final String createdAt;
  final bool crossVersionUpdate;
  final String description;
  final String document;
  final String github;
  final bool gpuSupport;
  final String icon;
  final int id;
  final String key;
  final int lastModified;
  final int limit;
  final int memoryRequired;
  final String name;
  final String readMe;
  final int recommend;
  final String required;
  final double requiredPanelVersion;
  final String resource;
  final String shortDescEn;
  final String shortDescZh;
  final String status;
  final List<String> tags;
  final String type;
  final String updatedAt;
  final String website;

  const App({
    this.architectures = '',
    this.batchInstallSupport = false,
    this.createdAt = '',
    this.crossVersionUpdate = false,
    this.description = '',
    this.document = '',
    this.github = '',
    this.gpuSupport = false,
    this.icon = '',
    this.id = 0,
    this.key = '',
    this.lastModified = 0,
    this.limit = 0,
    this.memoryRequired = 0,
    this.name = '',
    this.readMe = '',
    this.recommend = 0,
    this.required = '',
    this.requiredPanelVersion = 0.0,
    this.resource = '',
    this.shortDescEn = '',
    this.shortDescZh = '',
    this.status = '',
    this.tags = const [],
    this.type = '',
    this.updatedAt = '',
    this.website = '',
  });

  factory App.fromJson(Map<String, dynamic> json) {
    return App(
      architectures: json['architectures'] as String? ?? '',
      batchInstallSupport: json['batchInstallSupport'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      crossVersionUpdate: json['crossVersionUpdate'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      document: json['document'] as String? ?? '',
      github: json['github'] as String? ?? '',
      gpuSupport: json['gpuSupport'] as bool? ?? false,
      icon: json['icon'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      key: json['key'] as String? ?? '',
      lastModified: (json['lastModified'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      memoryRequired: (json['memoryRequired'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      readMe: json['readMe'] as String? ?? '',
      recommend: (json['recommend'] as num?)?.toInt() ?? 0,
      required: json['required'] as String? ?? '',
      requiredPanelVersion: (json['requiredPanelVersion'] as num?)?.toDouble() ?? 0.0,
      resource: json['resource'] as String? ?? '',
      shortDescEn: json['shortDescEn'] as String? ?? '',
      shortDescZh: json['shortDescZh'] as String? ?? '',
      status: json['status'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      type: json['type'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      website: json['website'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'architectures': architectures,
      'batchInstallSupport': batchInstallSupport,
      'createdAt': createdAt,
      'crossVersionUpdate': crossVersionUpdate,
      'description': description,
      'document': document,
      'github': github,
      'gpuSupport': gpuSupport,
      'icon': icon,
      'id': id,
      'key': key,
      'lastModified': lastModified,
      'limit': limit,
      'memoryRequired': memoryRequired,
      'name': name,
      'readMe': readMe,
      'recommend': recommend,
      'required': required,
      'requiredPanelVersion': requiredPanelVersion,
      'resource': resource,
      'shortDescEn': shortDescEn,
      'shortDescZh': shortDescZh,
      'status': status,
      'tags': tags,
      'type': type,
      'updatedAt': updatedAt,
      'website': website,
  };
}

class AppIgnoreUpgrade {
  final int appDetailID;
  final int appID;
  final String createdAt;
  final int id;
  final String scope;
  final String updatedAt;

  const AppIgnoreUpgrade({
    this.appDetailID = 0,
    this.appID = 0,
    this.createdAt = '',
    this.id = 0,
    this.scope = '',
    this.updatedAt = '',
  });

  factory AppIgnoreUpgrade.fromJson(Map<String, dynamic> json) {
    return AppIgnoreUpgrade(
      appDetailID: (json['appDetailID'] as num?)?.toInt() ?? 0,
      appID: (json['appID'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      scope: json['scope'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'appDetailID': appDetailID,
      'appID': appID,
      'createdAt': createdAt,
      'id': id,
      'scope': scope,
      'updatedAt': updatedAt,
  };
}

class AppInstall {
  final App? app;
  final int appDetailId;
  final int appId;
  final String containerName;
  final String createdAt;
  final String description;
  final String dockerCompose;
  final String env;
  final bool favorite;
  final int httpPort;
  final int httpsPort;
  final int id;
  final String message;
  final String name;
  final String param;
  final String serviceName;
  final int sortOrder;
  final String status;
  final String updatedAt;
  final String version;
  final String webUI;

  const AppInstall({
    this.app,
    this.appDetailId = 0,
    this.appId = 0,
    this.containerName = '',
    this.createdAt = '',
    this.description = '',
    this.dockerCompose = '',
    this.env = '',
    this.favorite = false,
    this.httpPort = 0,
    this.httpsPort = 0,
    this.id = 0,
    this.message = '',
    this.name = '',
    this.param = '',
    this.serviceName = '',
    this.sortOrder = 0,
    this.status = '',
    this.updatedAt = '',
    this.version = '',
    this.webUI = '',
  });

  factory AppInstall.fromJson(Map<String, dynamic> json) {
    return AppInstall(
      app: json['app'] != null ? App.fromJson(json['app'] as Map<String, dynamic>) : null,
      appDetailId: (json['appDetailId'] as num?)?.toInt() ?? 0,
      appId: (json['appId'] as num?)?.toInt() ?? 0,
      containerName: json['containerName'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      description: json['description'] as String? ?? '',
      dockerCompose: json['dockerCompose'] as String? ?? '',
      env: json['env'] as String? ?? '',
      favorite: json['favorite'] as bool? ?? false,
      httpPort: (json['httpPort'] as num?)?.toInt() ?? 0,
      httpsPort: (json['httpsPort'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      name: json['name'] as String? ?? '',
      param: json['param'] as String? ?? '',
      serviceName: json['serviceName'] as String? ?? '',
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      version: json['version'] as String? ?? '',
      webUI: json['webUI'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      if (app != null) 'app': app!.toJson(),
      'appDetailId': appDetailId,
      'appId': appId,
      'containerName': containerName,
      'createdAt': createdAt,
      'description': description,
      'dockerCompose': dockerCompose,
      'env': env,
      'favorite': favorite,
      'httpPort': httpPort,
      'httpsPort': httpsPort,
      'id': id,
      'message': message,
      'name': name,
      'param': param,
      'serviceName': serviceName,
      'sortOrder': sortOrder,
      'status': status,
      'updatedAt': updatedAt,
      'version': version,
      'webUI': webUI,
  };
}

class AppConfigUpdate {
  final int installID;
  final String webUI;

  const AppConfigUpdate({
    this.installID = 0,
    this.webUI = '',
  });

  factory AppConfigUpdate.fromJson(Map<String, dynamic> json) {
    return AppConfigUpdate(
      installID: (json['installID'] as num?)?.toInt() ?? 0,
      webUI: json['webUI'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'installID': installID,
      'webUI': webUI,
  };
}

class AppIgnoreUpgradeReq {
  final int appDetailID;
  final int appID;
  final String scope;

  const AppIgnoreUpgradeReq({
    this.appDetailID = 0,
    this.appID = 0,
    this.scope = '',
  });

  factory AppIgnoreUpgradeReq.fromJson(Map<String, dynamic> json) {
    return AppIgnoreUpgradeReq(
      appDetailID: (json['appDetailID'] as num?)?.toInt() ?? 0,
      appID: (json['appID'] as num?)?.toInt() ?? 0,
      scope: json['scope'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'appDetailID': appDetailID,
      'appID': appID,
      'scope': scope,
  };
}

class AppInstallCreate {
  final bool advanced;
  final bool allowPort;
  final int appDetailId;
  final String appKey;
  final String containerName;
  final double cpuQuota;
  final String dockerCompose;
  final bool editCompose;
  final bool gpuConfig;
  final bool hostMode;
  final double memoryLimit;
  final String memoryUnit;
  final String name;
  final List<String> nodes;
  final Map<String, dynamic> params;
  final bool pullImage;
  final bool pushNode;
  final String restartPolicy;
  final Map<String, dynamic> services;
  final String specifyIP;
  final String taskID;
  final String type;
  final String version;
  final String webUI;

  const AppInstallCreate({
    this.advanced = false,
    this.allowPort = false,
    this.appDetailId = 0,
    this.appKey = '',
    this.containerName = '',
    this.cpuQuota = 0.0,
    this.dockerCompose = '',
    this.editCompose = false,
    this.gpuConfig = false,
    this.hostMode = false,
    this.memoryLimit = 0.0,
    this.memoryUnit = '',
    this.name = '',
    this.nodes = const [],
    this.params = const {},
    this.pullImage = false,
    this.pushNode = false,
    this.restartPolicy = '',
    this.services = const {},
    this.specifyIP = '',
    this.taskID = '',
    this.type = '',
    this.version = '',
    this.webUI = '',
  });

  factory AppInstallCreate.fromJson(Map<String, dynamic> json) {
    return AppInstallCreate(
      advanced: json['advanced'] as bool? ?? false,
      allowPort: json['allowPort'] as bool? ?? false,
      appDetailId: (json['appDetailId'] as num?)?.toInt() ?? 0,
      appKey: json['appKey'] as String? ?? '',
      containerName: json['containerName'] as String? ?? '',
      cpuQuota: (json['cpuQuota'] as num?)?.toDouble() ?? 0.0,
      dockerCompose: json['dockerCompose'] as String? ?? '',
      editCompose: json['editCompose'] as bool? ?? false,
      gpuConfig: json['gpuConfig'] as bool? ?? false,
      hostMode: json['hostMode'] as bool? ?? false,
      memoryLimit: (json['memoryLimit'] as num?)?.toDouble() ?? 0.0,
      memoryUnit: json['memoryUnit'] as String? ?? '',
      name: json['name'] as String? ?? '',
      nodes: (json['nodes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      params: json['params'] as Map<String, dynamic>? ?? const {},
      pullImage: json['pullImage'] as bool? ?? false,
      pushNode: json['pushNode'] as bool? ?? false,
      restartPolicy: json['restartPolicy'] as String? ?? '',
      services: json['services'] as Map<String, dynamic>? ?? const {},
      specifyIP: json['specifyIP'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      type: json['type'] as String? ?? '',
      version: json['version'] as String? ?? '',
      webUI: json['webUI'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'advanced': advanced,
      'allowPort': allowPort,
      'appDetailId': appDetailId,
      'appKey': appKey,
      'containerName': containerName,
      'cpuQuota': cpuQuota,
      'dockerCompose': dockerCompose,
      'editCompose': editCompose,
      'gpuConfig': gpuConfig,
      'hostMode': hostMode,
      'memoryLimit': memoryLimit,
      'memoryUnit': memoryUnit,
      'name': name,
      'nodes': nodes,
      'params': params,
      'pullImage': pullImage,
      'pushNode': pushNode,
      'restartPolicy': restartPolicy,
      'services': services,
      'specifyIP': specifyIP,
      'taskID': taskID,
      'type': type,
      'version': version,
      'webUI': webUI,
  };
}

class AppInstallSort {
  final List<AppInstallSortItem> items;

  const AppInstallSort({
    this.items = const [],
  });

  factory AppInstallSort.fromJson(Map<String, dynamic> json) {
    return AppInstallSort(
      items: (json['items'] as List<dynamic>?)?.map((e) => AppInstallSortItem.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'items': items.map((e) => e.toJson()).toList(),
  };
}

class AppInstallSortItem {
  final int installID;
  final int sortOrder;

  const AppInstallSortItem({
    this.installID = 0,
    this.sortOrder = 0,
  });

  factory AppInstallSortItem.fromJson(Map<String, dynamic> json) {
    return AppInstallSortItem(
      installID: (json['installID'] as num?)?.toInt() ?? 0,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'installID': installID,
      'sortOrder': sortOrder,
  };
}

class AppInstalledInfo {
  final String key;
  final String name;

  const AppInstalledInfo({
    this.key = '',
    this.name = '',
  });

  factory AppInstalledInfo.fromJson(Map<String, dynamic> json) {
    return AppInstalledInfo(
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'key': key,
      'name': name,
  };
}

class AppInstalledOperate {
  final bool backup;
  final int backupId;
  final bool deleteBackup;
  final bool deleteDB;
  final bool deleteImage;
  final int detailId;
  final String dockerCompose;
  final bool favorite;
  final bool forceDelete;
  final int installId;
  final String operate;
  final bool pullImage;
  final String taskID;

  const AppInstalledOperate({
    this.backup = false,
    this.backupId = 0,
    this.deleteBackup = false,
    this.deleteDB = false,
    this.deleteImage = false,
    this.detailId = 0,
    this.dockerCompose = '',
    this.favorite = false,
    this.forceDelete = false,
    this.installId = 0,
    this.operate = '',
    this.pullImage = false,
    this.taskID = '',
  });

  factory AppInstalledOperate.fromJson(Map<String, dynamic> json) {
    return AppInstalledOperate(
      backup: json['backup'] as bool? ?? false,
      backupId: (json['backupId'] as num?)?.toInt() ?? 0,
      deleteBackup: json['deleteBackup'] as bool? ?? false,
      deleteDB: json['deleteDB'] as bool? ?? false,
      deleteImage: json['deleteImage'] as bool? ?? false,
      detailId: (json['detailId'] as num?)?.toInt() ?? 0,
      dockerCompose: json['dockerCompose'] as String? ?? '',
      favorite: json['favorite'] as bool? ?? false,
      forceDelete: json['forceDelete'] as bool? ?? false,
      installId: (json['installId'] as num?)?.toInt() ?? 0,
      operate: json['operate'] as String? ?? '',
      pullImage: json['pullImage'] as bool? ?? false,
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'backup': backup,
      'backupId': backupId,
      'deleteBackup': deleteBackup,
      'deleteDB': deleteDB,
      'deleteImage': deleteImage,
      'detailId': detailId,
      'dockerCompose': dockerCompose,
      'favorite': favorite,
      'forceDelete': forceDelete,
      'installId': installId,
      'operate': operate,
      'pullImage': pullImage,
      'taskID': taskID,
  };
}

class AppInstalledSearch {
  final bool all;
  final bool checkUpdate;
  final String name;
  final int page;
  final int pageSize;
  final bool $sync;
  final List<String> tags;
  final String type;
  final bool unused;
  final bool update;

  const AppInstalledSearch({
    this.all = false,
    this.checkUpdate = false,
    this.name = '',
    this.page = 0,
    this.pageSize = 0,
    this.$sync = false,
    this.tags = const [],
    this.type = '',
    this.unused = false,
    this.update = false,
  });

  factory AppInstalledSearch.fromJson(Map<String, dynamic> json) {
    return AppInstalledSearch(
      all: json['all'] as bool? ?? false,
      checkUpdate: json['checkUpdate'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      $sync: json['sync'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      type: json['type'] as String? ?? '',
      unused: json['unused'] as bool? ?? false,
      update: json['update'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'all': all,
      'checkUpdate': checkUpdate,
      'name': name,
      'page': page,
      'pageSize': pageSize,
      'sync': $sync,
      'tags': tags,
      'type': type,
      'unused': unused,
      'update': update,
  };
}

class AppInstalledUpdate {
  final bool advanced;
  final bool allowPort;
  final String containerName;
  final double cpuQuota;
  final String dockerCompose;
  final bool editCompose;
  final bool gpuConfig;
  final bool hostMode;
  final int installId;
  final double memoryLimit;
  final String memoryUnit;
  final Map<String, dynamic> params;
  final bool pullImage;
  final String restartPolicy;
  final String specifyIP;
  final String type;
  final String webUI;

  const AppInstalledUpdate({
    this.advanced = false,
    this.allowPort = false,
    this.containerName = '',
    this.cpuQuota = 0.0,
    this.dockerCompose = '',
    this.editCompose = false,
    this.gpuConfig = false,
    this.hostMode = false,
    this.installId = 0,
    this.memoryLimit = 0.0,
    this.memoryUnit = '',
    this.params = const {},
    this.pullImage = false,
    this.restartPolicy = '',
    this.specifyIP = '',
    this.type = '',
    this.webUI = '',
  });

  factory AppInstalledUpdate.fromJson(Map<String, dynamic> json) {
    return AppInstalledUpdate(
      advanced: json['advanced'] as bool? ?? false,
      allowPort: json['allowPort'] as bool? ?? false,
      containerName: json['containerName'] as String? ?? '',
      cpuQuota: (json['cpuQuota'] as num?)?.toDouble() ?? 0.0,
      dockerCompose: json['dockerCompose'] as String? ?? '',
      editCompose: json['editCompose'] as bool? ?? false,
      gpuConfig: json['gpuConfig'] as bool? ?? false,
      hostMode: json['hostMode'] as bool? ?? false,
      installId: (json['installId'] as num?)?.toInt() ?? 0,
      memoryLimit: (json['memoryLimit'] as num?)?.toDouble() ?? 0.0,
      memoryUnit: json['memoryUnit'] as String? ?? '',
      params: json['params'] as Map<String, dynamic>? ?? const {},
      pullImage: json['pullImage'] as bool? ?? false,
      restartPolicy: json['restartPolicy'] as String? ?? '',
      specifyIP: json['specifyIP'] as String? ?? '',
      type: json['type'] as String? ?? '',
      webUI: json['webUI'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'advanced': advanced,
      'allowPort': allowPort,
      'containerName': containerName,
      'cpuQuota': cpuQuota,
      'dockerCompose': dockerCompose,
      'editCompose': editCompose,
      'gpuConfig': gpuConfig,
      'hostMode': hostMode,
      'installId': installId,
      'memoryLimit': memoryLimit,
      'memoryUnit': memoryUnit,
      'params': params,
      'pullImage': pullImage,
      'restartPolicy': restartPolicy,
      'specifyIP': specifyIP,
      'type': type,
      'webUI': webUI,
  };
}

class AppSearch {
  final String name;
  final int page;
  final int pageSize;
  final bool recommend;
  final String resource;
  final bool showCurrentArch;
  final List<String> tags;
  final String type;

  const AppSearch({
    this.name = '',
    this.page = 0,
    this.pageSize = 0,
    this.recommend = false,
    this.resource = '',
    this.showCurrentArch = false,
    this.tags = const [],
    this.type = '',
  });

  factory AppSearch.fromJson(Map<String, dynamic> json) {
    return AppSearch(
      name: json['name'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      recommend: json['recommend'] as bool? ?? false,
      resource: json['resource'] as String? ?? '',
      showCurrentArch: json['showCurrentArch'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'page': page,
      'pageSize': pageSize,
      'recommend': recommend,
      'resource': resource,
      'showCurrentArch': showCurrentArch,
      'tags': tags,
      'type': type,
  };
}

class PortUpdate {
  final String key;
  final String name;
  final int port;

  const PortUpdate({
    this.key = '',
    this.name = '',
    this.port = 0,
  });

  factory PortUpdate.fromJson(Map<String, dynamic> json) {
    return PortUpdate(
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'key': key,
      'name': name,
      'port': port,
  };
}

class ReqWithID {
  final int id;

  const ReqWithID({
    this.id = 0,
  });

  factory ReqWithID.fromJson(Map<String, dynamic> json) {
    return ReqWithID(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class AppConfig {
  final bool advanced;
  final bool allowPort;
  final String containerName;
  final double cpuQuota;
  final String dockerCompose;
  final bool editCompose;
  final bool gpuConfig;
  final bool hostMode;
  final double memoryLimit;
  final String memoryUnit;
  final List<AppParam> params;
  final bool pullImage;
  final String rawCompose;
  final String restartPolicy;
  final String specifyIP;
  final String type;
  final String webUI;

  const AppConfig({
    this.advanced = false,
    this.allowPort = false,
    this.containerName = '',
    this.cpuQuota = 0.0,
    this.dockerCompose = '',
    this.editCompose = false,
    this.gpuConfig = false,
    this.hostMode = false,
    this.memoryLimit = 0.0,
    this.memoryUnit = '',
    this.params = const [],
    this.pullImage = false,
    this.rawCompose = '',
    this.restartPolicy = '',
    this.specifyIP = '',
    this.type = '',
    this.webUI = '',
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      advanced: json['advanced'] as bool? ?? false,
      allowPort: json['allowPort'] as bool? ?? false,
      containerName: json['containerName'] as String? ?? '',
      cpuQuota: (json['cpuQuota'] as num?)?.toDouble() ?? 0.0,
      dockerCompose: json['dockerCompose'] as String? ?? '',
      editCompose: json['editCompose'] as bool? ?? false,
      gpuConfig: json['gpuConfig'] as bool? ?? false,
      hostMode: json['hostMode'] as bool? ?? false,
      memoryLimit: (json['memoryLimit'] as num?)?.toDouble() ?? 0.0,
      memoryUnit: json['memoryUnit'] as String? ?? '',
      params: (json['params'] as List<dynamic>?)?.map((e) => AppParam.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      pullImage: json['pullImage'] as bool? ?? false,
      rawCompose: json['rawCompose'] as String? ?? '',
      restartPolicy: json['restartPolicy'] as String? ?? '',
      specifyIP: json['specifyIP'] as String? ?? '',
      type: json['type'] as String? ?? '',
      webUI: json['webUI'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'advanced': advanced,
      'allowPort': allowPort,
      'containerName': containerName,
      'cpuQuota': cpuQuota,
      'dockerCompose': dockerCompose,
      'editCompose': editCompose,
      'gpuConfig': gpuConfig,
      'hostMode': hostMode,
      'memoryLimit': memoryLimit,
      'memoryUnit': memoryUnit,
      'params': params.map((e) => e.toJson()).toList(),
      'pullImage': pullImage,
      'rawCompose': rawCompose,
      'restartPolicy': restartPolicy,
      'specifyIP': specifyIP,
      'type': type,
      'webUI': webUI,
  };
}

class AppDTO {
  final String architectures;
  final bool batchInstallSupport;
  final String createdAt;
  final bool crossVersionUpdate;
  final String description;
  final String document;
  final String github;
  final bool gpuSupport;
  final String icon;
  final int id;
  final bool installed;
  final String key;
  final int lastModified;
  final int limit;
  final int memoryRequired;
  final String name;
  final String readMe;
  final int recommend;
  final String required;
  final double requiredPanelVersion;
  final String resource;
  final String shortDescEn;
  final String shortDescZh;
  final String status;
  final List<TagDTO> tags;
  final String type;
  final String updatedAt;
  final List<String> versions;
  final String website;

  const AppDTO({
    this.architectures = '',
    this.batchInstallSupport = false,
    this.createdAt = '',
    this.crossVersionUpdate = false,
    this.description = '',
    this.document = '',
    this.github = '',
    this.gpuSupport = false,
    this.icon = '',
    this.id = 0,
    this.installed = false,
    this.key = '',
    this.lastModified = 0,
    this.limit = 0,
    this.memoryRequired = 0,
    this.name = '',
    this.readMe = '',
    this.recommend = 0,
    this.required = '',
    this.requiredPanelVersion = 0.0,
    this.resource = '',
    this.shortDescEn = '',
    this.shortDescZh = '',
    this.status = '',
    this.tags = const [],
    this.type = '',
    this.updatedAt = '',
    this.versions = const [],
    this.website = '',
  });

  factory AppDTO.fromJson(Map<String, dynamic> json) {
    return AppDTO(
      architectures: json['architectures'] as String? ?? '',
      batchInstallSupport: json['batchInstallSupport'] as bool? ?? false,
      createdAt: json['createdAt'] as String? ?? '',
      crossVersionUpdate: json['crossVersionUpdate'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      document: json['document'] as String? ?? '',
      github: json['github'] as String? ?? '',
      gpuSupport: json['gpuSupport'] as bool? ?? false,
      icon: json['icon'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      installed: json['installed'] as bool? ?? false,
      key: json['key'] as String? ?? '',
      lastModified: (json['lastModified'] as num?)?.toInt() ?? 0,
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      memoryRequired: (json['memoryRequired'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      readMe: json['readMe'] as String? ?? '',
      recommend: (json['recommend'] as num?)?.toInt() ?? 0,
      required: json['required'] as String? ?? '',
      requiredPanelVersion: (json['requiredPanelVersion'] as num?)?.toDouble() ?? 0.0,
      resource: json['resource'] as String? ?? '',
      shortDescEn: json['shortDescEn'] as String? ?? '',
      shortDescZh: json['shortDescZh'] as String? ?? '',
      status: json['status'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => TagDTO.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      type: json['type'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      versions: (json['versions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      website: json['website'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'architectures': architectures,
      'batchInstallSupport': batchInstallSupport,
      'createdAt': createdAt,
      'crossVersionUpdate': crossVersionUpdate,
      'description': description,
      'document': document,
      'github': github,
      'gpuSupport': gpuSupport,
      'icon': icon,
      'id': id,
      'installed': installed,
      'key': key,
      'lastModified': lastModified,
      'limit': limit,
      'memoryRequired': memoryRequired,
      'name': name,
      'readMe': readMe,
      'recommend': recommend,
      'required': required,
      'requiredPanelVersion': requiredPanelVersion,
      'resource': resource,
      'shortDescEn': shortDescEn,
      'shortDescZh': shortDescZh,
      'status': status,
      'tags': tags.map((e) => e.toJson()).toList(),
      'type': type,
      'updatedAt': updatedAt,
      'versions': versions,
      'website': website,
  };
}

class AppDetailDTO {
  final int appId;
  final String architectures;
  final String createdAt;
  final String dockerCompose;
  final String downloadCallBackUrl;
  final String downloadUrl;
  final bool enable;
  final bool gpuSupport;
  final bool hostMode;
  final int id;
  final String image;
  final int lastModified;
  final String lastVersion;
  final int memoryRequired;
  final dynamic params;
  final String status;
  final bool update;
  final String updatedAt;
  final String version;

  const AppDetailDTO({
    this.appId = 0,
    this.architectures = '',
    this.createdAt = '',
    this.dockerCompose = '',
    this.downloadCallBackUrl = '',
    this.downloadUrl = '',
    this.enable = false,
    this.gpuSupport = false,
    this.hostMode = false,
    this.id = 0,
    this.image = '',
    this.lastModified = 0,
    this.lastVersion = '',
    this.memoryRequired = 0,
    this.params,
    this.status = '',
    this.update = false,
    this.updatedAt = '',
    this.version = '',
  });

  factory AppDetailDTO.fromJson(Map<String, dynamic> json) {
    return AppDetailDTO(
      appId: (json['appId'] as num?)?.toInt() ?? 0,
      architectures: json['architectures'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      dockerCompose: json['dockerCompose'] as String? ?? '',
      downloadCallBackUrl: json['downloadCallBackUrl'] as String? ?? '',
      downloadUrl: json['downloadUrl'] as String? ?? '',
      enable: json['enable'] as bool? ?? false,
      gpuSupport: json['gpuSupport'] as bool? ?? false,
      hostMode: json['hostMode'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
      image: json['image'] as String? ?? '',
      lastModified: (json['lastModified'] as num?)?.toInt() ?? 0,
      lastVersion: json['lastVersion'] as String? ?? '',
      memoryRequired: (json['memoryRequired'] as num?)?.toInt() ?? 0,
      params: json['params'],
      status: json['status'] as String? ?? '',
      update: json['update'] as bool? ?? false,
      updatedAt: json['updatedAt'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'appId': appId,
      'architectures': architectures,
      'createdAt': createdAt,
      'dockerCompose': dockerCompose,
      'downloadCallBackUrl': downloadCallBackUrl,
      'downloadUrl': downloadUrl,
      'enable': enable,
      'gpuSupport': gpuSupport,
      'hostMode': hostMode,
      'id': id,
      'image': image,
      'lastModified': lastModified,
      'lastVersion': lastVersion,
      'memoryRequired': memoryRequired,
      'params': params,
      'status': status,
      'update': update,
      'updatedAt': updatedAt,
      'version': version,
  };
}

class AppDetailSimpleDTO {
  final int id;

  const AppDetailSimpleDTO({
    this.id = 0,
  });

  factory AppDetailSimpleDTO.fromJson(Map<String, dynamic> json) {
    return AppDetailSimpleDTO(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class AppInstalledCheck {
  final String app;
  final int appInstallId;
  final String containerName;
  final String createdAt;
  final int httpPort;
  final int httpsPort;
  final String installPath;
  final bool isExist;
  final String lastBackupAt;
  final String name;
  final String status;
  final String version;
  final String websiteDir;

  const AppInstalledCheck({
    this.app = '',
    this.appInstallId = 0,
    this.containerName = '',
    this.createdAt = '',
    this.httpPort = 0,
    this.httpsPort = 0,
    this.installPath = '',
    this.isExist = false,
    this.lastBackupAt = '',
    this.name = '',
    this.status = '',
    this.version = '',
    this.websiteDir = '',
  });

  factory AppInstalledCheck.fromJson(Map<String, dynamic> json) {
    return AppInstalledCheck(
      app: json['app'] as String? ?? '',
      appInstallId: (json['appInstallId'] as num?)?.toInt() ?? 0,
      containerName: json['containerName'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      httpPort: (json['httpPort'] as num?)?.toInt() ?? 0,
      httpsPort: (json['httpsPort'] as num?)?.toInt() ?? 0,
      installPath: json['installPath'] as String? ?? '',
      isExist: json['isExist'] as bool? ?? false,
      lastBackupAt: json['lastBackupAt'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      version: json['version'] as String? ?? '',
      websiteDir: json['websiteDir'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'app': app,
      'appInstallId': appInstallId,
      'containerName': containerName,
      'createdAt': createdAt,
      'httpPort': httpPort,
      'httpsPort': httpsPort,
      'installPath': installPath,
      'isExist': isExist,
      'lastBackupAt': lastBackupAt,
      'name': name,
      'status': status,
      'version': version,
      'websiteDir': websiteDir,
  };
}

class AppItem {
  final bool batchInstallSupport;
  final String description;
  final bool gpuSupport;
  final int id;
  final bool installed;
  final String key;
  final int limit;
  final String name;
  final int recommend;
  final String status;
  final List<String> tags;
  final String type;

  const AppItem({
    this.batchInstallSupport = false,
    this.description = '',
    this.gpuSupport = false,
    this.id = 0,
    this.installed = false,
    this.key = '',
    this.limit = 0,
    this.name = '',
    this.recommend = 0,
    this.status = '',
    this.tags = const [],
    this.type = '',
  });

  factory AppItem.fromJson(Map<String, dynamic> json) {
    return AppItem(
      batchInstallSupport: json['batchInstallSupport'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      gpuSupport: json['gpuSupport'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
      installed: json['installed'] as bool? ?? false,
      key: json['key'] as String? ?? '',
      limit: (json['limit'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      recommend: (json['recommend'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'batchInstallSupport': batchInstallSupport,
      'description': description,
      'gpuSupport': gpuSupport,
      'id': id,
      'installed': installed,
      'key': key,
      'limit': limit,
      'name': name,
      'recommend': recommend,
      'status': status,
      'tags': tags,
      'type': type,
  };
}

class AppParam {
  final bool edit;
  final String key;
  final Locale? label;
  final String labelEn;
  final String labelZh;
  final bool multiple;
  final bool required;
  final String rule;
  final String showValue;
  final String type;
  final dynamic value;
  final dynamic values;

  const AppParam({
    this.edit = false,
    this.key = '',
    this.label,
    this.labelEn = '',
    this.labelZh = '',
    this.multiple = false,
    this.required = false,
    this.rule = '',
    this.showValue = '',
    this.type = '',
    this.value,
    this.values,
  });

  factory AppParam.fromJson(Map<String, dynamic> json) {
    return AppParam(
      edit: json['edit'] as bool? ?? false,
      key: json['key'] as String? ?? '',
      label: json['label'] != null ? Locale.fromJson(json['label'] as Map<String, dynamic>) : null,
      labelEn: json['labelEn'] as String? ?? '',
      labelZh: json['labelZh'] as String? ?? '',
      multiple: json['multiple'] as bool? ?? false,
      required: json['required'] as bool? ?? false,
      rule: json['rule'] as String? ?? '',
      showValue: json['showValue'] as String? ?? '',
      type: json['type'] as String? ?? '',
      value: json['value'],
      values: json['values'],
    );
  }

  Map<String, dynamic> toJson() => {
      'edit': edit,
      'key': key,
      if (label != null) 'label': label!.toJson(),
      'labelEn': labelEn,
      'labelZh': labelZh,
      'multiple': multiple,
      'required': required,
      'rule': rule,
      'showValue': showValue,
      'type': type,
      'value': value,
      'values': values,
  };
}

class AppRes {
  final List<AppItem> items;
  final int total;

  const AppRes({
    this.items = const [],
    this.total = 0,
  });

  factory AppRes.fromJson(Map<String, dynamic> json) {
    return AppRes(
      items: (json['items'] as List<dynamic>?)?.map((e) => AppItem.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
  };
}

class AppService {
  final dynamic config;
  final String from;
  final String label;
  final String status;
  final String value;

  const AppService({
    this.config,
    this.from = '',
    this.label = '',
    this.status = '',
    this.value = '',
  });

  factory AppService.fromJson(Map<String, dynamic> json) {
    return AppService(
      config: json['config'],
      from: json['from'] as String? ?? '',
      label: json['label'] as String? ?? '',
      status: json['status'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'config': config,
      'from': from,
      'label': label,
      'status': status,
      'value': value,
  };
}

class AppUpdateRes {
  final AppList? appList;
  final int appStoreLastModified;
  final bool canUpdate;
  final bool isSyncing;

  const AppUpdateRes({
    this.appList,
    this.appStoreLastModified = 0,
    this.canUpdate = false,
    this.isSyncing = false,
  });

  factory AppUpdateRes.fromJson(Map<String, dynamic> json) {
    return AppUpdateRes(
      appList: json['appList'] != null ? AppList.fromJson(json['appList'] as Map<String, dynamic>) : null,
      appStoreLastModified: (json['appStoreLastModified'] as num?)?.toInt() ?? 0,
      canUpdate: json['canUpdate'] as bool? ?? false,
      isSyncing: json['isSyncing'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      if (appList != null) 'appList': appList!.toJson(),
      'appStoreLastModified': appStoreLastModified,
      'canUpdate': canUpdate,
      'isSyncing': isSyncing,
  };
}

class DatabaseConn {
  final String containerName;
  final String password;
  final int port;
  final String serviceName;
  final String status;
  final String username;

  const DatabaseConn({
    this.containerName = '',
    this.password = '',
    this.port = 0,
    this.serviceName = '',
    this.status = '',
    this.username = '',
  });

  factory DatabaseConn.fromJson(Map<String, dynamic> json) {
    return DatabaseConn(
      containerName: json['containerName'] as String? ?? '',
      password: json['password'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      serviceName: json['serviceName'] as String? ?? '',
      status: json['status'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'containerName': containerName,
      'password': password,
      'port': port,
      'serviceName': serviceName,
      'status': status,
      'username': username,
  };
}

class TagDTO {
  final int id;
  final String key;
  final String name;

  const TagDTO({
    this.id = 0,
    this.key = '',
    this.name = '',
  });

  factory TagDTO.fromJson(Map<String, dynamic> json) {
    return TagDTO(
      id: (json['id'] as num?)?.toInt() ?? 0,
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'key': key,
      'name': name,
  };
}
