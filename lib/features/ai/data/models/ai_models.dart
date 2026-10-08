// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

class AgentAccountCreateReq {
  final String apiKey;
  final String apiType;
  final String authMode;
  final String baseURL;
  final List<AgentAccountModel> models;
  final String name;
  final String provider;
  final String remark;
  final bool rememberApiKey;
  final bool validateAvailability;
  final String verifyModel;

  const AgentAccountCreateReq({
    this.apiKey = '',
    this.apiType = '',
    this.authMode = '',
    this.baseURL = '',
    this.models = const [],
    this.name = '',
    this.provider = '',
    this.remark = '',
    this.rememberApiKey = false,
    this.validateAvailability = false,
    this.verifyModel = '',
  });

  factory AgentAccountCreateReq.fromJson(Map<String, dynamic> json) {
    return AgentAccountCreateReq(
      apiKey: json['apiKey'] as String? ?? '',
      apiType: json['apiType'] as String? ?? '',
      authMode: json['authMode'] as String? ?? '',
      baseURL: json['baseURL'] as String? ?? '',
      models: (json['models'] as List<dynamic>?)?.map((e) => AgentAccountModel.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      name: json['name'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      rememberApiKey: json['rememberApiKey'] as bool? ?? false,
      validateAvailability: json['validateAvailability'] as bool? ?? false,
      verifyModel: json['verifyModel'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'apiKey': apiKey,
      'apiType': apiType,
      'authMode': authMode,
      'baseURL': baseURL,
      'models': models.map((e) => e.toJson()).toList(),
      'name': name,
      'provider': provider,
      'remark': remark,
      'rememberApiKey': rememberApiKey,
      'validateAvailability': validateAvailability,
      'verifyModel': verifyModel,
  };
}

class AgentAccountDeleteReq {
  final int id;

  const AgentAccountDeleteReq({
    this.id = 0,
  });

  factory AgentAccountDeleteReq.fromJson(Map<String, dynamic> json) {
    return AgentAccountDeleteReq(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class AgentAccountInfo {
  final String apiKey;
  final String apiType;
  final String authMode;
  final String baseUrl;
  final String createdAt;
  final int id;
  final int masterAccountId;
  final List<AgentAccountModel> models;
  final String name;
  final String provider;
  final String providerName;
  final String remark;
  final bool rememberApiKey;
  final bool verified;
  final String verifyModel;

  const AgentAccountInfo({
    this.apiKey = '',
    this.apiType = '',
    this.authMode = '',
    this.baseUrl = '',
    this.createdAt = '',
    this.id = 0,
    this.masterAccountId = 0,
    this.models = const [],
    this.name = '',
    this.provider = '',
    this.providerName = '',
    this.remark = '',
    this.rememberApiKey = false,
    this.verified = false,
    this.verifyModel = '',
  });

  factory AgentAccountInfo.fromJson(Map<String, dynamic> json) {
    return AgentAccountInfo(
      apiKey: json['apiKey'] as String? ?? '',
      apiType: json['apiType'] as String? ?? '',
      authMode: json['authMode'] as String? ?? '',
      baseUrl: json['baseUrl'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      masterAccountId: (json['masterAccountId'] as num?)?.toInt() ?? 0,
      models: (json['models'] as List<dynamic>?)?.map((e) => AgentAccountModel.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      name: json['name'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      providerName: json['providerName'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      rememberApiKey: json['rememberApiKey'] as bool? ?? false,
      verified: json['verified'] as bool? ?? false,
      verifyModel: json['verifyModel'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'apiKey': apiKey,
      'apiType': apiType,
      'authMode': authMode,
      'baseUrl': baseUrl,
      'createdAt': createdAt,
      'id': id,
      'masterAccountId': masterAccountId,
      'models': models.map((e) => e.toJson()).toList(),
      'name': name,
      'provider': provider,
      'providerName': providerName,
      'remark': remark,
      'rememberApiKey': rememberApiKey,
      'verified': verified,
      'verifyModel': verifyModel,
  };
}

class AgentAccountModel {
  final String id;
  final String name;
  final int recordId;

  const AgentAccountModel({
    this.id = '',
    this.name = '',
    this.recordId = 0,
  });

  factory AgentAccountModel.fromJson(Map<String, dynamic> json) {
    return AgentAccountModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      recordId: (json['recordId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'recordId': recordId,
  };
}

class AgentAccountModelCreateReq {
  final int accountId;
  final AgentAccountModel? model;

  const AgentAccountModelCreateReq({
    this.accountId = 0,
    this.model,
  });

  factory AgentAccountModelCreateReq.fromJson(Map<String, dynamic> json) {
    return AgentAccountModelCreateReq(
      accountId: (json['accountId'] as num?)?.toInt() ?? 0,
      model: json['model'] != null ? AgentAccountModel.fromJson(json['model'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      if (model != null) 'model': model!.toJson(),
  };
}

class AgentAccountModelDeleteReq {
  final int accountId;
  final int recordId;

  const AgentAccountModelDeleteReq({
    this.accountId = 0,
    this.recordId = 0,
  });

  factory AgentAccountModelDeleteReq.fromJson(Map<String, dynamic> json) {
    return AgentAccountModelDeleteReq(
      accountId: (json['accountId'] as num?)?.toInt() ?? 0,
      recordId: (json['recordId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'recordId': recordId,
  };
}

class AgentAccountModelDiscoverReq {
  final String apiKey;
  final String apiType;
  final String baseURL;
  final String provider;

  const AgentAccountModelDiscoverReq({
    this.apiKey = '',
    this.apiType = '',
    this.baseURL = '',
    this.provider = '',
  });

  factory AgentAccountModelDiscoverReq.fromJson(Map<String, dynamic> json) {
    return AgentAccountModelDiscoverReq(
      apiKey: json['apiKey'] as String? ?? '',
      apiType: json['apiType'] as String? ?? '',
      baseURL: json['baseURL'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'apiKey': apiKey,
      'apiType': apiType,
      'baseURL': baseURL,
      'provider': provider,
  };
}

class AgentAccountModelReq {
  final int accountId;

  const AgentAccountModelReq({
    this.accountId = 0,
  });

  factory AgentAccountModelReq.fromJson(Map<String, dynamic> json) {
    return AgentAccountModelReq(
      accountId: (json['accountId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
  };
}

class AgentAccountModelUpdateReq {
  final int accountId;
  final AgentAccountModel? model;

  const AgentAccountModelUpdateReq({
    this.accountId = 0,
    this.model,
  });

  factory AgentAccountModelUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentAccountModelUpdateReq(
      accountId: (json['accountId'] as num?)?.toInt() ?? 0,
      model: json['model'] != null ? AgentAccountModel.fromJson(json['model'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      if (model != null) 'model': model!.toJson(),
  };
}

class AgentAccountProviderCountReq {
  final List<String> providers;

  const AgentAccountProviderCountReq({
    this.providers = const [],
  });

  factory AgentAccountProviderCountReq.fromJson(Map<String, dynamic> json) {
    return AgentAccountProviderCountReq(
      providers: (json['providers'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'providers': providers,
  };
}

class AgentAccountSearch {
  final String apiType;
  final String name;
  final int page;
  final int pageSize;
  final String provider;
  final bool textOnly;

  const AgentAccountSearch({
    this.apiType = '',
    this.name = '',
    this.page = 0,
    this.pageSize = 0,
    this.provider = '',
    this.textOnly = false,
  });

  factory AgentAccountSearch.fromJson(Map<String, dynamic> json) {
    return AgentAccountSearch(
      apiType: json['apiType'] as String? ?? '',
      name: json['name'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      provider: json['provider'] as String? ?? '',
      textOnly: json['textOnly'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'apiType': apiType,
      'name': name,
      'page': page,
      'pageSize': pageSize,
      'provider': provider,
      'textOnly': textOnly,
  };
}

class AgentAccountUpdateReq {
  final String apiKey;
  final String apiType;
  final String authMode;
  final String baseURL;
  final int id;
  final String name;
  final String remark;
  final bool rememberApiKey;
  final bool syncAgents;
  final bool validateAvailability;
  final String verifyModel;

  const AgentAccountUpdateReq({
    this.apiKey = '',
    this.apiType = '',
    this.authMode = '',
    this.baseURL = '',
    this.id = 0,
    this.name = '',
    this.remark = '',
    this.rememberApiKey = false,
    this.syncAgents = false,
    this.validateAvailability = false,
    this.verifyModel = '',
  });

  factory AgentAccountUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentAccountUpdateReq(
      apiKey: json['apiKey'] as String? ?? '',
      apiType: json['apiType'] as String? ?? '',
      authMode: json['authMode'] as String? ?? '',
      baseURL: json['baseURL'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      rememberApiKey: json['rememberApiKey'] as bool? ?? false,
      syncAgents: json['syncAgents'] as bool? ?? false,
      validateAvailability: json['validateAvailability'] as bool? ?? false,
      verifyModel: json['verifyModel'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'apiKey': apiKey,
      'apiType': apiType,
      'authMode': authMode,
      'baseURL': baseURL,
      'id': id,
      'name': name,
      'remark': remark,
      'rememberApiKey': rememberApiKey,
      'syncAgents': syncAgents,
      'validateAvailability': validateAvailability,
      'verifyModel': verifyModel,
  };
}

class AgentAccountVerifyReq {
  final String apiKey;
  final String apiType;
  final String authMode;
  final String baseURL;
  final String model;
  final String provider;

  const AgentAccountVerifyReq({
    this.apiKey = '',
    this.apiType = '',
    this.authMode = '',
    this.baseURL = '',
    this.model = '',
    this.provider = '',
  });

  factory AgentAccountVerifyReq.fromJson(Map<String, dynamic> json) {
    return AgentAccountVerifyReq(
      apiKey: json['apiKey'] as String? ?? '',
      apiType: json['apiType'] as String? ?? '',
      authMode: json['authMode'] as String? ?? '',
      baseURL: json['baseURL'] as String? ?? '',
      model: json['model'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'apiKey': apiKey,
      'apiType': apiType,
      'authMode': authMode,
      'baseURL': baseURL,
      'model': model,
      'provider': provider,
  };
}

class AgentBatchInstallReq {
  final int accountId;
  final List<AgentAccountModel> accountModels;
  final AgentAccountInfo? accountSnapshot;
  final bool advanced;
  final String agentType;
  final bool allowPort;
  final List<String> allowedOrigins;
  final String appVersion;
  final int bridgePort;
  final String containerName;
  final double cpuQuota;
  final String dashboardPassword;
  final String dashboardUsername;
  final String dockerCompose;
  final bool editCompose;
  final String fallbackAccessHost;
  final int masterAccountId;
  final double memoryLimit;
  final String memoryUnit;
  final String model;
  final String name;
  final bool pullImage;
  final String remark;
  final String restartPolicy;
  final String specifyIP;
  final String taskID;
  final String token;
  final int webUIPort;

  const AgentBatchInstallReq({
    this.accountId = 0,
    this.accountModels = const [],
    this.accountSnapshot,
    this.advanced = false,
    this.agentType = '',
    this.allowPort = false,
    this.allowedOrigins = const [],
    this.appVersion = '',
    this.bridgePort = 0,
    this.containerName = '',
    this.cpuQuota = 0.0,
    this.dashboardPassword = '',
    this.dashboardUsername = '',
    this.dockerCompose = '',
    this.editCompose = false,
    this.fallbackAccessHost = '',
    this.masterAccountId = 0,
    this.memoryLimit = 0.0,
    this.memoryUnit = '',
    this.model = '',
    this.name = '',
    this.pullImage = false,
    this.remark = '',
    this.restartPolicy = '',
    this.specifyIP = '',
    this.taskID = '',
    this.token = '',
    this.webUIPort = 0,
  });

  factory AgentBatchInstallReq.fromJson(Map<String, dynamic> json) {
    return AgentBatchInstallReq(
      accountId: (json['accountId'] as num?)?.toInt() ?? 0,
      accountModels: (json['accountModels'] as List<dynamic>?)?.map((e) => AgentAccountModel.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      accountSnapshot: json['accountSnapshot'] != null ? AgentAccountInfo.fromJson(json['accountSnapshot'] as Map<String, dynamic>) : null,
      advanced: json['advanced'] as bool? ?? false,
      agentType: json['agentType'] as String? ?? '',
      allowPort: json['allowPort'] as bool? ?? false,
      allowedOrigins: (json['allowedOrigins'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      appVersion: json['appVersion'] as String? ?? '',
      bridgePort: (json['bridgePort'] as num?)?.toInt() ?? 0,
      containerName: json['containerName'] as String? ?? '',
      cpuQuota: (json['cpuQuota'] as num?)?.toDouble() ?? 0.0,
      dashboardPassword: json['dashboardPassword'] as String? ?? '',
      dashboardUsername: json['dashboardUsername'] as String? ?? '',
      dockerCompose: json['dockerCompose'] as String? ?? '',
      editCompose: json['editCompose'] as bool? ?? false,
      fallbackAccessHost: json['fallbackAccessHost'] as String? ?? '',
      masterAccountId: (json['masterAccountId'] as num?)?.toInt() ?? 0,
      memoryLimit: (json['memoryLimit'] as num?)?.toDouble() ?? 0.0,
      memoryUnit: json['memoryUnit'] as String? ?? '',
      model: json['model'] as String? ?? '',
      name: json['name'] as String? ?? '',
      pullImage: json['pullImage'] as bool? ?? false,
      remark: json['remark'] as String? ?? '',
      restartPolicy: json['restartPolicy'] as String? ?? '',
      specifyIP: json['specifyIP'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      token: json['token'] as String? ?? '',
      webUIPort: (json['webUIPort'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'accountModels': accountModels.map((e) => e.toJson()).toList(),
      if (accountSnapshot != null) 'accountSnapshot': accountSnapshot!.toJson(),
      'advanced': advanced,
      'agentType': agentType,
      'allowPort': allowPort,
      'allowedOrigins': allowedOrigins,
      'appVersion': appVersion,
      'bridgePort': bridgePort,
      'containerName': containerName,
      'cpuQuota': cpuQuota,
      'dashboardPassword': dashboardPassword,
      'dashboardUsername': dashboardUsername,
      'dockerCompose': dockerCompose,
      'editCompose': editCompose,
      'fallbackAccessHost': fallbackAccessHost,
      'masterAccountId': masterAccountId,
      'memoryLimit': memoryLimit,
      'memoryUnit': memoryUnit,
      'model': model,
      'name': name,
      'pullImage': pullImage,
      'remark': remark,
      'restartPolicy': restartPolicy,
      'specifyIP': specifyIP,
      'taskID': taskID,
      'token': token,
      'webUIPort': webUIPort,
  };
}

class AgentBatchOperateReq {
  final String agentType;
  final bool forceDelete;
  final String operate;
  final String taskID;

  const AgentBatchOperateReq({
    this.agentType = '',
    this.forceDelete = false,
    this.operate = '',
    this.taskID = '',
  });

  factory AgentBatchOperateReq.fromJson(Map<String, dynamic> json) {
    return AgentBatchOperateReq(
      agentType: json['agentType'] as String? ?? '',
      forceDelete: json['forceDelete'] as bool? ?? false,
      operate: json['operate'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentType': agentType,
      'forceDelete': forceDelete,
      'operate': operate,
      'taskID': taskID,
  };
}

class AgentBatchOperateResult {
  final int agentID;
  final String agentName;
  final int appInstallID;
  final String message;
  final bool skipped;
  final bool success;

  const AgentBatchOperateResult({
    this.agentID = 0,
    this.agentName = '',
    this.appInstallID = 0,
    this.message = '',
    this.skipped = false,
    this.success = false,
  });

  factory AgentBatchOperateResult.fromJson(Map<String, dynamic> json) {
    return AgentBatchOperateResult(
      agentID: (json['agentID'] as num?)?.toInt() ?? 0,
      agentName: json['agentName'] as String? ?? '',
      appInstallID: (json['appInstallID'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      skipped: json['skipped'] as bool? ?? false,
      success: json['success'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentID': agentID,
      'agentName': agentName,
      'appInstallID': appInstallID,
      'message': message,
      'skipped': skipped,
      'success': success,
  };
}

class AgentBatchSkillInstallReq {
  final String agentType;
  final String packagePath;
  final String skillName;
  final String taskID;

  const AgentBatchSkillInstallReq({
    this.agentType = '',
    this.packagePath = '',
    this.skillName = '',
    this.taskID = '',
  });

  factory AgentBatchSkillInstallReq.fromJson(Map<String, dynamic> json) {
    return AgentBatchSkillInstallReq(
      agentType: json['agentType'] as String? ?? '',
      packagePath: json['packagePath'] as String? ?? '',
      skillName: json['skillName'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentType': agentType,
      'packagePath': packagePath,
      'skillName': skillName,
      'taskID': taskID,
  };
}

class AgentBatchSkillInstallResult {
  final int agentID;
  final String agentName;
  final int appInstallID;
  final String message;
  final bool skipped;
  final bool success;

  const AgentBatchSkillInstallResult({
    this.agentID = 0,
    this.agentName = '',
    this.appInstallID = 0,
    this.message = '',
    this.skipped = false,
    this.success = false,
  });

  factory AgentBatchSkillInstallResult.fromJson(Map<String, dynamic> json) {
    return AgentBatchSkillInstallResult(
      agentID: (json['agentID'] as num?)?.toInt() ?? 0,
      agentName: json['agentName'] as String? ?? '',
      appInstallID: (json['appInstallID'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      skipped: json['skipped'] as bool? ?? false,
      success: json['success'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentID': agentID,
      'agentName': agentName,
      'appInstallID': appInstallID,
      'message': message,
      'skipped': skipped,
      'success': success,
  };
}

class AgentBatchUpgradeReq {
  final String agentType;
  final bool backup;
  final bool pullImage;
  final String targetVersion;
  final String taskID;

  const AgentBatchUpgradeReq({
    this.agentType = '',
    this.backup = false,
    this.pullImage = false,
    this.targetVersion = '',
    this.taskID = '',
  });

  factory AgentBatchUpgradeReq.fromJson(Map<String, dynamic> json) {
    return AgentBatchUpgradeReq(
      agentType: json['agentType'] as String? ?? '',
      backup: json['backup'] as bool? ?? false,
      pullImage: json['pullImage'] as bool? ?? false,
      targetVersion: json['targetVersion'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentType': agentType,
      'backup': backup,
      'pullImage': pullImage,
      'targetVersion': targetVersion,
      'taskID': taskID,
  };
}

class AgentBatchUpgradeResult {
  final int agentID;
  final String agentName;
  final int appInstallID;
  final String message;
  final bool skipped;
  final bool success;

  const AgentBatchUpgradeResult({
    this.agentID = 0,
    this.agentName = '',
    this.appInstallID = 0,
    this.message = '',
    this.skipped = false,
    this.success = false,
  });

  factory AgentBatchUpgradeResult.fromJson(Map<String, dynamic> json) {
    return AgentBatchUpgradeResult(
      agentID: (json['agentID'] as num?)?.toInt() ?? 0,
      agentName: json['agentName'] as String? ?? '',
      appInstallID: (json['appInstallID'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      skipped: json['skipped'] as bool? ?? false,
      success: json['success'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentID': agentID,
      'agentName': agentName,
      'appInstallID': appInstallID,
      'message': message,
      'skipped': skipped,
      'success': success,
  };
}

class AgentChannelDeleteReq {
  final int agentId;
  final String type;

  const AgentChannelDeleteReq({
    this.agentId = 0,
    this.type = '',
  });

  factory AgentChannelDeleteReq.fromJson(Map<String, dynamic> json) {
    return AgentChannelDeleteReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'type': type,
  };
}

class AgentChannelPairingApproveReq {
  final String accountId;
  final int agentId;
  final String pairingCode;
  final String type;

  const AgentChannelPairingApproveReq({
    this.accountId = '',
    this.agentId = 0,
    this.pairingCode = '',
    this.type = '',
  });

  factory AgentChannelPairingApproveReq.fromJson(Map<String, dynamic> json) {
    return AgentChannelPairingApproveReq(
      accountId: json['accountId'] as String? ?? '',
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      pairingCode: json['pairingCode'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'agentId': agentId,
      'pairingCode': pairingCode,
      'type': type,
  };
}

class AgentConfigFile {
  final String content;

  const AgentConfigFile({
    this.content = '',
  });

  factory AgentConfigFile.fromJson(Map<String, dynamic> json) {
    return AgentConfigFile(
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
  };
}

class AgentConfigFileReq {
  final int agentId;

  const AgentConfigFileReq({
    this.agentId = 0,
  });

  factory AgentConfigFileReq.fromJson(Map<String, dynamic> json) {
    return AgentConfigFileReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
  };
}

class AgentConfigFileUpdateReq {
  final int agentId;
  final String content;

  const AgentConfigFileUpdateReq({
    this.agentId = 0,
    this.content = '',
  });

  factory AgentConfigFileUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentConfigFileUpdateReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'content': content,
  };
}

class AgentConfiguredAgentItem {
  final String agentDir;
  final List<AgentRoleBinding> bindings;
  final String id;
  final String model;
  final String name;
  final String workspace;

  const AgentConfiguredAgentItem({
    this.agentDir = '',
    this.bindings = const [],
    this.id = '',
    this.model = '',
    this.name = '',
    this.workspace = '',
  });

  factory AgentConfiguredAgentItem.fromJson(Map<String, dynamic> json) {
    return AgentConfiguredAgentItem(
      agentDir: json['agentDir'] as String? ?? '',
      bindings: (json['bindings'] as List<dynamic>?)?.map((e) => AgentRoleBinding.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      id: json['id'] as String? ?? '',
      model: json['model'] as String? ?? '',
      name: json['name'] as String? ?? '',
      workspace: json['workspace'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentDir': agentDir,
      'bindings': bindings.map((e) => e.toJson()).toList(),
      'id': id,
      'model': model,
      'name': name,
      'workspace': workspace,
  };
}

class AgentConfiguredAgentsReq {
  final int agentId;

  const AgentConfiguredAgentsReq({
    this.agentId = 0,
  });

  factory AgentConfiguredAgentsReq.fromJson(Map<String, dynamic> json) {
    return AgentConfiguredAgentsReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
  };
}

class AgentCreateReq {
  final int accountId;
  final bool advanced;
  final String agentType;
  final bool allowPort;
  final List<String> allowedOrigins;
  final String appVersion;
  final int bridgePort;
  final String containerName;
  final double cpuQuota;
  final String dashboardPassword;
  final String dashboardUsername;
  final String dockerCompose;
  final bool editCompose;
  final double memoryLimit;
  final String memoryUnit;
  final String model;
  final String name;
  final bool pullImage;
  final String remark;
  final String restartPolicy;
  final String specifyIP;
  final String taskID;
  final String token;
  final int webUIPort;

  const AgentCreateReq({
    this.accountId = 0,
    this.advanced = false,
    this.agentType = '',
    this.allowPort = false,
    this.allowedOrigins = const [],
    this.appVersion = '',
    this.bridgePort = 0,
    this.containerName = '',
    this.cpuQuota = 0.0,
    this.dashboardPassword = '',
    this.dashboardUsername = '',
    this.dockerCompose = '',
    this.editCompose = false,
    this.memoryLimit = 0.0,
    this.memoryUnit = '',
    this.model = '',
    this.name = '',
    this.pullImage = false,
    this.remark = '',
    this.restartPolicy = '',
    this.specifyIP = '',
    this.taskID = '',
    this.token = '',
    this.webUIPort = 0,
  });

  factory AgentCreateReq.fromJson(Map<String, dynamic> json) {
    return AgentCreateReq(
      accountId: (json['accountId'] as num?)?.toInt() ?? 0,
      advanced: json['advanced'] as bool? ?? false,
      agentType: json['agentType'] as String? ?? '',
      allowPort: json['allowPort'] as bool? ?? false,
      allowedOrigins: (json['allowedOrigins'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      appVersion: json['appVersion'] as String? ?? '',
      bridgePort: (json['bridgePort'] as num?)?.toInt() ?? 0,
      containerName: json['containerName'] as String? ?? '',
      cpuQuota: (json['cpuQuota'] as num?)?.toDouble() ?? 0.0,
      dashboardPassword: json['dashboardPassword'] as String? ?? '',
      dashboardUsername: json['dashboardUsername'] as String? ?? '',
      dockerCompose: json['dockerCompose'] as String? ?? '',
      editCompose: json['editCompose'] as bool? ?? false,
      memoryLimit: (json['memoryLimit'] as num?)?.toDouble() ?? 0.0,
      memoryUnit: json['memoryUnit'] as String? ?? '',
      model: json['model'] as String? ?? '',
      name: json['name'] as String? ?? '',
      pullImage: json['pullImage'] as bool? ?? false,
      remark: json['remark'] as String? ?? '',
      restartPolicy: json['restartPolicy'] as String? ?? '',
      specifyIP: json['specifyIP'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      token: json['token'] as String? ?? '',
      webUIPort: (json['webUIPort'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'advanced': advanced,
      'agentType': agentType,
      'allowPort': allowPort,
      'allowedOrigins': allowedOrigins,
      'appVersion': appVersion,
      'bridgePort': bridgePort,
      'containerName': containerName,
      'cpuQuota': cpuQuota,
      'dashboardPassword': dashboardPassword,
      'dashboardUsername': dashboardUsername,
      'dockerCompose': dockerCompose,
      'editCompose': editCompose,
      'memoryLimit': memoryLimit,
      'memoryUnit': memoryUnit,
      'model': model,
      'name': name,
      'pullImage': pullImage,
      'remark': remark,
      'restartPolicy': restartPolicy,
      'specifyIP': specifyIP,
      'taskID': taskID,
      'token': token,
      'webUIPort': webUIPort,
  };
}

class AgentDeleteReq {
  final bool forceDelete;
  final int id;
  final String taskID;

  const AgentDeleteReq({
    this.forceDelete = false,
    this.id = 0,
    this.taskID = '',
  });

  factory AgentDeleteReq.fromJson(Map<String, dynamic> json) {
    return AgentDeleteReq(
      forceDelete: json['forceDelete'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'forceDelete': forceDelete,
      'id': id,
      'taskID': taskID,
  };
}

class AgentDingTalkBot {
  final String accountId;
  final String clientId;
  final String clientSecret;
  final bool enabled;
  final bool isDefault;
  final String name;

  const AgentDingTalkBot({
    this.accountId = '',
    this.clientId = '',
    this.clientSecret = '',
    this.enabled = false,
    this.isDefault = false,
    this.name = '',
  });

  factory AgentDingTalkBot.fromJson(Map<String, dynamic> json) {
    return AgentDingTalkBot(
      accountId: json['accountId'] as String? ?? '',
      clientId: json['clientId'] as String? ?? '',
      clientSecret: json['clientSecret'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      isDefault: json['isDefault'] as bool? ?? false,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'clientId': clientId,
      'clientSecret': clientSecret,
      'enabled': enabled,
      'isDefault': isDefault,
      'name': name,
  };
}

class AgentDingTalkConfig {
  final String ackText;
  final List<String> allowFrom;
  final bool asyncMode;
  final List<AgentDingTalkBot> bots;
  final String dmPolicy;
  final bool enabled;
  final List<String> groupAllowFrom;
  final String groupPolicy;
  final String groupSessionScope;
  final bool installed;
  final bool separateSessionByConversation;
  final bool sharedMemoryAcrossConversations;

  const AgentDingTalkConfig({
    this.ackText = '',
    this.allowFrom = const [],
    this.asyncMode = false,
    this.bots = const [],
    this.dmPolicy = '',
    this.enabled = false,
    this.groupAllowFrom = const [],
    this.groupPolicy = '',
    this.groupSessionScope = '',
    this.installed = false,
    this.separateSessionByConversation = false,
    this.sharedMemoryAcrossConversations = false,
  });

  factory AgentDingTalkConfig.fromJson(Map<String, dynamic> json) {
    return AgentDingTalkConfig(
      ackText: json['ackText'] as String? ?? '',
      allowFrom: (json['allowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      asyncMode: json['asyncMode'] as bool? ?? false,
      bots: (json['bots'] as List<dynamic>?)?.map((e) => AgentDingTalkBot.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      dmPolicy: json['dmPolicy'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      groupAllowFrom: (json['groupAllowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      groupPolicy: json['groupPolicy'] as String? ?? '',
      groupSessionScope: json['groupSessionScope'] as String? ?? '',
      installed: json['installed'] as bool? ?? false,
      separateSessionByConversation: json['separateSessionByConversation'] as bool? ?? false,
      sharedMemoryAcrossConversations: json['sharedMemoryAcrossConversations'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'ackText': ackText,
      'allowFrom': allowFrom,
      'asyncMode': asyncMode,
      'bots': bots.map((e) => e.toJson()).toList(),
      'dmPolicy': dmPolicy,
      'enabled': enabled,
      'groupAllowFrom': groupAllowFrom,
      'groupPolicy': groupPolicy,
      'groupSessionScope': groupSessionScope,
      'installed': installed,
      'separateSessionByConversation': separateSessionByConversation,
      'sharedMemoryAcrossConversations': sharedMemoryAcrossConversations,
  };
}

class AgentDingTalkConfigUpdateReq {
  final String ackText;
  final int agentId;
  final List<String> allowFrom;
  final bool asyncMode;
  final List<AgentDingTalkBot> bots;
  final String dmPolicy;
  final bool enabled;
  final List<String> groupAllowFrom;
  final String groupPolicy;
  final String groupSessionScope;
  final bool separateSessionByConversation;
  final bool sharedMemoryAcrossConversations;

  const AgentDingTalkConfigUpdateReq({
    this.ackText = '',
    this.agentId = 0,
    this.allowFrom = const [],
    this.asyncMode = false,
    this.bots = const [],
    this.dmPolicy = '',
    this.enabled = false,
    this.groupAllowFrom = const [],
    this.groupPolicy = '',
    this.groupSessionScope = '',
    this.separateSessionByConversation = false,
    this.sharedMemoryAcrossConversations = false,
  });

  factory AgentDingTalkConfigUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentDingTalkConfigUpdateReq(
      ackText: json['ackText'] as String? ?? '',
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      allowFrom: (json['allowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      asyncMode: json['asyncMode'] as bool? ?? false,
      bots: (json['bots'] as List<dynamic>?)?.map((e) => AgentDingTalkBot.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      dmPolicy: json['dmPolicy'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      groupAllowFrom: (json['groupAllowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      groupPolicy: json['groupPolicy'] as String? ?? '',
      groupSessionScope: json['groupSessionScope'] as String? ?? '',
      separateSessionByConversation: json['separateSessionByConversation'] as bool? ?? false,
      sharedMemoryAcrossConversations: json['sharedMemoryAcrossConversations'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'ackText': ackText,
      'agentId': agentId,
      'allowFrom': allowFrom,
      'asyncMode': asyncMode,
      'bots': bots.map((e) => e.toJson()).toList(),
      'dmPolicy': dmPolicy,
      'enabled': enabled,
      'groupAllowFrom': groupAllowFrom,
      'groupPolicy': groupPolicy,
      'groupSessionScope': groupSessionScope,
      'separateSessionByConversation': separateSessionByConversation,
      'sharedMemoryAcrossConversations': sharedMemoryAcrossConversations,
  };
}

class AgentDiscordBot {
  final String accountId;
  final bool enabled;
  final bool isDefault;
  final String name;
  final String token;

  const AgentDiscordBot({
    this.accountId = '',
    this.enabled = false,
    this.isDefault = false,
    this.name = '',
    this.token = '',
  });

  factory AgentDiscordBot.fromJson(Map<String, dynamic> json) {
    return AgentDiscordBot(
      accountId: json['accountId'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      isDefault: json['isDefault'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      token: json['token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'enabled': enabled,
      'isDefault': isDefault,
      'name': name,
      'token': token,
  };
}

class AgentDiscordConfig {
  final List<String> allowFrom;
  final List<AgentDiscordBot> bots;
  final String defaultAccount;
  final String dmPolicy;
  final bool enabled;
  final String groupPolicy;
  final String proxy;
  final bool requireMention;

  const AgentDiscordConfig({
    this.allowFrom = const [],
    this.bots = const [],
    this.defaultAccount = '',
    this.dmPolicy = '',
    this.enabled = false,
    this.groupPolicy = '',
    this.proxy = '',
    this.requireMention = false,
  });

  factory AgentDiscordConfig.fromJson(Map<String, dynamic> json) {
    return AgentDiscordConfig(
      allowFrom: (json['allowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      bots: (json['bots'] as List<dynamic>?)?.map((e) => AgentDiscordBot.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      defaultAccount: json['defaultAccount'] as String? ?? '',
      dmPolicy: json['dmPolicy'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      groupPolicy: json['groupPolicy'] as String? ?? '',
      proxy: json['proxy'] as String? ?? '',
      requireMention: json['requireMention'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'allowFrom': allowFrom,
      'bots': bots.map((e) => e.toJson()).toList(),
      'defaultAccount': defaultAccount,
      'dmPolicy': dmPolicy,
      'enabled': enabled,
      'groupPolicy': groupPolicy,
      'proxy': proxy,
      'requireMention': requireMention,
  };
}

class AgentDiscordConfigUpdateReq {
  final int agentId;
  final List<String> allowFrom;
  final List<AgentDiscordBot> bots;
  final String defaultAccount;
  final String dmPolicy;
  final bool enabled;
  final String groupPolicy;
  final String proxy;
  final bool requireMention;

  const AgentDiscordConfigUpdateReq({
    this.agentId = 0,
    this.allowFrom = const [],
    this.bots = const [],
    this.defaultAccount = '',
    this.dmPolicy = '',
    this.enabled = false,
    this.groupPolicy = '',
    this.proxy = '',
    this.requireMention = false,
  });

  factory AgentDiscordConfigUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentDiscordConfigUpdateReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      allowFrom: (json['allowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      bots: (json['bots'] as List<dynamic>?)?.map((e) => AgentDiscordBot.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      defaultAccount: json['defaultAccount'] as String? ?? '',
      dmPolicy: json['dmPolicy'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      groupPolicy: json['groupPolicy'] as String? ?? '',
      proxy: json['proxy'] as String? ?? '',
      requireMention: json['requireMention'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'allowFrom': allowFrom,
      'bots': bots.map((e) => e.toJson()).toList(),
      'defaultAccount': defaultAccount,
      'dmPolicy': dmPolicy,
      'enabled': enabled,
      'groupPolicy': groupPolicy,
      'proxy': proxy,
      'requireMention': requireMention,
  };
}

class AgentFeishuBot {
  final String accountId;
  final List<String> allowFrom;
  final String appId;
  final String appSecret;
  final String dmPolicy;
  final bool enabled;
  final bool isDefault;
  final String name;

  const AgentFeishuBot({
    this.accountId = '',
    this.allowFrom = const [],
    this.appId = '',
    this.appSecret = '',
    this.dmPolicy = '',
    this.enabled = false,
    this.isDefault = false,
    this.name = '',
  });

  factory AgentFeishuBot.fromJson(Map<String, dynamic> json) {
    return AgentFeishuBot(
      accountId: json['accountId'] as String? ?? '',
      allowFrom: (json['allowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      appId: json['appId'] as String? ?? '',
      appSecret: json['appSecret'] as String? ?? '',
      dmPolicy: json['dmPolicy'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      isDefault: json['isDefault'] as bool? ?? false,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'allowFrom': allowFrom,
      'appId': appId,
      'appSecret': appSecret,
      'dmPolicy': dmPolicy,
      'enabled': enabled,
      'isDefault': isDefault,
      'name': name,
  };
}

class AgentFeishuConfig {
  final List<AgentFeishuBot> bots;
  final String connectionMode;
  final String domain;
  final bool enabled;
  final List<String> groupAllowFrom;
  final String groupPolicy;
  final bool installed;
  final String replyMode;
  final String requireMention;
  final bool streaming;
  final bool threadSession;

  const AgentFeishuConfig({
    this.bots = const [],
    this.connectionMode = '',
    this.domain = '',
    this.enabled = false,
    this.groupAllowFrom = const [],
    this.groupPolicy = '',
    this.installed = false,
    this.replyMode = '',
    this.requireMention = '',
    this.streaming = false,
    this.threadSession = false,
  });

  factory AgentFeishuConfig.fromJson(Map<String, dynamic> json) {
    return AgentFeishuConfig(
      bots: (json['bots'] as List<dynamic>?)?.map((e) => AgentFeishuBot.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      connectionMode: json['connectionMode'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      groupAllowFrom: (json['groupAllowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      groupPolicy: json['groupPolicy'] as String? ?? '',
      installed: json['installed'] as bool? ?? false,
      replyMode: json['replyMode'] as String? ?? '',
      requireMention: json['requireMention'] as String? ?? '',
      streaming: json['streaming'] as bool? ?? false,
      threadSession: json['threadSession'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'bots': bots.map((e) => e.toJson()).toList(),
      'connectionMode': connectionMode,
      'domain': domain,
      'enabled': enabled,
      'groupAllowFrom': groupAllowFrom,
      'groupPolicy': groupPolicy,
      'installed': installed,
      'replyMode': replyMode,
      'requireMention': requireMention,
      'streaming': streaming,
      'threadSession': threadSession,
  };
}

class AgentFeishuConfigReq {
  final int agentId;

  const AgentFeishuConfigReq({
    this.agentId = 0,
  });

  factory AgentFeishuConfigReq.fromJson(Map<String, dynamic> json) {
    return AgentFeishuConfigReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
  };
}

class AgentFeishuConfigUpdateReq {
  final int agentId;
  final List<AgentFeishuBot> bots;
  final String connectionMode;
  final String domain;
  final bool enabled;
  final List<String> groupAllowFrom;
  final String groupPolicy;
  final String replyMode;
  final String requireMention;
  final bool streaming;
  final bool threadSession;

  const AgentFeishuConfigUpdateReq({
    this.agentId = 0,
    this.bots = const [],
    this.connectionMode = '',
    this.domain = '',
    this.enabled = false,
    this.groupAllowFrom = const [],
    this.groupPolicy = '',
    this.replyMode = '',
    this.requireMention = '',
    this.streaming = false,
    this.threadSession = false,
  });

  factory AgentFeishuConfigUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentFeishuConfigUpdateReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      bots: (json['bots'] as List<dynamic>?)?.map((e) => AgentFeishuBot.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      connectionMode: json['connectionMode'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      groupAllowFrom: (json['groupAllowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      groupPolicy: json['groupPolicy'] as String? ?? '',
      replyMode: json['replyMode'] as String? ?? '',
      requireMention: json['requireMention'] as String? ?? '',
      streaming: json['streaming'] as bool? ?? false,
      threadSession: json['threadSession'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'bots': bots.map((e) => e.toJson()).toList(),
      'connectionMode': connectionMode,
      'domain': domain,
      'enabled': enabled,
      'groupAllowFrom': groupAllowFrom,
      'groupPolicy': groupPolicy,
      'replyMode': replyMode,
      'requireMention': requireMention,
      'streaming': streaming,
      'threadSession': threadSession,
  };
}

class AgentHermesChatSessionDeleteReq {
  final int agentId;
  final String id;

  const AgentHermesChatSessionDeleteReq({
    this.agentId = 0,
    this.id = '',
  });

  factory AgentHermesChatSessionDeleteReq.fromJson(Map<String, dynamic> json) {
    return AgentHermesChatSessionDeleteReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      id: json['id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'id': id,
  };
}

class AgentHermesChatSessionItem {
  final String id;
  final String lastActive;
  final int messageCount;
  final String model;
  final String startedAt;
  final String title;

  const AgentHermesChatSessionItem({
    this.id = '',
    this.lastActive = '',
    this.messageCount = 0,
    this.model = '',
    this.startedAt = '',
    this.title = '',
  });

  factory AgentHermesChatSessionItem.fromJson(Map<String, dynamic> json) {
    return AgentHermesChatSessionItem(
      id: json['id'] as String? ?? '',
      lastActive: json['lastActive'] as String? ?? '',
      messageCount: (json['messageCount'] as num?)?.toInt() ?? 0,
      model: json['model'] as String? ?? '',
      startedAt: json['startedAt'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'lastActive': lastActive,
      'messageCount': messageCount,
      'model': model,
      'startedAt': startedAt,
      'title': title,
  };
}

class AgentHermesChatSessionRenameReq {
  final int agentId;
  final String id;
  final String title;

  const AgentHermesChatSessionRenameReq({
    this.agentId = 0,
    this.id = '',
    this.title = '',
  });

  factory AgentHermesChatSessionRenameReq.fromJson(Map<String, dynamic> json) {
    return AgentHermesChatSessionRenameReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'id': id,
      'title': title,
  };
}

class AgentIDReq {
  final int agentId;

  const AgentIDReq({
    this.agentId = 0,
  });

  factory AgentIDReq.fromJson(Map<String, dynamic> json) {
    return AgentIDReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
  };
}

class AgentItem {
  final int accountId;
  final String agentType;
  final String apiKey;
  final String apiType;
  final int appInstallId;
  final String appVersion;
  final String baseUrl;
  final int bridgePort;
  final String configPath;
  final String containerName;
  final String createdAt;
  final String dashboardPassword;
  final String dashboardUsername;
  final int id;
  final String message;
  final String model;
  final String name;
  final String path;
  final String provider;
  final String providerName;
  final String remark;
  final String status;
  final String token;
  final bool upgradable;
  final int webUIPort;
  final int websiteId;
  final String websitePrimaryDomain;
  final String websiteProtocol;
  final String websiteType;

  const AgentItem({
    this.accountId = 0,
    this.agentType = '',
    this.apiKey = '',
    this.apiType = '',
    this.appInstallId = 0,
    this.appVersion = '',
    this.baseUrl = '',
    this.bridgePort = 0,
    this.configPath = '',
    this.containerName = '',
    this.createdAt = '',
    this.dashboardPassword = '',
    this.dashboardUsername = '',
    this.id = 0,
    this.message = '',
    this.model = '',
    this.name = '',
    this.path = '',
    this.provider = '',
    this.providerName = '',
    this.remark = '',
    this.status = '',
    this.token = '',
    this.upgradable = false,
    this.webUIPort = 0,
    this.websiteId = 0,
    this.websitePrimaryDomain = '',
    this.websiteProtocol = '',
    this.websiteType = '',
  });

  factory AgentItem.fromJson(Map<String, dynamic> json) {
    return AgentItem(
      accountId: (json['accountId'] as num?)?.toInt() ?? 0,
      agentType: json['agentType'] as String? ?? '',
      apiKey: json['apiKey'] as String? ?? '',
      apiType: json['apiType'] as String? ?? '',
      appInstallId: (json['appInstallId'] as num?)?.toInt() ?? 0,
      appVersion: json['appVersion'] as String? ?? '',
      baseUrl: json['baseUrl'] as String? ?? '',
      bridgePort: (json['bridgePort'] as num?)?.toInt() ?? 0,
      configPath: json['configPath'] as String? ?? '',
      containerName: json['containerName'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      dashboardPassword: json['dashboardPassword'] as String? ?? '',
      dashboardUsername: json['dashboardUsername'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      model: json['model'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      provider: json['provider'] as String? ?? '',
      providerName: json['providerName'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      status: json['status'] as String? ?? '',
      token: json['token'] as String? ?? '',
      upgradable: json['upgradable'] as bool? ?? false,
      webUIPort: (json['webUIPort'] as num?)?.toInt() ?? 0,
      websiteId: (json['websiteId'] as num?)?.toInt() ?? 0,
      websitePrimaryDomain: json['websitePrimaryDomain'] as String? ?? '',
      websiteProtocol: json['websiteProtocol'] as String? ?? '',
      websiteType: json['websiteType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'agentType': agentType,
      'apiKey': apiKey,
      'apiType': apiType,
      'appInstallId': appInstallId,
      'appVersion': appVersion,
      'baseUrl': baseUrl,
      'bridgePort': bridgePort,
      'configPath': configPath,
      'containerName': containerName,
      'createdAt': createdAt,
      'dashboardPassword': dashboardPassword,
      'dashboardUsername': dashboardUsername,
      'id': id,
      'message': message,
      'model': model,
      'name': name,
      'path': path,
      'provider': provider,
      'providerName': providerName,
      'remark': remark,
      'status': status,
      'token': token,
      'upgradable': upgradable,
      'webUIPort': webUIPort,
      'websiteId': websiteId,
      'websitePrimaryDomain': websitePrimaryDomain,
      'websiteProtocol': websiteProtocol,
      'websiteType': websiteType,
  };
}

class AgentModelConfig {
  final int accountId;
  final List<String> fallbacks;
  final String model;

  const AgentModelConfig({
    this.accountId = 0,
    this.fallbacks = const [],
    this.model = '',
  });

  factory AgentModelConfig.fromJson(Map<String, dynamic> json) {
    return AgentModelConfig(
      accountId: (json['accountId'] as num?)?.toInt() ?? 0,
      fallbacks: (json['fallbacks'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      model: json['model'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'fallbacks': fallbacks,
      'model': model,
  };
}

class AgentModelConfigUpdateReq {
  final int accountId;
  final int agentId;
  final List<String> fallbacks;
  final String model;

  const AgentModelConfigUpdateReq({
    this.accountId = 0,
    this.agentId = 0,
    this.fallbacks = const [],
    this.model = '',
  });

  factory AgentModelConfigUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentModelConfigUpdateReq(
      accountId: (json['accountId'] as num?)?.toInt() ?? 0,
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      fallbacks: (json['fallbacks'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      model: json['model'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'agentId': agentId,
      'fallbacks': fallbacks,
      'model': model,
  };
}

class AgentOtherConfig {
  final bool browserEnabled;
  final String dashboardPassword;
  final String dashboardUsername;
  final String npmRegistry;
  final String userTimezone;

  const AgentOtherConfig({
    this.browserEnabled = false,
    this.dashboardPassword = '',
    this.dashboardUsername = '',
    this.npmRegistry = '',
    this.userTimezone = '',
  });

  factory AgentOtherConfig.fromJson(Map<String, dynamic> json) {
    return AgentOtherConfig(
      browserEnabled: json['browserEnabled'] as bool? ?? false,
      dashboardPassword: json['dashboardPassword'] as String? ?? '',
      dashboardUsername: json['dashboardUsername'] as String? ?? '',
      npmRegistry: json['npmRegistry'] as String? ?? '',
      userTimezone: json['userTimezone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'browserEnabled': browserEnabled,
      'dashboardPassword': dashboardPassword,
      'dashboardUsername': dashboardUsername,
      'npmRegistry': npmRegistry,
      'userTimezone': userTimezone,
  };
}

class AgentOtherConfigUpdateReq {
  final int agentId;
  final bool browserEnabled;
  final String dashboardPassword;
  final String dashboardUsername;
  final String npmRegistry;
  final String userTimezone;

  const AgentOtherConfigUpdateReq({
    this.agentId = 0,
    this.browserEnabled = false,
    this.dashboardPassword = '',
    this.dashboardUsername = '',
    this.npmRegistry = '',
    this.userTimezone = '',
  });

  factory AgentOtherConfigUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentOtherConfigUpdateReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      browserEnabled: json['browserEnabled'] as bool? ?? false,
      dashboardPassword: json['dashboardPassword'] as String? ?? '',
      dashboardUsername: json['dashboardUsername'] as String? ?? '',
      npmRegistry: json['npmRegistry'] as String? ?? '',
      userTimezone: json['userTimezone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'browserEnabled': browserEnabled,
      'dashboardPassword': dashboardPassword,
      'dashboardUsername': dashboardUsername,
      'npmRegistry': npmRegistry,
      'userTimezone': userTimezone,
  };
}

class AgentOverview {
  final AgentOverviewSnapshot? snapshot;

  const AgentOverview({
    this.snapshot,
  });

  factory AgentOverview.fromJson(Map<String, dynamic> json) {
    return AgentOverview(
      snapshot: json['snapshot'] != null ? AgentOverviewSnapshot.fromJson(json['snapshot'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() => {
      if (snapshot != null) 'snapshot': snapshot!.toJson(),
  };
}

class AgentOverviewReq {
  final int agentId;

  const AgentOverviewReq({
    this.agentId = 0,
  });

  factory AgentOverviewReq.fromJson(Map<String, dynamic> json) {
    return AgentOverviewReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
  };
}

class AgentOverviewSnapshot {
  final String appVersion;
  final int channelCount;
  final String containerStatus;
  final String defaultModel;
  final int jobCount;
  final int sessionCount;
  final int skillCount;

  const AgentOverviewSnapshot({
    this.appVersion = '',
    this.channelCount = 0,
    this.containerStatus = '',
    this.defaultModel = '',
    this.jobCount = 0,
    this.sessionCount = 0,
    this.skillCount = 0,
  });

  factory AgentOverviewSnapshot.fromJson(Map<String, dynamic> json) {
    return AgentOverviewSnapshot(
      appVersion: json['appVersion'] as String? ?? '',
      channelCount: (json['channelCount'] as num?)?.toInt() ?? 0,
      containerStatus: json['containerStatus'] as String? ?? '',
      defaultModel: json['defaultModel'] as String? ?? '',
      jobCount: (json['jobCount'] as num?)?.toInt() ?? 0,
      sessionCount: (json['sessionCount'] as num?)?.toInt() ?? 0,
      skillCount: (json['skillCount'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'appVersion': appVersion,
      'channelCount': channelCount,
      'containerStatus': containerStatus,
      'defaultModel': defaultModel,
      'jobCount': jobCount,
      'sessionCount': sessionCount,
      'skillCount': skillCount,
  };
}

class AgentPluginCheckReq {
  final int agentId;
  final bool checkLatest;
  final String type;

  const AgentPluginCheckReq({
    this.agentId = 0,
    this.checkLatest = false,
    this.type = '',
  });

  factory AgentPluginCheckReq.fromJson(Map<String, dynamic> json) {
    return AgentPluginCheckReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      checkLatest: json['checkLatest'] as bool? ?? false,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'checkLatest': checkLatest,
      'type': type,
  };
}

class AgentPluginInstallReq {
  final int agentId;
  final String taskID;
  final String type;

  const AgentPluginInstallReq({
    this.agentId = 0,
    this.taskID = '',
    this.type = '',
  });

  factory AgentPluginInstallReq.fromJson(Map<String, dynamic> json) {
    return AgentPluginInstallReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      taskID: json['taskID'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'taskID': taskID,
      'type': type,
  };
}

class AgentPluginItem {
  final bool enabled;
  final String id;
  final String name;
  final String origin;
  final String version;

  const AgentPluginItem({
    this.enabled = false,
    this.id = '',
    this.name = '',
    this.origin = '',
    this.version = '',
  });

  factory AgentPluginItem.fromJson(Map<String, dynamic> json) {
    return AgentPluginItem(
      enabled: json['enabled'] as bool? ?? false,
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'enabled': enabled,
      'id': id,
      'name': name,
      'origin': origin,
      'version': version,
  };
}

class AgentPluginMarketInstallReq {
  final int agentId;
  final String package;
  final String taskID;
  final String version;

  const AgentPluginMarketInstallReq({
    this.agentId = 0,
    this.package = '',
    this.taskID = '',
    this.version = '',
  });

  factory AgentPluginMarketInstallReq.fromJson(Map<String, dynamic> json) {
    return AgentPluginMarketInstallReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      package: json['package'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'package': package,
      'taskID': taskID,
      'version': version,
  };
}

class AgentPluginOperateReq {
  final int agentId;
  final String operate;
  final String pluginId;
  final String taskID;

  const AgentPluginOperateReq({
    this.agentId = 0,
    this.operate = '',
    this.pluginId = '',
    this.taskID = '',
  });

  factory AgentPluginOperateReq.fromJson(Map<String, dynamic> json) {
    return AgentPluginOperateReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      operate: json['operate'] as String? ?? '',
      pluginId: json['pluginId'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'operate': operate,
      'pluginId': pluginId,
      'taskID': taskID,
  };
}

class AgentPluginSearchItem {
  final List<String> categories;
  final String channel;
  final String description;
  final int downloads;
  final String name;
  final bool official;
  final String package;
  final String pluginId;
  final double score;
  final String verificationTier;
  final String version;

  const AgentPluginSearchItem({
    this.categories = const [],
    this.channel = '',
    this.description = '',
    this.downloads = 0,
    this.name = '',
    this.official = false,
    this.package = '',
    this.pluginId = '',
    this.score = 0.0,
    this.verificationTier = '',
    this.version = '',
  });

  factory AgentPluginSearchItem.fromJson(Map<String, dynamic> json) {
    return AgentPluginSearchItem(
      categories: (json['categories'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      channel: json['channel'] as String? ?? '',
      description: json['description'] as String? ?? '',
      downloads: (json['downloads'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      official: json['official'] as bool? ?? false,
      package: json['package'] as String? ?? '',
      pluginId: json['pluginId'] as String? ?? '',
      score: (json['score'] as num?)?.toDouble() ?? 0.0,
      verificationTier: json['verificationTier'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'categories': categories,
      'channel': channel,
      'description': description,
      'downloads': downloads,
      'name': name,
      'official': official,
      'package': package,
      'pluginId': pluginId,
      'score': score,
      'verificationTier': verificationTier,
      'version': version,
  };
}

class AgentPluginSearchReq {
  final int agentId;
  final String keyword;
  final int limit;

  const AgentPluginSearchReq({
    this.agentId = 0,
    this.keyword = '',
    this.limit = 0,
  });

  factory AgentPluginSearchReq.fromJson(Map<String, dynamic> json) {
    return AgentPluginSearchReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      keyword: json['keyword'] as String? ?? '',
      limit: (json['limit'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'keyword': keyword,
      'limit': limit,
  };
}

class AgentPluginStatus {
  final String currentVersion;
  final bool installed;
  final String latestVersion;
  final bool upgradable;

  const AgentPluginStatus({
    this.currentVersion = '',
    this.installed = false,
    this.latestVersion = '',
    this.upgradable = false,
  });

  factory AgentPluginStatus.fromJson(Map<String, dynamic> json) {
    return AgentPluginStatus(
      currentVersion: json['currentVersion'] as String? ?? '',
      installed: json['installed'] as bool? ?? false,
      latestVersion: json['latestVersion'] as String? ?? '',
      upgradable: json['upgradable'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'currentVersion': currentVersion,
      'installed': installed,
      'latestVersion': latestVersion,
      'upgradable': upgradable,
  };
}

class AgentPluginUninstallReq {
  final int agentId;
  final String taskID;
  final String type;

  const AgentPluginUninstallReq({
    this.agentId = 0,
    this.taskID = '',
    this.type = '',
  });

  factory AgentPluginUninstallReq.fromJson(Map<String, dynamic> json) {
    return AgentPluginUninstallReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      taskID: json['taskID'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'taskID': taskID,
      'type': type,
  };
}

class AgentPluginUpgradeReq {
  final int agentId;
  final String taskID;
  final String type;

  const AgentPluginUpgradeReq({
    this.agentId = 0,
    this.taskID = '',
    this.type = '',
  });

  factory AgentPluginUpgradeReq.fromJson(Map<String, dynamic> json) {
    return AgentPluginUpgradeReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      taskID: json['taskID'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'taskID': taskID,
      'type': type,
  };
}

class AgentPluginsReq {
  final int agentId;

  const AgentPluginsReq({
    this.agentId = 0,
  });

  factory AgentPluginsReq.fromJson(Map<String, dynamic> json) {
    return AgentPluginsReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
  };
}

class AgentQQBotBot {
  final String accountId;
  final List<String> allowFrom;
  final String appId;
  final String clientSecret;
  final bool enabled;
  final bool isDefault;
  final String name;
  final String systemPrompt;

  const AgentQQBotBot({
    this.accountId = '',
    this.allowFrom = const [],
    this.appId = '',
    this.clientSecret = '',
    this.enabled = false,
    this.isDefault = false,
    this.name = '',
    this.systemPrompt = '',
  });

  factory AgentQQBotBot.fromJson(Map<String, dynamic> json) {
    return AgentQQBotBot(
      accountId: json['accountId'] as String? ?? '',
      allowFrom: (json['allowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      appId: json['appId'] as String? ?? '',
      clientSecret: json['clientSecret'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      isDefault: json['isDefault'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      systemPrompt: json['systemPrompt'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'allowFrom': allowFrom,
      'appId': appId,
      'clientSecret': clientSecret,
      'enabled': enabled,
      'isDefault': isDefault,
      'name': name,
      'systemPrompt': systemPrompt,
  };
}

class AgentQQBotConfig {
  final List<String> allowFrom;
  final List<AgentQQBotBot> bots;
  final String dmPolicy;
  final bool enabled;
  final List<String> groupAllowFrom;
  final String groupPolicy;
  final bool installed;

  const AgentQQBotConfig({
    this.allowFrom = const [],
    this.bots = const [],
    this.dmPolicy = '',
    this.enabled = false,
    this.groupAllowFrom = const [],
    this.groupPolicy = '',
    this.installed = false,
  });

  factory AgentQQBotConfig.fromJson(Map<String, dynamic> json) {
    return AgentQQBotConfig(
      allowFrom: (json['allowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      bots: (json['bots'] as List<dynamic>?)?.map((e) => AgentQQBotBot.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      dmPolicy: json['dmPolicy'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      groupAllowFrom: (json['groupAllowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      groupPolicy: json['groupPolicy'] as String? ?? '',
      installed: json['installed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'allowFrom': allowFrom,
      'bots': bots.map((e) => e.toJson()).toList(),
      'dmPolicy': dmPolicy,
      'enabled': enabled,
      'groupAllowFrom': groupAllowFrom,
      'groupPolicy': groupPolicy,
      'installed': installed,
  };
}

class AgentQQBotConfigUpdateReq {
  final int agentId;
  final List<String> allowFrom;
  final List<AgentQQBotBot> bots;
  final String dmPolicy;
  final bool enabled;
  final List<String> groupAllowFrom;
  final String groupPolicy;

  const AgentQQBotConfigUpdateReq({
    this.agentId = 0,
    this.allowFrom = const [],
    this.bots = const [],
    this.dmPolicy = '',
    this.enabled = false,
    this.groupAllowFrom = const [],
    this.groupPolicy = '',
  });

  factory AgentQQBotConfigUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentQQBotConfigUpdateReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      allowFrom: (json['allowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      bots: (json['bots'] as List<dynamic>?)?.map((e) => AgentQQBotBot.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      dmPolicy: json['dmPolicy'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      groupAllowFrom: (json['groupAllowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      groupPolicy: json['groupPolicy'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'allowFrom': allowFrom,
      'bots': bots.map((e) => e.toJson()).toList(),
      'dmPolicy': dmPolicy,
      'enabled': enabled,
      'groupAllowFrom': groupAllowFrom,
      'groupPolicy': groupPolicy,
  };
}

class AgentRemarkUpdateReq {
  final int id;
  final String remark;

  const AgentRemarkUpdateReq({
    this.id = 0,
    this.remark = '',
  });

  factory AgentRemarkUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentRemarkUpdateReq(
      id: (json['id'] as num?)?.toInt() ?? 0,
      remark: json['remark'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'remark': remark,
  };
}

class AgentRoleBindReq {
  final String accountId;
  final int agentId;
  final String channel;
  final String id;

  const AgentRoleBindReq({
    this.accountId = '',
    this.agentId = 0,
    this.channel = '',
    this.id = '',
  });

  factory AgentRoleBindReq.fromJson(Map<String, dynamic> json) {
    return AgentRoleBindReq(
      accountId: json['accountId'] as String? ?? '',
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      channel: json['channel'] as String? ?? '',
      id: json['id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'agentId': agentId,
      'channel': channel,
      'id': id,
  };
}

class AgentRoleBinding {
  final String accountId;
  final String channel;

  const AgentRoleBinding({
    this.accountId = '',
    this.channel = '',
  });

  factory AgentRoleBinding.fromJson(Map<String, dynamic> json) {
    return AgentRoleBinding(
      accountId: json['accountId'] as String? ?? '',
      channel: json['channel'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'channel': channel,
  };
}

class AgentRoleChannelItem {
  final List<String> accountIds;
  final bool bound;
  final String name;

  const AgentRoleChannelItem({
    this.accountIds = const [],
    this.bound = false,
    this.name = '',
  });

  factory AgentRoleChannelItem.fromJson(Map<String, dynamic> json) {
    return AgentRoleChannelItem(
      accountIds: (json['accountIds'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      bound: json['bound'] as bool? ?? false,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accountIds': accountIds,
      'bound': bound,
      'name': name,
  };
}

class AgentRoleChannelsReq {
  final int agentId;

  const AgentRoleChannelsReq({
    this.agentId = 0,
  });

  factory AgentRoleChannelsReq.fromJson(Map<String, dynamic> json) {
    return AgentRoleChannelsReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
  };
}

class AgentRoleCreateReq {
  final int agentId;
  final List<AgentRoleBinding> bindings;
  final String model;
  final String name;

  const AgentRoleCreateReq({
    this.agentId = 0,
    this.bindings = const [],
    this.model = '',
    this.name = '',
  });

  factory AgentRoleCreateReq.fromJson(Map<String, dynamic> json) {
    return AgentRoleCreateReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      bindings: (json['bindings'] as List<dynamic>?)?.map((e) => AgentRoleBinding.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      model: json['model'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'bindings': bindings.map((e) => e.toJson()).toList(),
      'model': model,
      'name': name,
  };
}

class AgentRoleCreateResp {
  final String output;

  const AgentRoleCreateResp({
    this.output = '',
  });

  factory AgentRoleCreateResp.fromJson(Map<String, dynamic> json) {
    return AgentRoleCreateResp(
      output: json['output'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'output': output,
  };
}

class AgentRoleDeleteReq {
  final int agentId;
  final String id;

  const AgentRoleDeleteReq({
    this.agentId = 0,
    this.id = '',
  });

  factory AgentRoleDeleteReq.fromJson(Map<String, dynamic> json) {
    return AgentRoleDeleteReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      id: json['id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'id': id,
  };
}

class AgentRoleMarkdownFileItem {
  final String content;
  final String name;

  const AgentRoleMarkdownFileItem({
    this.content = '',
    this.name = '',
  });

  factory AgentRoleMarkdownFileItem.fromJson(Map<String, dynamic> json) {
    return AgentRoleMarkdownFileItem(
      content: json['content'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'name': name,
  };
}

class AgentRoleMarkdownFileUpdateItem {
  final String content;
  final String name;

  const AgentRoleMarkdownFileUpdateItem({
    this.content = '',
    this.name = '',
  });

  factory AgentRoleMarkdownFileUpdateItem.fromJson(Map<String, dynamic> json) {
    return AgentRoleMarkdownFileUpdateItem(
      content: json['content'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'name': name,
  };
}

class AgentRoleMarkdownFilesReq {
  final int agentId;
  final String workspace;

  const AgentRoleMarkdownFilesReq({
    this.agentId = 0,
    this.workspace = '',
  });

  factory AgentRoleMarkdownFilesReq.fromJson(Map<String, dynamic> json) {
    return AgentRoleMarkdownFilesReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      workspace: json['workspace'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'workspace': workspace,
  };
}

class AgentRoleMarkdownFilesUpdateReq {
  final int agentId;
  final List<AgentRoleMarkdownFileUpdateItem> files;
  final bool restart;
  final String workspace;

  const AgentRoleMarkdownFilesUpdateReq({
    this.agentId = 0,
    this.files = const [],
    this.restart = false,
    this.workspace = '',
  });

  factory AgentRoleMarkdownFilesUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentRoleMarkdownFilesUpdateReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      files: (json['files'] as List<dynamic>?)?.map((e) => AgentRoleMarkdownFileUpdateItem.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      restart: json['restart'] as bool? ?? false,
      workspace: json['workspace'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'files': files.map((e) => e.toJson()).toList(),
      'restart': restart,
      'workspace': workspace,
  };
}

class AgentSecurityConfig {
  final List<String> allowedOrigins;

  const AgentSecurityConfig({
    this.allowedOrigins = const [],
  });

  factory AgentSecurityConfig.fromJson(Map<String, dynamic> json) {
    return AgentSecurityConfig(
      allowedOrigins: (json['allowedOrigins'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'allowedOrigins': allowedOrigins,
  };
}

class AgentSecurityConfigUpdateReq {
  final int agentId;
  final List<String> allowedOrigins;

  const AgentSecurityConfigUpdateReq({
    this.agentId = 0,
    this.allowedOrigins = const [],
  });

  factory AgentSecurityConfigUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentSecurityConfigUpdateReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      allowedOrigins: (json['allowedOrigins'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'allowedOrigins': allowedOrigins,
  };
}

class AgentSkillInstallReq {
  final int agentId;
  final String slug;
  final String source;
  final String taskID;

  const AgentSkillInstallReq({
    this.agentId = 0,
    this.slug = '',
    this.source = '',
    this.taskID = '',
  });

  factory AgentSkillInstallReq.fromJson(Map<String, dynamic> json) {
    return AgentSkillInstallReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      slug: json['slug'] as String? ?? '',
      source: json['source'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'slug': slug,
      'source': source,
      'taskID': taskID,
  };
}

class AgentSkillItem {
  final bool bundled;
  final String category;
  final String description;
  final bool disabled;
  final String identifier;
  final String name;
  final String source;
  final List<String> tags;
  final String trust;
  final bool uninstallable;

  const AgentSkillItem({
    this.bundled = false,
    this.category = '',
    this.description = '',
    this.disabled = false,
    this.identifier = '',
    this.name = '',
    this.source = '',
    this.tags = const [],
    this.trust = '',
    this.uninstallable = false,
  });

  factory AgentSkillItem.fromJson(Map<String, dynamic> json) {
    return AgentSkillItem(
      bundled: json['bundled'] as bool? ?? false,
      category: json['category'] as String? ?? '',
      description: json['description'] as String? ?? '',
      disabled: json['disabled'] as bool? ?? false,
      identifier: json['identifier'] as String? ?? '',
      name: json['name'] as String? ?? '',
      source: json['source'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      trust: json['trust'] as String? ?? '',
      uninstallable: json['uninstallable'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'bundled': bundled,
      'category': category,
      'description': description,
      'disabled': disabled,
      'identifier': identifier,
      'name': name,
      'source': source,
      'tags': tags,
      'trust': trust,
      'uninstallable': uninstallable,
  };
}

class AgentSkillSearchItem {
  final String description;
  final String identifier;
  final String name;
  final String score;
  final String slug;
  final String source;
  final String summary;
  final String trust;
  final String version;

  const AgentSkillSearchItem({
    this.description = '',
    this.identifier = '',
    this.name = '',
    this.score = '',
    this.slug = '',
    this.source = '',
    this.summary = '',
    this.trust = '',
    this.version = '',
  });

  factory AgentSkillSearchItem.fromJson(Map<String, dynamic> json) {
    return AgentSkillSearchItem(
      description: json['description'] as String? ?? '',
      identifier: json['identifier'] as String? ?? '',
      name: json['name'] as String? ?? '',
      score: json['score'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      source: json['source'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      trust: json['trust'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'description': description,
      'identifier': identifier,
      'name': name,
      'score': score,
      'slug': slug,
      'source': source,
      'summary': summary,
      'trust': trust,
      'version': version,
  };
}

class AgentSkillSearchReq {
  final int agentId;
  final String keyword;
  final String source;

  const AgentSkillSearchReq({
    this.agentId = 0,
    this.keyword = '',
    this.source = '',
  });

  factory AgentSkillSearchReq.fromJson(Map<String, dynamic> json) {
    return AgentSkillSearchReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      keyword: json['keyword'] as String? ?? '',
      source: json['source'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'keyword': keyword,
      'source': source,
  };
}

class AgentSkillUninstallReq {
  final int agentId;
  final String name;

  const AgentSkillUninstallReq({
    this.agentId = 0,
    this.name = '',
  });

  factory AgentSkillUninstallReq.fromJson(Map<String, dynamic> json) {
    return AgentSkillUninstallReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'name': name,
  };
}

class AgentSkillUpdateReq {
  final int agentId;
  final bool enabled;
  final String name;

  const AgentSkillUpdateReq({
    this.agentId = 0,
    this.enabled = false,
    this.name = '',
  });

  factory AgentSkillUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentSkillUpdateReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      enabled: json['enabled'] as bool? ?? false,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'enabled': enabled,
      'name': name,
  };
}

class AgentTelegramBot {
  final String accountId;
  final String botToken;
  final String dmPolicy;
  final bool enabled;
  final String groupPolicy;
  final bool isDefault;
  final String name;
  final String streaming;

  const AgentTelegramBot({
    this.accountId = '',
    this.botToken = '',
    this.dmPolicy = '',
    this.enabled = false,
    this.groupPolicy = '',
    this.isDefault = false,
    this.name = '',
    this.streaming = '',
  });

  factory AgentTelegramBot.fromJson(Map<String, dynamic> json) {
    return AgentTelegramBot(
      accountId: json['accountId'] as String? ?? '',
      botToken: json['botToken'] as String? ?? '',
      dmPolicy: json['dmPolicy'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      groupPolicy: json['groupPolicy'] as String? ?? '',
      isDefault: json['isDefault'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      streaming: json['streaming'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accountId': accountId,
      'botToken': botToken,
      'dmPolicy': dmPolicy,
      'enabled': enabled,
      'groupPolicy': groupPolicy,
      'isDefault': isDefault,
      'name': name,
      'streaming': streaming,
  };
}

class AgentTelegramConfig {
  final List<String> allowFrom;
  final List<AgentTelegramBot> bots;
  final String defaultAccount;
  final String dmPolicy;
  final bool enabled;
  final List<String> groupAllowFrom;
  final String groupPolicy;
  final String proxy;
  final bool requireMention;
  final String streaming;

  const AgentTelegramConfig({
    this.allowFrom = const [],
    this.bots = const [],
    this.defaultAccount = '',
    this.dmPolicy = '',
    this.enabled = false,
    this.groupAllowFrom = const [],
    this.groupPolicy = '',
    this.proxy = '',
    this.requireMention = false,
    this.streaming = '',
  });

  factory AgentTelegramConfig.fromJson(Map<String, dynamic> json) {
    return AgentTelegramConfig(
      allowFrom: (json['allowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      bots: (json['bots'] as List<dynamic>?)?.map((e) => AgentTelegramBot.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      defaultAccount: json['defaultAccount'] as String? ?? '',
      dmPolicy: json['dmPolicy'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      groupAllowFrom: (json['groupAllowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      groupPolicy: json['groupPolicy'] as String? ?? '',
      proxy: json['proxy'] as String? ?? '',
      requireMention: json['requireMention'] as bool? ?? false,
      streaming: json['streaming'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'allowFrom': allowFrom,
      'bots': bots.map((e) => e.toJson()).toList(),
      'defaultAccount': defaultAccount,
      'dmPolicy': dmPolicy,
      'enabled': enabled,
      'groupAllowFrom': groupAllowFrom,
      'groupPolicy': groupPolicy,
      'proxy': proxy,
      'requireMention': requireMention,
      'streaming': streaming,
  };
}

class AgentTelegramConfigReq {
  final int agentId;

  const AgentTelegramConfigReq({
    this.agentId = 0,
  });

  factory AgentTelegramConfigReq.fromJson(Map<String, dynamic> json) {
    return AgentTelegramConfigReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
  };
}

class AgentTelegramConfigUpdateReq {
  final int agentId;
  final List<String> allowFrom;
  final List<AgentTelegramBot> bots;
  final String defaultAccount;
  final String dmPolicy;
  final bool enabled;
  final List<String> groupAllowFrom;
  final String groupPolicy;
  final String proxy;
  final bool requireMention;
  final String streaming;

  const AgentTelegramConfigUpdateReq({
    this.agentId = 0,
    this.allowFrom = const [],
    this.bots = const [],
    this.defaultAccount = '',
    this.dmPolicy = '',
    this.enabled = false,
    this.groupAllowFrom = const [],
    this.groupPolicy = '',
    this.proxy = '',
    this.requireMention = false,
    this.streaming = '',
  });

  factory AgentTelegramConfigUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentTelegramConfigUpdateReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      allowFrom: (json['allowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      bots: (json['bots'] as List<dynamic>?)?.map((e) => AgentTelegramBot.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      defaultAccount: json['defaultAccount'] as String? ?? '',
      dmPolicy: json['dmPolicy'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      groupAllowFrom: (json['groupAllowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      groupPolicy: json['groupPolicy'] as String? ?? '',
      proxy: json['proxy'] as String? ?? '',
      requireMention: json['requireMention'] as bool? ?? false,
      streaming: json['streaming'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'allowFrom': allowFrom,
      'bots': bots.map((e) => e.toJson()).toList(),
      'defaultAccount': defaultAccount,
      'dmPolicy': dmPolicy,
      'enabled': enabled,
      'groupAllowFrom': groupAllowFrom,
      'groupPolicy': groupPolicy,
      'proxy': proxy,
      'requireMention': requireMention,
      'streaming': streaming,
  };
}

class AgentTokenResetReq {
  final int id;

  const AgentTokenResetReq({
    this.id = 0,
  });

  factory AgentTokenResetReq.fromJson(Map<String, dynamic> json) {
    return AgentTokenResetReq(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class AgentWebsiteBindReq {
  final int agentId;
  final int websiteId;

  const AgentWebsiteBindReq({
    this.agentId = 0,
    this.websiteId = 0,
  });

  factory AgentWebsiteBindReq.fromJson(Map<String, dynamic> json) {
    return AgentWebsiteBindReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      websiteId: (json['websiteId'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'websiteId': websiteId,
  };
}

class AgentWecomConfig {
  final List<String> allowFrom;
  final String botId;
  final String dmPolicy;
  final bool enabled;
  final List<String> groupAllowFrom;
  final String groupPolicy;
  final bool installed;
  final String secret;

  const AgentWecomConfig({
    this.allowFrom = const [],
    this.botId = '',
    this.dmPolicy = '',
    this.enabled = false,
    this.groupAllowFrom = const [],
    this.groupPolicy = '',
    this.installed = false,
    this.secret = '',
  });

  factory AgentWecomConfig.fromJson(Map<String, dynamic> json) {
    return AgentWecomConfig(
      allowFrom: (json['allowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      botId: json['botId'] as String? ?? '',
      dmPolicy: json['dmPolicy'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      groupAllowFrom: (json['groupAllowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      groupPolicy: json['groupPolicy'] as String? ?? '',
      installed: json['installed'] as bool? ?? false,
      secret: json['secret'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'allowFrom': allowFrom,
      'botId': botId,
      'dmPolicy': dmPolicy,
      'enabled': enabled,
      'groupAllowFrom': groupAllowFrom,
      'groupPolicy': groupPolicy,
      'installed': installed,
      'secret': secret,
  };
}

class AgentWecomConfigUpdateReq {
  final int agentId;
  final List<String> allowFrom;
  final String botId;
  final String dmPolicy;
  final bool enabled;
  final List<String> groupAllowFrom;
  final String groupPolicy;
  final String secret;

  const AgentWecomConfigUpdateReq({
    this.agentId = 0,
    this.allowFrom = const [],
    this.botId = '',
    this.dmPolicy = '',
    this.enabled = false,
    this.groupAllowFrom = const [],
    this.groupPolicy = '',
    this.secret = '',
  });

  factory AgentWecomConfigUpdateReq.fromJson(Map<String, dynamic> json) {
    return AgentWecomConfigUpdateReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      allowFrom: (json['allowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      botId: json['botId'] as String? ?? '',
      dmPolicy: json['dmPolicy'] as String? ?? '',
      enabled: json['enabled'] as bool? ?? false,
      groupAllowFrom: (json['groupAllowFrom'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      groupPolicy: json['groupPolicy'] as String? ?? '',
      secret: json['secret'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'allowFrom': allowFrom,
      'botId': botId,
      'dmPolicy': dmPolicy,
      'enabled': enabled,
      'groupAllowFrom': groupAllowFrom,
      'groupPolicy': groupPolicy,
      'secret': secret,
  };
}

class AgentWeixinConfig {
  final bool enabled;

  const AgentWeixinConfig({
    this.enabled = false,
  });

  factory AgentWeixinConfig.fromJson(Map<String, dynamic> json) {
    return AgentWeixinConfig(
      enabled: json['enabled'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'enabled': enabled,
  };
}

class AgentWeixinLoginReq {
  final int agentId;
  final String taskID;

  const AgentWeixinLoginReq({
    this.agentId = 0,
    this.taskID = '',
  });

  factory AgentWeixinLoginReq.fromJson(Map<String, dynamic> json) {
    return AgentWeixinLoginReq(
      agentId: (json['agentId'] as num?)?.toInt() ?? 0,
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'agentId': agentId,
      'taskID': taskID,
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

class ForceDelete {
  final bool forceDelete;
  final List<int> ids;

  const ForceDelete({
    this.forceDelete = false,
    this.ids = const [],
  });

  factory ForceDelete.fromJson(Map<String, dynamic> json) {
    return ForceDelete(
      forceDelete: json['forceDelete'] as bool? ?? false,
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'forceDelete': forceDelete,
      'ids': ids,
  };
}

class OllamaBindDomain {
  final int appInstallID;
  final String domain;
  final String ipList;
  final int sslID;
  final int websiteID;

  const OllamaBindDomain({
    this.appInstallID = 0,
    this.domain = '',
    this.ipList = '',
    this.sslID = 0,
    this.websiteID = 0,
  });

  factory OllamaBindDomain.fromJson(Map<String, dynamic> json) {
    return OllamaBindDomain(
      appInstallID: (json['appInstallID'] as num?)?.toInt() ?? 0,
      domain: json['domain'] as String? ?? '',
      ipList: json['ipList'] as String? ?? '',
      sslID: (json['sslID'] as num?)?.toInt() ?? 0,
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'appInstallID': appInstallID,
      'domain': domain,
      'ipList': ipList,
      'sslID': sslID,
      'websiteID': websiteID,
  };
}

class OllamaBindDomainReq {
  final int appInstallID;

  const OllamaBindDomainReq({
    this.appInstallID = 0,
  });

  factory OllamaBindDomainReq.fromJson(Map<String, dynamic> json) {
    return OllamaBindDomainReq(
      appInstallID: (json['appInstallID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'appInstallID': appInstallID,
  };
}

class OllamaBindDomainRes {
  final int acmeAccountID;
  final List<String> allowIPs;
  final String connUrl;
  final String domain;
  final int sslID;
  final int websiteID;

  const OllamaBindDomainRes({
    this.acmeAccountID = 0,
    this.allowIPs = const [],
    this.connUrl = '',
    this.domain = '',
    this.sslID = 0,
    this.websiteID = 0,
  });

  factory OllamaBindDomainRes.fromJson(Map<String, dynamic> json) {
    return OllamaBindDomainRes(
      acmeAccountID: (json['acmeAccountID'] as num?)?.toInt() ?? 0,
      allowIPs: (json['allowIPs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      connUrl: json['connUrl'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      sslID: (json['sslID'] as num?)?.toInt() ?? 0,
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'acmeAccountID': acmeAccountID,
      'allowIPs': allowIPs,
      'connUrl': connUrl,
      'domain': domain,
      'sslID': sslID,
      'websiteID': websiteID,
  };
}

class OllamaModelDropList {
  final int id;
  final String name;

  const OllamaModelDropList({
    this.id = 0,
    this.name = '',
  });

  factory OllamaModelDropList.fromJson(Map<String, dynamic> json) {
    return OllamaModelDropList(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
  };
}

class OllamaModelName {
  final String name;
  final String taskID;

  const OllamaModelName({
    this.name = '',
    this.taskID = '',
  });

  factory OllamaModelName.fromJson(Map<String, dynamic> json) {
    return OllamaModelName(
      name: json['name'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'taskID': taskID,
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

class ProviderAPIInfo {
  final String apiType;
  final List<String> authModes;
  final String baseUrl;
  final String defaultAuthMode;
  final bool editableBaseUrl;
  final List<ProviderModelInfo> models;
  final bool supportsModelDiscovery;

  const ProviderAPIInfo({
    this.apiType = '',
    this.authModes = const [],
    this.baseUrl = '',
    this.defaultAuthMode = '',
    this.editableBaseUrl = false,
    this.models = const [],
    this.supportsModelDiscovery = false,
  });

  factory ProviderAPIInfo.fromJson(Map<String, dynamic> json) {
    return ProviderAPIInfo(
      apiType: json['apiType'] as String? ?? '',
      authModes: (json['authModes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      baseUrl: json['baseUrl'] as String? ?? '',
      defaultAuthMode: json['defaultAuthMode'] as String? ?? '',
      editableBaseUrl: json['editableBaseUrl'] as bool? ?? false,
      models: (json['models'] as List<dynamic>?)?.map((e) => ProviderModelInfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      supportsModelDiscovery: json['supportsModelDiscovery'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'apiType': apiType,
      'authModes': authModes,
      'baseUrl': baseUrl,
      'defaultAuthMode': defaultAuthMode,
      'editableBaseUrl': editableBaseUrl,
      'models': models.map((e) => e.toJson()).toList(),
      'supportsModelDiscovery': supportsModelDiscovery,
  };
}

class ProviderInfo {
  final List<ProviderAPIInfo> apiTypes;
  final String baseUrl;
  final String defaultApiType;
  final String displayName;
  final List<ProviderModelInfo> models;
  final String provider;

  const ProviderInfo({
    this.apiTypes = const [],
    this.baseUrl = '',
    this.defaultApiType = '',
    this.displayName = '',
    this.models = const [],
    this.provider = '',
  });

  factory ProviderInfo.fromJson(Map<String, dynamic> json) {
    return ProviderInfo(
      apiTypes: (json['apiTypes'] as List<dynamic>?)?.map((e) => ProviderAPIInfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      baseUrl: json['baseUrl'] as String? ?? '',
      defaultApiType: json['defaultApiType'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      models: (json['models'] as List<dynamic>?)?.map((e) => ProviderModelInfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      provider: json['provider'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'apiTypes': apiTypes.map((e) => e.toJson()).toList(),
      'baseUrl': baseUrl,
      'defaultApiType': defaultApiType,
      'displayName': displayName,
      'models': models.map((e) => e.toJson()).toList(),
      'provider': provider,
  };
}

class ProviderModelInfo {
  final String id;
  final String name;

  const ProviderModelInfo({
    this.id = '',
    this.name = '',
  });

  factory ProviderModelInfo.fromJson(Map<String, dynamic> json) {
    return ProviderModelInfo(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
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

class Environment {
  final String key;
  final String value;

  const Environment({
    this.key = '',
    this.value = '',
  });

  factory Environment.fromJson(Map<String, dynamic> json) {
    return Environment(
      key: json['key'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'key': key,
      'value': value,
  };
}

class ExposedPort {
  final int containerPort;
  final String hostIP;
  final int hostPort;
  final String protocol;

  const ExposedPort({
    this.containerPort = 0,
    this.hostIP = '',
    this.hostPort = 0,
    this.protocol = '',
  });

  factory ExposedPort.fromJson(Map<String, dynamic> json) {
    return ExposedPort(
      containerPort: (json['containerPort'] as num?)?.toInt() ?? 0,
      hostIP: json['hostIP'] as String? ?? '',
      hostPort: (json['hostPort'] as num?)?.toInt() ?? 0,
      protocol: json['protocol'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'containerPort': containerPort,
      'hostIP': hostIP,
      'hostPort': hostPort,
      'protocol': protocol,
  };
}

class McpBindDomain {
  final String domain;
  final String ipList;
  final int sslID;

  const McpBindDomain({
    this.domain = '',
    this.ipList = '',
    this.sslID = 0,
  });

  factory McpBindDomain.fromJson(Map<String, dynamic> json) {
    return McpBindDomain(
      domain: json['domain'] as String? ?? '',
      ipList: json['ipList'] as String? ?? '',
      sslID: (json['sslID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'domain': domain,
      'ipList': ipList,
      'sslID': sslID,
  };
}

class McpBindDomainUpdate {
  final String ipList;
  final int sslID;
  final int websiteID;

  const McpBindDomainUpdate({
    this.ipList = '',
    this.sslID = 0,
    this.websiteID = 0,
  });

  factory McpBindDomainUpdate.fromJson(Map<String, dynamic> json) {
    return McpBindDomainUpdate(
      ipList: json['ipList'] as String? ?? '',
      sslID: (json['sslID'] as num?)?.toInt() ?? 0,
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'ipList': ipList,
      'sslID': sslID,
      'websiteID': websiteID,
  };
}

class McpServerConnectionTest {
  final int id;

  const McpServerConnectionTest({
    this.id = 0,
  });

  factory McpServerConnectionTest.fromJson(Map<String, dynamic> json) {
    return McpServerConnectionTest(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class McpServerCreate {
  final String baseUrl;
  final String command;
  final String containerName;
  final List<Environment> environments;
  final String gatewayArgs;
  final String gatewayImage;
  final String hostIP;
  final String name;
  final String outputTransport;
  final int port;
  final String protocolVersion;
  final String ssePath;
  final String streamableHttpPath;
  final String taskID;
  final String type;
  final List<Volume> volumes;

  const McpServerCreate({
    this.baseUrl = '',
    this.command = '',
    this.containerName = '',
    this.environments = const [],
    this.gatewayArgs = '',
    this.gatewayImage = '',
    this.hostIP = '',
    this.name = '',
    this.outputTransport = '',
    this.port = 0,
    this.protocolVersion = '',
    this.ssePath = '',
    this.streamableHttpPath = '',
    this.taskID = '',
    this.type = '',
    this.volumes = const [],
  });

  factory McpServerCreate.fromJson(Map<String, dynamic> json) {
    return McpServerCreate(
      baseUrl: json['baseUrl'] as String? ?? '',
      command: json['command'] as String? ?? '',
      containerName: json['containerName'] as String? ?? '',
      environments: (json['environments'] as List<dynamic>?)?.map((e) => Environment.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      gatewayArgs: json['gatewayArgs'] as String? ?? '',
      gatewayImage: json['gatewayImage'] as String? ?? '',
      hostIP: json['hostIP'] as String? ?? '',
      name: json['name'] as String? ?? '',
      outputTransport: json['outputTransport'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      protocolVersion: json['protocolVersion'] as String? ?? '',
      ssePath: json['ssePath'] as String? ?? '',
      streamableHttpPath: json['streamableHttpPath'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      type: json['type'] as String? ?? '',
      volumes: (json['volumes'] as List<dynamic>?)?.map((e) => Volume.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'baseUrl': baseUrl,
      'command': command,
      'containerName': containerName,
      'environments': environments.map((e) => e.toJson()).toList(),
      'gatewayArgs': gatewayArgs,
      'gatewayImage': gatewayImage,
      'hostIP': hostIP,
      'name': name,
      'outputTransport': outputTransport,
      'port': port,
      'protocolVersion': protocolVersion,
      'ssePath': ssePath,
      'streamableHttpPath': streamableHttpPath,
      'taskID': taskID,
      'type': type,
      'volumes': volumes.map((e) => e.toJson()).toList(),
  };
}

class McpServerDelete {
  final int id;

  const McpServerDelete({
    this.id = 0,
  });

  factory McpServerDelete.fromJson(Map<String, dynamic> json) {
    return McpServerDelete(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class McpServerDetail {
  final int id;

  const McpServerDetail({
    this.id = 0,
  });

  factory McpServerDetail.fromJson(Map<String, dynamic> json) {
    return McpServerDetail(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class McpServerOperate {
  final int id;
  final String operate;

  const McpServerOperate({
    this.id = 0,
    this.operate = '',
  });

  factory McpServerOperate.fromJson(Map<String, dynamic> json) {
    return McpServerOperate(
      id: (json['id'] as num?)?.toInt() ?? 0,
      operate: json['operate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'operate': operate,
  };
}

class McpServerSearch {
  final String name;
  final int page;
  final int pageSize;
  final bool $sync;

  const McpServerSearch({
    this.name = '',
    this.page = 0,
    this.pageSize = 0,
    this.$sync = false,
  });

  factory McpServerSearch.fromJson(Map<String, dynamic> json) {
    return McpServerSearch(
      name: json['name'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      $sync: json['sync'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'page': page,
      'pageSize': pageSize,
      'sync': $sync,
  };
}

class McpServerStatusSync {
  final List<int> ids;

  const McpServerStatusSync({
    this.ids = const [],
  });

  factory McpServerStatusSync.fromJson(Map<String, dynamic> json) {
    return McpServerStatusSync(
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'ids': ids,
  };
}

class McpServerUpdate {
  final String baseUrl;
  final String command;
  final String containerName;
  final List<Environment> environments;
  final String gatewayArgs;
  final String gatewayImage;
  final String hostIP;
  final int id;
  final String name;
  final String outputTransport;
  final int port;
  final String protocolVersion;
  final String ssePath;
  final String streamableHttpPath;
  final String taskID;
  final String type;
  final List<Volume> volumes;

  const McpServerUpdate({
    this.baseUrl = '',
    this.command = '',
    this.containerName = '',
    this.environments = const [],
    this.gatewayArgs = '',
    this.gatewayImage = '',
    this.hostIP = '',
    this.id = 0,
    this.name = '',
    this.outputTransport = '',
    this.port = 0,
    this.protocolVersion = '',
    this.ssePath = '',
    this.streamableHttpPath = '',
    this.taskID = '',
    this.type = '',
    this.volumes = const [],
  });

  factory McpServerUpdate.fromJson(Map<String, dynamic> json) {
    return McpServerUpdate(
      baseUrl: json['baseUrl'] as String? ?? '',
      command: json['command'] as String? ?? '',
      containerName: json['containerName'] as String? ?? '',
      environments: (json['environments'] as List<dynamic>?)?.map((e) => Environment.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      gatewayArgs: json['gatewayArgs'] as String? ?? '',
      gatewayImage: json['gatewayImage'] as String? ?? '',
      hostIP: json['hostIP'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      outputTransport: json['outputTransport'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      protocolVersion: json['protocolVersion'] as String? ?? '',
      ssePath: json['ssePath'] as String? ?? '',
      streamableHttpPath: json['streamableHttpPath'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      type: json['type'] as String? ?? '',
      volumes: (json['volumes'] as List<dynamic>?)?.map((e) => Volume.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'baseUrl': baseUrl,
      'command': command,
      'containerName': containerName,
      'environments': environments.map((e) => e.toJson()).toList(),
      'gatewayArgs': gatewayArgs,
      'gatewayImage': gatewayImage,
      'hostIP': hostIP,
      'id': id,
      'name': name,
      'outputTransport': outputTransport,
      'port': port,
      'protocolVersion': protocolVersion,
      'ssePath': ssePath,
      'streamableHttpPath': streamableHttpPath,
      'taskID': taskID,
      'type': type,
      'volumes': volumes.map((e) => e.toJson()).toList(),
  };
}

class TensorRTLLMCreate {
  final String command;
  final String containerName;
  final List<Environment> environments;
  final List<ExposedPort> exposedPorts;
  final String image;
  final String modelDir;
  final bool modelSpeedup;
  final String modelType;
  final String name;
  final String version;
  final List<Volume> volumes;

  const TensorRTLLMCreate({
    this.command = '',
    this.containerName = '',
    this.environments = const [],
    this.exposedPorts = const [],
    this.image = '',
    this.modelDir = '',
    this.modelSpeedup = false,
    this.modelType = '',
    this.name = '',
    this.version = '',
    this.volumes = const [],
  });

  factory TensorRTLLMCreate.fromJson(Map<String, dynamic> json) {
    return TensorRTLLMCreate(
      command: json['command'] as String? ?? '',
      containerName: json['containerName'] as String? ?? '',
      environments: (json['environments'] as List<dynamic>?)?.map((e) => Environment.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      exposedPorts: (json['exposedPorts'] as List<dynamic>?)?.map((e) => ExposedPort.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      image: json['image'] as String? ?? '',
      modelDir: json['modelDir'] as String? ?? '',
      modelSpeedup: json['modelSpeedup'] as bool? ?? false,
      modelType: json['modelType'] as String? ?? '',
      name: json['name'] as String? ?? '',
      version: json['version'] as String? ?? '',
      volumes: (json['volumes'] as List<dynamic>?)?.map((e) => Volume.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'command': command,
      'containerName': containerName,
      'environments': environments.map((e) => e.toJson()).toList(),
      'exposedPorts': exposedPorts.map((e) => e.toJson()).toList(),
      'image': image,
      'modelDir': modelDir,
      'modelSpeedup': modelSpeedup,
      'modelType': modelType,
      'name': name,
      'version': version,
      'volumes': volumes.map((e) => e.toJson()).toList(),
  };
}

class TensorRTLLMDelete {
  final int id;

  const TensorRTLLMDelete({
    this.id = 0,
  });

  factory TensorRTLLMDelete.fromJson(Map<String, dynamic> json) {
    return TensorRTLLMDelete(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}

class TensorRTLLMOperate {
  final int id;
  final String operate;

  const TensorRTLLMOperate({
    this.id = 0,
    this.operate = '',
  });

  factory TensorRTLLMOperate.fromJson(Map<String, dynamic> json) {
    return TensorRTLLMOperate(
      id: (json['id'] as num?)?.toInt() ?? 0,
      operate: json['operate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'operate': operate,
  };
}

class TensorRTLLMSearch {
  final String name;
  final int page;
  final int pageSize;

  const TensorRTLLMSearch({
    this.name = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory TensorRTLLMSearch.fromJson(Map<String, dynamic> json) {
    return TensorRTLLMSearch(
      name: json['name'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'page': page,
      'pageSize': pageSize,
  };
}

class TensorRTLLMUpdate {
  final String command;
  final String containerName;
  final List<Environment> environments;
  final List<ExposedPort> exposedPorts;
  final int id;
  final String image;
  final String modelDir;
  final bool modelSpeedup;
  final String modelType;
  final String name;
  final String version;
  final List<Volume> volumes;

  const TensorRTLLMUpdate({
    this.command = '',
    this.containerName = '',
    this.environments = const [],
    this.exposedPorts = const [],
    this.id = 0,
    this.image = '',
    this.modelDir = '',
    this.modelSpeedup = false,
    this.modelType = '',
    this.name = '',
    this.version = '',
    this.volumes = const [],
  });

  factory TensorRTLLMUpdate.fromJson(Map<String, dynamic> json) {
    return TensorRTLLMUpdate(
      command: json['command'] as String? ?? '',
      containerName: json['containerName'] as String? ?? '',
      environments: (json['environments'] as List<dynamic>?)?.map((e) => Environment.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      exposedPorts: (json['exposedPorts'] as List<dynamic>?)?.map((e) => ExposedPort.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
      image: json['image'] as String? ?? '',
      modelDir: json['modelDir'] as String? ?? '',
      modelSpeedup: json['modelSpeedup'] as bool? ?? false,
      modelType: json['modelType'] as String? ?? '',
      name: json['name'] as String? ?? '',
      version: json['version'] as String? ?? '',
      volumes: (json['volumes'] as List<dynamic>?)?.map((e) => Volume.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'command': command,
      'containerName': containerName,
      'environments': environments.map((e) => e.toJson()).toList(),
      'exposedPorts': exposedPorts.map((e) => e.toJson()).toList(),
      'id': id,
      'image': image,
      'modelDir': modelDir,
      'modelSpeedup': modelSpeedup,
      'modelType': modelType,
      'name': name,
      'version': version,
      'volumes': volumes.map((e) => e.toJson()).toList(),
  };
}

class Volume {
  final String mode;
  final String source;
  final String target;

  const Volume({
    this.mode = '',
    this.source = '',
    this.target = '',
  });

  factory Volume.fromJson(Map<String, dynamic> json) {
    return Volume(
      mode: json['mode'] as String? ?? '',
      source: json['source'] as String? ?? '',
      target: json['target'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'mode': mode,
      'source': source,
      'target': target,
  };
}

class McpBindDomainRes {
  final int acmeAccountID;
  final List<String> allowIPs;
  final String connUrl;
  final String domain;
  final int sslID;
  final int websiteID;

  const McpBindDomainRes({
    this.acmeAccountID = 0,
    this.allowIPs = const [],
    this.connUrl = '',
    this.domain = '',
    this.sslID = 0,
    this.websiteID = 0,
  });

  factory McpBindDomainRes.fromJson(Map<String, dynamic> json) {
    return McpBindDomainRes(
      acmeAccountID: (json['acmeAccountID'] as num?)?.toInt() ?? 0,
      allowIPs: (json['allowIPs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      connUrl: json['connUrl'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      sslID: (json['sslID'] as num?)?.toInt() ?? 0,
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'acmeAccountID': acmeAccountID,
      'allowIPs': allowIPs,
      'connUrl': connUrl,
      'domain': domain,
      'sslID': sslID,
      'websiteID': websiteID,
  };
}

class McpServerConnectionTestRes {
  final String endpoint;
  final String message;
  final String outputTransport;
  final String protocolVersion;
  final bool success;

  const McpServerConnectionTestRes({
    this.endpoint = '',
    this.message = '',
    this.outputTransport = '',
    this.protocolVersion = '',
    this.success = false,
  });

  factory McpServerConnectionTestRes.fromJson(Map<String, dynamic> json) {
    return McpServerConnectionTestRes(
      endpoint: json['endpoint'] as String? ?? '',
      message: json['message'] as String? ?? '',
      outputTransport: json['outputTransport'] as String? ?? '',
      protocolVersion: json['protocolVersion'] as String? ?? '',
      success: json['success'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'endpoint': endpoint,
      'message': message,
      'outputTransport': outputTransport,
      'protocolVersion': protocolVersion,
      'success': success,
  };
}

class McpServerDTO {
  final String baseUrl;
  final String command;
  final String containerName;
  final String createdAt;
  final String dir;
  final String dockerCompose;
  final String env;
  final List<Environment> environments;
  final String gatewayArgs;
  final String gatewayImage;
  final String hostIP;
  final int id;
  final String message;
  final String name;
  final String outputTransport;
  final int port;
  final String protocolVersion;
  final String ssePath;
  final String status;
  final String streamableHttpPath;
  final String type;
  final String updatedAt;
  final List<Volume> volumes;
  final int websiteID;

  const McpServerDTO({
    this.baseUrl = '',
    this.command = '',
    this.containerName = '',
    this.createdAt = '',
    this.dir = '',
    this.dockerCompose = '',
    this.env = '',
    this.environments = const [],
    this.gatewayArgs = '',
    this.gatewayImage = '',
    this.hostIP = '',
    this.id = 0,
    this.message = '',
    this.name = '',
    this.outputTransport = '',
    this.port = 0,
    this.protocolVersion = '',
    this.ssePath = '',
    this.status = '',
    this.streamableHttpPath = '',
    this.type = '',
    this.updatedAt = '',
    this.volumes = const [],
    this.websiteID = 0,
  });

  factory McpServerDTO.fromJson(Map<String, dynamic> json) {
    return McpServerDTO(
      baseUrl: json['baseUrl'] as String? ?? '',
      command: json['command'] as String? ?? '',
      containerName: json['containerName'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      dir: json['dir'] as String? ?? '',
      dockerCompose: json['dockerCompose'] as String? ?? '',
      env: json['env'] as String? ?? '',
      environments: (json['environments'] as List<dynamic>?)?.map((e) => Environment.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      gatewayArgs: json['gatewayArgs'] as String? ?? '',
      gatewayImage: json['gatewayImage'] as String? ?? '',
      hostIP: json['hostIP'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      name: json['name'] as String? ?? '',
      outputTransport: json['outputTransport'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      protocolVersion: json['protocolVersion'] as String? ?? '',
      ssePath: json['ssePath'] as String? ?? '',
      status: json['status'] as String? ?? '',
      streamableHttpPath: json['streamableHttpPath'] as String? ?? '',
      type: json['type'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      volumes: (json['volumes'] as List<dynamic>?)?.map((e) => Volume.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      websiteID: (json['websiteID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'baseUrl': baseUrl,
      'command': command,
      'containerName': containerName,
      'createdAt': createdAt,
      'dir': dir,
      'dockerCompose': dockerCompose,
      'env': env,
      'environments': environments.map((e) => e.toJson()).toList(),
      'gatewayArgs': gatewayArgs,
      'gatewayImage': gatewayImage,
      'hostIP': hostIP,
      'id': id,
      'message': message,
      'name': name,
      'outputTransport': outputTransport,
      'port': port,
      'protocolVersion': protocolVersion,
      'ssePath': ssePath,
      'status': status,
      'streamableHttpPath': streamableHttpPath,
      'type': type,
      'updatedAt': updatedAt,
      'volumes': volumes.map((e) => e.toJson()).toList(),
      'websiteID': websiteID,
  };
}

class McpServerStatusDTO {
  final int id;
  final String message;
  final String status;

  const McpServerStatusDTO({
    this.id = 0,
    this.message = '',
    this.status = '',
  });

  factory McpServerStatusDTO.fromJson(Map<String, dynamic> json) {
    return McpServerStatusDTO(
      id: (json['id'] as num?)?.toInt() ?? 0,
      message: json['message'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'message': message,
      'status': status,
  };
}

class McpServersRes {
  final List<McpServerDTO> items;
  final int total;

  const McpServersRes({
    this.items = const [],
    this.total = 0,
  });

  factory McpServersRes.fromJson(Map<String, dynamic> json) {
    return McpServersRes(
      items: (json['items'] as List<dynamic>?)?.map((e) => McpServerDTO.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      total: (json['total'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
  };
}
