// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

class ChangeGroup {
  final int groupID;
  final int id;

  const ChangeGroup({
    this.groupID = 0,
    this.id = 0,
  });

  factory ChangeGroup.fromJson(Map<String, dynamic> json) {
    return ChangeGroup(
      groupID: (json['groupID'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'groupID': groupID,
      'id': id,
  };
}

class CronjobBatchDelete {
  final bool cleanData;
  final bool cleanRemoteData;
  final List<int> ids;

  const CronjobBatchDelete({
    this.cleanData = false,
    this.cleanRemoteData = false,
    this.ids = const [],
  });

  factory CronjobBatchDelete.fromJson(Map<String, dynamic> json) {
    return CronjobBatchDelete(
      cleanData: json['cleanData'] as bool? ?? false,
      cleanRemoteData: json['cleanRemoteData'] as bool? ?? false,
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'cleanData': cleanData,
      'cleanRemoteData': cleanRemoteData,
      'ids': ids,
  };
}

class CronjobClean {
  final bool cleanData;
  final bool cleanRemoteData;
  final int cronjobID;
  final bool isDelete;

  const CronjobClean({
    this.cleanData = false,
    this.cleanRemoteData = false,
    this.cronjobID = 0,
    this.isDelete = false,
  });

  factory CronjobClean.fromJson(Map<String, dynamic> json) {
    return CronjobClean(
      cleanData: json['cleanData'] as bool? ?? false,
      cleanRemoteData: json['cleanRemoteData'] as bool? ?? false,
      cronjobID: (json['cronjobID'] as num?)?.toInt() ?? 0,
      isDelete: json['isDelete'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'cleanData': cleanData,
      'cleanRemoteData': cleanRemoteData,
      'cronjobID': cronjobID,
      'isDelete': isDelete,
  };
}

class CronjobImport {
  final List<CronjobTrans> cronjobs;

  const CronjobImport({
    this.cronjobs = const [],
  });

  factory CronjobImport.fromJson(Map<String, dynamic> json) {
    return CronjobImport(
      cronjobs: (json['cronjobs'] as List<dynamic>?)?.map((e) => CronjobTrans.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'cronjobs': cronjobs.map((e) => e.toJson()).toList(),
  };
}

class CronjobOperate {
  final int alertCount;
  final String alertMethod;
  final String alertTitle;
  final String appID;
  final String args;
  final String command;
  final String containerName;
  final String dbName;
  final String dbType;
  final int downloadAccountID;
  final String exclusionRules;
  final String executor;
  final int groupID;
  final int id;
  final bool ignoreErr;
  final bool isDir;
  final String name;
  final int retainCopies;
  final int retryTimes;
  final List<String> scopes;
  final String script;
  final int scriptID;
  final String scriptMode;
  final String secret;
  final SnapshotRule? snapshotRule;
  final String sourceAccountIDs;
  final String sourceDir;
  final String spec;
  final bool specCustom;
  final int timeout;
  final String type;
  final String url;
  final String user;
  final String website;

  const CronjobOperate({
    this.alertCount = 0,
    this.alertMethod = '',
    this.alertTitle = '',
    this.appID = '',
    this.args = '',
    this.command = '',
    this.containerName = '',
    this.dbName = '',
    this.dbType = '',
    this.downloadAccountID = 0,
    this.exclusionRules = '',
    this.executor = '',
    this.groupID = 0,
    this.id = 0,
    this.ignoreErr = false,
    this.isDir = false,
    this.name = '',
    this.retainCopies = 0,
    this.retryTimes = 0,
    this.scopes = const [],
    this.script = '',
    this.scriptID = 0,
    this.scriptMode = '',
    this.secret = '',
    this.snapshotRule,
    this.sourceAccountIDs = '',
    this.sourceDir = '',
    this.spec = '',
    this.specCustom = false,
    this.timeout = 0,
    this.type = '',
    this.url = '',
    this.user = '',
    this.website = '',
  });

  factory CronjobOperate.fromJson(Map<String, dynamic> json) {
    return CronjobOperate(
      alertCount: (json['alertCount'] as num?)?.toInt() ?? 0,
      alertMethod: json['alertMethod'] as String? ?? '',
      alertTitle: json['alertTitle'] as String? ?? '',
      appID: json['appID'] as String? ?? '',
      args: json['args'] as String? ?? '',
      command: json['command'] as String? ?? '',
      containerName: json['containerName'] as String? ?? '',
      dbName: json['dbName'] as String? ?? '',
      dbType: json['dbType'] as String? ?? '',
      downloadAccountID: (json['downloadAccountID'] as num?)?.toInt() ?? 0,
      exclusionRules: json['exclusionRules'] as String? ?? '',
      executor: json['executor'] as String? ?? '',
      groupID: (json['groupID'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      ignoreErr: json['ignoreErr'] as bool? ?? false,
      isDir: json['isDir'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      retainCopies: (json['retainCopies'] as num?)?.toInt() ?? 0,
      retryTimes: (json['retryTimes'] as num?)?.toInt() ?? 0,
      scopes: (json['scopes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      script: json['script'] as String? ?? '',
      scriptID: (json['scriptID'] as num?)?.toInt() ?? 0,
      scriptMode: json['scriptMode'] as String? ?? '',
      secret: json['secret'] as String? ?? '',
      snapshotRule: json['snapshotRule'] != null ? SnapshotRule.fromJson(json['snapshotRule'] as Map<String, dynamic>) : null,
      sourceAccountIDs: json['sourceAccountIDs'] as String? ?? '',
      sourceDir: json['sourceDir'] as String? ?? '',
      spec: json['spec'] as String? ?? '',
      specCustom: json['specCustom'] as bool? ?? false,
      timeout: (json['timeout'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      url: json['url'] as String? ?? '',
      user: json['user'] as String? ?? '',
      website: json['website'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'alertCount': alertCount,
      'alertMethod': alertMethod,
      'alertTitle': alertTitle,
      'appID': appID,
      'args': args,
      'command': command,
      'containerName': containerName,
      'dbName': dbName,
      'dbType': dbType,
      'downloadAccountID': downloadAccountID,
      'exclusionRules': exclusionRules,
      'executor': executor,
      'groupID': groupID,
      'id': id,
      'ignoreErr': ignoreErr,
      'isDir': isDir,
      'name': name,
      'retainCopies': retainCopies,
      'retryTimes': retryTimes,
      'scopes': scopes,
      'script': script,
      'scriptID': scriptID,
      'scriptMode': scriptMode,
      'secret': secret,
      if (snapshotRule != null) 'snapshotRule': snapshotRule!.toJson(),
      'sourceAccountIDs': sourceAccountIDs,
      'sourceDir': sourceDir,
      'spec': spec,
      'specCustom': specCustom,
      'timeout': timeout,
      'type': type,
      'url': url,
      'user': user,
      'website': website,
  };
}

class CronjobSpec {
  final String spec;

  const CronjobSpec({
    this.spec = '',
  });

  factory CronjobSpec.fromJson(Map<String, dynamic> json) {
    return CronjobSpec(
      spec: json['spec'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'spec': spec,
  };
}

class CronjobTrans {
  final int alertCount;
  final String alertMethod;
  final String alertTitle;
  final List<TransHelper> apps;
  final String args;
  final String command;
  final String containerName;
  final List<TransHelper> dbName;
  final String dbType;
  final String downloadAccount;
  final String exclusionRules;
  final String executor;
  final int groupID;
  final bool ignoreErr;
  final bool isDir;
  final String name;
  final int retainCopies;
  final int retryTimes;
  final String script;
  final String scriptMode;
  final String scriptName;
  final String secret;
  final SnapshotTransHelper? snapshotRule;
  final List<String> sourceAccounts;
  final String sourceDir;
  final String spec;
  final bool specCustom;
  final int timeout;
  final String type;
  final String url;
  final String user;
  final List<String> websites;

  const CronjobTrans({
    this.alertCount = 0,
    this.alertMethod = '',
    this.alertTitle = '',
    this.apps = const [],
    this.args = '',
    this.command = '',
    this.containerName = '',
    this.dbName = const [],
    this.dbType = '',
    this.downloadAccount = '',
    this.exclusionRules = '',
    this.executor = '',
    this.groupID = 0,
    this.ignoreErr = false,
    this.isDir = false,
    this.name = '',
    this.retainCopies = 0,
    this.retryTimes = 0,
    this.script = '',
    this.scriptMode = '',
    this.scriptName = '',
    this.secret = '',
    this.snapshotRule,
    this.sourceAccounts = const [],
    this.sourceDir = '',
    this.spec = '',
    this.specCustom = false,
    this.timeout = 0,
    this.type = '',
    this.url = '',
    this.user = '',
    this.websites = const [],
  });

  factory CronjobTrans.fromJson(Map<String, dynamic> json) {
    return CronjobTrans(
      alertCount: (json['alertCount'] as num?)?.toInt() ?? 0,
      alertMethod: json['alertMethod'] as String? ?? '',
      alertTitle: json['alertTitle'] as String? ?? '',
      apps: (json['apps'] as List<dynamic>?)?.map((e) => TransHelper.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      args: json['args'] as String? ?? '',
      command: json['command'] as String? ?? '',
      containerName: json['containerName'] as String? ?? '',
      dbName: (json['dbName'] as List<dynamic>?)?.map((e) => TransHelper.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      dbType: json['dbType'] as String? ?? '',
      downloadAccount: json['downloadAccount'] as String? ?? '',
      exclusionRules: json['exclusionRules'] as String? ?? '',
      executor: json['executor'] as String? ?? '',
      groupID: (json['groupID'] as num?)?.toInt() ?? 0,
      ignoreErr: json['ignoreErr'] as bool? ?? false,
      isDir: json['isDir'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      retainCopies: (json['retainCopies'] as num?)?.toInt() ?? 0,
      retryTimes: (json['retryTimes'] as num?)?.toInt() ?? 0,
      script: json['script'] as String? ?? '',
      scriptMode: json['scriptMode'] as String? ?? '',
      scriptName: json['scriptName'] as String? ?? '',
      secret: json['secret'] as String? ?? '',
      snapshotRule: json['snapshotRule'] != null ? SnapshotTransHelper.fromJson(json['snapshotRule'] as Map<String, dynamic>) : null,
      sourceAccounts: (json['sourceAccounts'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      sourceDir: json['sourceDir'] as String? ?? '',
      spec: json['spec'] as String? ?? '',
      specCustom: json['specCustom'] as bool? ?? false,
      timeout: (json['timeout'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      url: json['url'] as String? ?? '',
      user: json['user'] as String? ?? '',
      websites: (json['websites'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'alertCount': alertCount,
      'alertMethod': alertMethod,
      'alertTitle': alertTitle,
      'apps': apps.map((e) => e.toJson()).toList(),
      'args': args,
      'command': command,
      'containerName': containerName,
      'dbName': dbName.map((e) => e.toJson()).toList(),
      'dbType': dbType,
      'downloadAccount': downloadAccount,
      'exclusionRules': exclusionRules,
      'executor': executor,
      'groupID': groupID,
      'ignoreErr': ignoreErr,
      'isDir': isDir,
      'name': name,
      'retainCopies': retainCopies,
      'retryTimes': retryTimes,
      'script': script,
      'scriptMode': scriptMode,
      'scriptName': scriptName,
      'secret': secret,
      if (snapshotRule != null) 'snapshotRule': snapshotRule!.toJson(),
      'sourceAccounts': sourceAccounts,
      'sourceDir': sourceDir,
      'spec': spec,
      'specCustom': specCustom,
      'timeout': timeout,
      'type': type,
      'url': url,
      'user': user,
      'websites': websites,
  };
}

class CronjobUpdateStatus {
  final int id;
  final String status;

  const CronjobUpdateStatus({
    this.id = 0,
    this.status = '',
  });

  factory CronjobUpdateStatus.fromJson(Map<String, dynamic> json) {
    return CronjobUpdateStatus(
      id: (json['id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'status': status,
  };
}

class OperateByID {
  final int id;

  const OperateByID({
    this.id = 0,
  });

  factory OperateByID.fromJson(Map<String, dynamic> json) {
    return OperateByID(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
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

class OperateByTaskID {
  final String taskID;

  const OperateByTaskID({
    this.taskID = '',
  });

  factory OperateByTaskID.fromJson(Map<String, dynamic> json) {
    return OperateByTaskID(
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'taskID': taskID,
  };
}

class PageCronjob {
  final List<int> groupIDs;
  final String info;
  final String order;
  final String orderBy;
  final int page;
  final int pageSize;

  const PageCronjob({
    this.groupIDs = const [],
    this.info = '',
    this.order = '',
    this.orderBy = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory PageCronjob.fromJson(Map<String, dynamic> json) {
    return PageCronjob(
      groupIDs: (json['groupIDs'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
      info: json['info'] as String? ?? '',
      order: json['order'] as String? ?? '',
      orderBy: json['orderBy'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'groupIDs': groupIDs,
      'info': info,
      'order': order,
      'orderBy': orderBy,
      'page': page,
      'pageSize': pageSize,
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

class ScriptOperate {
  final String description;
  final String groups;
  final int id;
  final bool isInteractive;
  final String name;
  final String script;

  const ScriptOperate({
    this.description = '',
    this.groups = '',
    this.id = 0,
    this.isInteractive = false,
    this.name = '',
    this.script = '',
  });

  factory ScriptOperate.fromJson(Map<String, dynamic> json) {
    return ScriptOperate(
      description: json['description'] as String? ?? '',
      groups: json['groups'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      isInteractive: json['isInteractive'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      script: json['script'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'description': description,
      'groups': groups,
      'id': id,
      'isInteractive': isInteractive,
      'name': name,
      'script': script,
  };
}

class ScriptOptions {
  final int id;
  final String name;

  const ScriptOptions({
    this.id = 0,
    this.name = '',
  });

  factory ScriptOptions.fromJson(Map<String, dynamic> json) {
    return ScriptOptions(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
  };
}

class SearchPageWithGroup {
  final int groupID;
  final String info;
  final int page;
  final int pageSize;

  const SearchPageWithGroup({
    this.groupID = 0,
    this.info = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory SearchPageWithGroup.fromJson(Map<String, dynamic> json) {
    return SearchPageWithGroup(
      groupID: (json['groupID'] as num?)?.toInt() ?? 0,
      info: json['info'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'groupID': groupID,
      'info': info,
      'page': page,
      'pageSize': pageSize,
  };
}

class SearchRecord {
  final int cronjobID;
  final String endTime;
  final int page;
  final int pageSize;
  final String startTime;
  final String status;

  const SearchRecord({
    this.cronjobID = 0,
    this.endTime = '',
    this.page = 0,
    this.pageSize = 0,
    this.startTime = '',
    this.status = '',
  });

  factory SearchRecord.fromJson(Map<String, dynamic> json) {
    return SearchRecord(
      cronjobID: (json['cronjobID'] as num?)?.toInt() ?? 0,
      endTime: json['endTime'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      startTime: json['startTime'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'cronjobID': cronjobID,
      'endTime': endTime,
      'page': page,
      'pageSize': pageSize,
      'startTime': startTime,
      'status': status,
  };
}

class SnapshotRule {
  final List<int> ignoreAppIDs;
  final bool withImage;

  const SnapshotRule({
    this.ignoreAppIDs = const [],
    this.withImage = false,
  });

  factory SnapshotRule.fromJson(Map<String, dynamic> json) {
    return SnapshotRule(
      ignoreAppIDs: (json['ignoreAppIDs'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
      withImage: json['withImage'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'ignoreAppIDs': ignoreAppIDs,
      'withImage': withImage,
  };
}

class SnapshotTransHelper {
  final List<TransHelper> ignoreApps;
  final bool withImage;

  const SnapshotTransHelper({
    this.ignoreApps = const [],
    this.withImage = false,
  });

  factory SnapshotTransHelper.fromJson(Map<String, dynamic> json) {
    return SnapshotTransHelper(
      ignoreApps: (json['ignoreApps'] as List<dynamic>?)?.map((e) => TransHelper.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      withImage: json['withImage'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'ignoreApps': ignoreApps.map((e) => e.toJson()).toList(),
      'withImage': withImage,
  };
}

class TransHelper {
  final String detailName;
  final String name;

  const TransHelper({
    this.detailName = '',
    this.name = '',
  });

  factory TransHelper.fromJson(Map<String, dynamic> json) {
    return TransHelper(
      detailName: json['detailName'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'detailName': detailName,
      'name': name,
  };
}
