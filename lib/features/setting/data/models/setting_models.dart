// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

class AgentSettingUpdate {
  final String key;
  final String value;

  const AgentSettingUpdate({
    this.key = '',
    this.value = '',
  });

  factory AgentSettingUpdate.fromJson(Map<String, dynamic> json) {
    return AgentSettingUpdate(
      key: json['key'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'key': key,
      'value': value,
  };
}

class BackupClientInfo {
  final String clientId;
  final String clientSecret;
  final String redirectUri;

  const BackupClientInfo({
    this.clientId = '',
    this.clientSecret = '',
    this.redirectUri = '',
  });

  factory BackupClientInfo.fromJson(Map<String, dynamic> json) {
    return BackupClientInfo(
      clientId: json['client_id'] as String? ?? '',
      clientSecret: json['client_secret'] as String? ?? '',
      redirectUri: json['redirect_uri'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'client_id': clientId,
      'client_secret': clientSecret,
      'redirect_uri': redirectUri,
  };
}

class BackupOperate {
  final String accessKey;
  final String backupPath;
  final String bucket;
  final String credential;
  final int id;
  final bool isPublic;
  final String name;
  final bool rememberAuth;
  final String type;
  final String vars;

  const BackupOperate({
    this.accessKey = '',
    this.backupPath = '',
    this.bucket = '',
    this.credential = '',
    this.id = 0,
    this.isPublic = false,
    this.name = '',
    this.rememberAuth = false,
    this.type = '',
    this.vars = '',
  });

  factory BackupOperate.fromJson(Map<String, dynamic> json) {
    return BackupOperate(
      accessKey: json['accessKey'] as String? ?? '',
      backupPath: json['backupPath'] as String? ?? '',
      bucket: json['bucket'] as String? ?? '',
      credential: json['credential'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      isPublic: json['isPublic'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      rememberAuth: json['rememberAuth'] as bool? ?? false,
      type: json['type'] as String? ?? '',
      vars: json['vars'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accessKey': accessKey,
      'backupPath': backupPath,
      'bucket': bucket,
      'credential': credential,
      'id': id,
      'isPublic': isPublic,
      'name': name,
      'rememberAuth': rememberAuth,
      'type': type,
      'vars': vars,
  };
}

class BackupOption {
  final int id;
  final bool isPublic;
  final String name;
  final String type;

  const BackupOption({
    this.id = 0,
    this.isPublic = false,
    this.name = '',
    this.type = '',
  });

  factory BackupOption.fromJson(Map<String, dynamic> json) {
    return BackupOption(
      id: (json['id'] as num?)?.toInt() ?? 0,
      isPublic: json['isPublic'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'isPublic': isPublic,
      'name': name,
      'type': type,
  };
}

class BatchDeleteReq {
  final List<int> ids;

  const BatchDeleteReq({
    this.ids = const [],
  });

  factory BatchDeleteReq.fromJson(Map<String, dynamic> json) {
    return BatchDeleteReq(
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'ids': ids,
  };
}

class BindInfo {
  final String bindAddress;
  final String ipv6;

  const BindInfo({
    this.bindAddress = '',
    this.ipv6 = '',
  });

  factory BindInfo.fromJson(Map<String, dynamic> json) {
    return BindInfo(
      bindAddress: json['bindAddress'] as String? ?? '',
      ipv6: json['ipv6'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'bindAddress': bindAddress,
      'ipv6': ipv6,
  };
}

class CommonBackup {
  final List<String> args;
  final String description;
  final String detailName;
  final String fileName;
  final bool isImmediate;
  final String name;
  final String secret;
  final bool stopBefore;
  final String taskID;
  final String type;

  const CommonBackup({
    this.args = const [],
    this.description = '',
    this.detailName = '',
    this.fileName = '',
    this.isImmediate = false,
    this.name = '',
    this.secret = '',
    this.stopBefore = false,
    this.taskID = '',
    this.type = '',
  });

  factory CommonBackup.fromJson(Map<String, dynamic> json) {
    return CommonBackup(
      args: (json['args'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      description: json['description'] as String? ?? '',
      detailName: json['detailName'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
      isImmediate: json['isImmediate'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      secret: json['secret'] as String? ?? '',
      stopBefore: json['stopBefore'] as bool? ?? false,
      taskID: json['taskID'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'args': args,
      'description': description,
      'detailName': detailName,
      'fileName': fileName,
      'isImmediate': isImmediate,
      'name': name,
      'secret': secret,
      'stopBefore': stopBefore,
      'taskID': taskID,
      'type': type,
  };
}

class CommonDescription {
  final String description;
  final String detailType;
  final String id;
  final bool isPinned;
  final String type;

  const CommonDescription({
    this.description = '',
    this.detailType = '',
    this.id = '',
    this.isPinned = false,
    this.type = '',
  });

  factory CommonDescription.fromJson(Map<String, dynamic> json) {
    return CommonDescription(
      description: json['description'] as String? ?? '',
      detailType: json['detailType'] as String? ?? '',
      id: json['id'] as String? ?? '',
      isPinned: json['isPinned'] as bool? ?? false,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'description': description,
      'detailType': detailType,
      'id': id,
      'isPinned': isPinned,
      'type': type,
  };
}

class CommonRecover {
  final int backupRecordID;
  final String detailName;
  final int downloadAccountID;
  final bool dropAllCollections;
  final String file;
  final String name;
  final String secret;
  final String taskID;
  final int timeout;
  final String type;

  const CommonRecover({
    this.backupRecordID = 0,
    this.detailName = '',
    this.downloadAccountID = 0,
    this.dropAllCollections = false,
    this.file = '',
    this.name = '',
    this.secret = '',
    this.taskID = '',
    this.timeout = 0,
    this.type = '',
  });

  factory CommonRecover.fromJson(Map<String, dynamic> json) {
    return CommonRecover(
      backupRecordID: (json['backupRecordID'] as num?)?.toInt() ?? 0,
      detailName: json['detailName'] as String? ?? '',
      downloadAccountID: (json['downloadAccountID'] as num?)?.toInt() ?? 0,
      dropAllCollections: json['dropAllCollections'] as bool? ?? false,
      file: json['file'] as String? ?? '',
      name: json['name'] as String? ?? '',
      secret: json['secret'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      timeout: (json['timeout'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'backupRecordID': backupRecordID,
      'detailName': detailName,
      'downloadAccountID': downloadAccountID,
      'dropAllCollections': dropAllCollections,
      'file': file,
      'name': name,
      'secret': secret,
      'taskID': taskID,
      'timeout': timeout,
      'type': type,
  };
}

class DataTree {
  final List<DataTree> children;
  final String id;
  final bool isCheck;
  final bool isDisable;
  final bool isLocal;
  final String key;
  final String label;
  final String name;
  final String path;
  final String relationItemID;
  final int size;

  const DataTree({
    this.children = const [],
    this.id = '',
    this.isCheck = false,
    this.isDisable = false,
    this.isLocal = false,
    this.key = '',
    this.label = '',
    this.name = '',
    this.path = '',
    this.relationItemID = '',
    this.size = 0,
  });

  factory DataTree.fromJson(Map<String, dynamic> json) {
    return DataTree(
      children: (json['children'] as List<dynamic>?)?.map((e) => DataTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      id: json['id'] as String? ?? '',
      isCheck: json['isCheck'] as bool? ?? false,
      isDisable: json['isDisable'] as bool? ?? false,
      isLocal: json['isLocal'] as bool? ?? false,
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      relationItemID: json['relationItemID'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'children': children.map((e) => e.toJson()).toList(),
      'id': id,
      'isCheck': isCheck,
      'isDisable': isDisable,
      'isLocal': isLocal,
      'key': key,
      'label': label,
      'name': name,
      'path': path,
      'relationItemID': relationItemID,
      'size': size,
  };
}

class DownloadRecord {
  final int downloadAccountID;
  final String fileDir;
  final String fileName;

  const DownloadRecord({
    this.downloadAccountID = 0,
    this.fileDir = '',
    this.fileName = '',
  });

  factory DownloadRecord.fromJson(Map<String, dynamic> json) {
    return DownloadRecord(
      downloadAccountID: (json['downloadAccountID'] as num?)?.toInt() ?? 0,
      fileDir: json['fileDir'] as String? ?? '',
      fileName: json['fileName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'downloadAccountID': downloadAccountID,
      'fileDir': fileDir,
      'fileName': fileName,
  };
}

class FileManageAIInfo {
  final String aiAccountId;
  final String aiStatus;

  const FileManageAIInfo({
    this.aiAccountId = '',
    this.aiStatus = '',
  });

  factory FileManageAIInfo.fromJson(Map<String, dynamic> json) {
    return FileManageAIInfo(
      aiAccountId: json['aiAccountId'] as String? ?? '',
      aiStatus: json['aiStatus'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'aiAccountId': aiAccountId,
      'aiStatus': aiStatus,
  };
}

class ForBuckets {
  final String accessKey;
  final String credential;
  final String type;
  final String vars;

  const ForBuckets({
    this.accessKey = '',
    this.credential = '',
    this.type = '',
    this.vars = '',
  });

  factory ForBuckets.fromJson(Map<String, dynamic> json) {
    return ForBuckets(
      accessKey: json['accessKey'] as String? ?? '',
      credential: json['credential'] as String? ?? '',
      type: json['type'] as String? ?? '',
      vars: json['vars'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'accessKey': accessKey,
      'credential': credential,
      'type': type,
      'vars': vars,
  };
}

class GroupCreate {
  final int id;
  final String name;
  final String type;

  const GroupCreate({
    this.id = 0,
    this.name = '',
    this.type = '',
  });

  factory GroupCreate.fromJson(Map<String, dynamic> json) {
    return GroupCreate(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'type': type,
  };
}

class GroupSearch {
  final String type;

  const GroupSearch({
    this.type = '',
  });

  factory GroupSearch.fromJson(Map<String, dynamic> json) {
    return GroupSearch(
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'type': type,
  };
}

class GroupUpdate {
  final int id;
  final bool isDefault;
  final String name;
  final String type;

  const GroupUpdate({
    this.id = 0,
    this.isDefault = false,
    this.name = '',
    this.type = '',
  });

  factory GroupUpdate.fromJson(Map<String, dynamic> json) {
    return GroupUpdate(
      id: (json['id'] as num?)?.toInt() ?? 0,
      isDefault: json['isDefault'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'isDefault': isDefault,
      'name': name,
      'type': type,
  };
}

class MemoUpdate {
  final String content;

  const MemoUpdate({
    this.content = '',
  });

  factory MemoUpdate.fromJson(Map<String, dynamic> json) {
    return MemoUpdate(
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
  };
}

class MfaCredential {
  final String code;
  final int interval;
  final String secret;

  const MfaCredential({
    this.code = '',
    this.interval = 0,
    this.secret = '',
  });

  factory MfaCredential.fromJson(Map<String, dynamic> json) {
    return MfaCredential(
      code: json['code'] as String? ?? '',
      interval: (json['interval'] as num?)?.toInt() ?? 0,
      secret: json['secret'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'code': code,
      'interval': interval,
      'secret': secret,
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

class OperateByName {
  final String name;

  const OperateByName({
    this.name = '',
  });

  factory OperateByName.fromJson(Map<String, dynamic> json) {
    return OperateByName(
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
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

class PageSnapshot {
  final String info;
  final String order;
  final String orderBy;
  final int page;
  final int pageSize;

  const PageSnapshot({
    this.info = '',
    this.order = '',
    this.orderBy = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory PageSnapshot.fromJson(Map<String, dynamic> json) {
    return PageSnapshot(
      info: json['info'] as String? ?? '',
      order: json['order'] as String? ?? '',
      orderBy: json['orderBy'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'info': info,
      'order': order,
      'orderBy': orderBy,
      'page': page,
      'pageSize': pageSize,
  };
}

class PortUpdate {
  final int serverPort;

  const PortUpdate({
    this.serverPort = 0,
  });

  factory PortUpdate.fromJson(Map<String, dynamic> json) {
    return PortUpdate(
      serverPort: (json['serverPort'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'serverPort': serverPort,
  };
}

class ProxyUpdate {
  final bool proxyDocker;
  final String proxyPasswd;
  final String proxyPasswdKeep;
  final String proxyPort;
  final String proxyType;
  final String proxyUrl;
  final String proxyUser;
  final bool withDockerRestart;

  const ProxyUpdate({
    this.proxyDocker = false,
    this.proxyPasswd = '',
    this.proxyPasswdKeep = '',
    this.proxyPort = '',
    this.proxyType = '',
    this.proxyUrl = '',
    this.proxyUser = '',
    this.withDockerRestart = false,
  });

  factory ProxyUpdate.fromJson(Map<String, dynamic> json) {
    return ProxyUpdate(
      proxyDocker: json['proxyDocker'] as bool? ?? false,
      proxyPasswd: json['proxyPasswd'] as String? ?? '',
      proxyPasswdKeep: json['proxyPasswdKeep'] as String? ?? '',
      proxyPort: json['proxyPort'] as String? ?? '',
      proxyType: json['proxyType'] as String? ?? '',
      proxyUrl: json['proxyUrl'] as String? ?? '',
      proxyUser: json['proxyUser'] as String? ?? '',
      withDockerRestart: json['withDockerRestart'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'proxyDocker': proxyDocker,
      'proxyPasswd': proxyPasswd,
      'proxyPasswdKeep': proxyPasswdKeep,
      'proxyPort': proxyPort,
      'proxyType': proxyType,
      'proxyUrl': proxyUrl,
      'proxyUser': proxyUser,
      'withDockerRestart': withDockerRestart,
  };
}

class RecordFileSize {
  final int id;
  final String name;
  final int size;

  const RecordFileSize({
    this.id = 0,
    this.name = '',
    this.size = 0,
  });

  factory RecordFileSize.fromJson(Map<String, dynamic> json) {
    return RecordFileSize(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'name': name,
      'size': size,
  };
}

class RecordSearch {
  final String detailName;
  final String name;
  final int page;
  final int pageSize;
  final String type;

  const RecordSearch({
    this.detailName = '',
    this.name = '',
    this.page = 0,
    this.pageSize = 0,
    this.type = '',
  });

  factory RecordSearch.fromJson(Map<String, dynamic> json) {
    return RecordSearch(
      detailName: json['detailName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'detailName': detailName,
      'name': name,
      'page': page,
      'pageSize': pageSize,
      'type': type,
  };
}

class RecordSearchByCronjob {
  final int cronjobID;
  final int page;
  final int pageSize;

  const RecordSearchByCronjob({
    this.cronjobID = 0,
    this.page = 0,
    this.pageSize = 0,
  });

  factory RecordSearchByCronjob.fromJson(Map<String, dynamic> json) {
    return RecordSearchByCronjob(
      cronjobID: (json['cronjobID'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'cronjobID': cronjobID,
      'page': page,
      'pageSize': pageSize,
  };
}

class ReleasesNotes {
  final String content;
  final String createdAt;
  final int fixCount;
  final int newCount;
  final int optimizationCount;
  final String version;

  const ReleasesNotes({
    this.content = '',
    this.createdAt = '',
    this.fixCount = 0,
    this.newCount = 0,
    this.optimizationCount = 0,
    this.version = '',
  });

  factory ReleasesNotes.fromJson(Map<String, dynamic> json) {
    return ReleasesNotes(
      content: json['content'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      fixCount: (json['fixCount'] as num?)?.toInt() ?? 0,
      newCount: (json['newCount'] as num?)?.toInt() ?? 0,
      optimizationCount: (json['optimizationCount'] as num?)?.toInt() ?? 0,
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'createdAt': createdAt,
      'fixCount': fixCount,
      'newCount': newCount,
      'optimizationCount': optimizationCount,
      'version': version,
  };
}

class SSHConnData {
  final String addr;
  final String authMode;
  final String localSSHConnShow;
  final String passPhrase;
  final String password;
  final int port;
  final String privateKey;
  final String user;

  const SSHConnData({
    this.addr = '',
    this.authMode = '',
    this.localSSHConnShow = '',
    this.passPhrase = '',
    this.password = '',
    this.port = 0,
    this.privateKey = '',
    this.user = '',
  });

  factory SSHConnData.fromJson(Map<String, dynamic> json) {
    return SSHConnData(
      addr: json['addr'] as String? ?? '',
      authMode: json['authMode'] as String? ?? '',
      localSSHConnShow: json['localSSHConnShow'] as String? ?? '',
      passPhrase: json['passPhrase'] as String? ?? '',
      password: json['password'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      privateKey: json['privateKey'] as String? ?? '',
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'addr': addr,
      'authMode': authMode,
      'localSSHConnShow': localSSHConnShow,
      'passPhrase': passPhrase,
      'password': password,
      'port': port,
      'privateKey': privateKey,
      'user': user,
  };
}

class SSHDefaultConn {
  final String defaultConn;
  final bool withReset;

  const SSHDefaultConn({
    this.defaultConn = '',
    this.withReset = false,
  });

  factory SSHDefaultConn.fromJson(Map<String, dynamic> json) {
    return SSHDefaultConn(
      defaultConn: json['defaultConn'] as String? ?? '',
      withReset: json['withReset'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'defaultConn': defaultConn,
      'withReset': withReset,
  };
}

class SSLInfo {
  final String cert;
  final String domain;
  final String key;
  final String rootPath;
  final int sslID;
  final String timeout;

  const SSLInfo({
    this.cert = '',
    this.domain = '',
    this.key = '',
    this.rootPath = '',
    this.sslID = 0,
    this.timeout = '',
  });

  factory SSLInfo.fromJson(Map<String, dynamic> json) {
    return SSLInfo(
      cert: json['cert'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      key: json['key'] as String? ?? '',
      rootPath: json['rootPath'] as String? ?? '',
      sslID: (json['sslID'] as num?)?.toInt() ?? 0,
      timeout: json['timeout'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'cert': cert,
      'domain': domain,
      'key': key,
      'rootPath': rootPath,
      'sslID': sslID,
      'timeout': timeout,
  };
}

class SSLUpdate {
  final String cert;
  final String domain;
  final String key;
  final String ssl;
  final int sslID;
  final String sslType;

  const SSLUpdate({
    this.cert = '',
    this.domain = '',
    this.key = '',
    this.ssl = '',
    this.sslID = 0,
    this.sslType = '',
  });

  factory SSLUpdate.fromJson(Map<String, dynamic> json) {
    return SSLUpdate(
      cert: json['cert'] as String? ?? '',
      domain: json['domain'] as String? ?? '',
      key: json['key'] as String? ?? '',
      ssl: json['ssl'] as String? ?? '',
      sslID: (json['sslID'] as num?)?.toInt() ?? 0,
      sslType: json['sslType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'cert': cert,
      'domain': domain,
      'key': key,
      'ssl': ssl,
      'sslID': sslID,
      'sslType': sslType,
  };
}

class SearchForSize {
  final int cronjobID;
  final String detailName;
  final String info;
  final String name;
  final String order;
  final String orderBy;
  final int page;
  final int pageSize;
  final String type;

  const SearchForSize({
    this.cronjobID = 0,
    this.detailName = '',
    this.info = '',
    this.name = '',
    this.order = '',
    this.orderBy = '',
    this.page = 0,
    this.pageSize = 0,
    this.type = '',
  });

  factory SearchForSize.fromJson(Map<String, dynamic> json) {
    return SearchForSize(
      cronjobID: (json['cronjobID'] as num?)?.toInt() ?? 0,
      detailName: json['detailName'] as String? ?? '',
      info: json['info'] as String? ?? '',
      name: json['name'] as String? ?? '',
      order: json['order'] as String? ?? '',
      orderBy: json['orderBy'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'cronjobID': cronjobID,
      'detailName': detailName,
      'info': info,
      'name': name,
      'order': order,
      'orderBy': orderBy,
      'page': page,
      'pageSize': pageSize,
      'type': type,
  };
}

class SearchPageWithType {
  final String info;
  final int page;
  final int pageSize;
  final String type;

  const SearchPageWithType({
    this.info = '',
    this.page = 0,
    this.pageSize = 0,
    this.type = '',
  });

  factory SearchPageWithType.fromJson(Map<String, dynamic> json) {
    return SearchPageWithType(
      info: json['info'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'info': info,
      'page': page,
      'pageSize': pageSize,
      'type': type,
  };
}

class SettingBaseInfo {
  final String bindAddress;
  final String complexityVerification;
  final String dashboardMemoVisible;
  final String dashboardSimpleNodeVisible;
  final String developerMode;
  final String docSource;
  final String edition;
  final String hideMenu;
  final String ipv6;
  final String language;
  final String menuAccordion;
  final String menuTabs;
  final String noAuthSetting;
  final String panelName;
  final String port;
  final String proxyType;
  final String scriptSync;
  final String securityEntrance;
  final String serverPort;
  final String systemVersion;
  final String theme;
  final String upgradeBackupCopies;

  const SettingBaseInfo({
    this.bindAddress = '',
    this.complexityVerification = '',
    this.dashboardMemoVisible = '',
    this.dashboardSimpleNodeVisible = '',
    this.developerMode = '',
    this.docSource = '',
    this.edition = '',
    this.hideMenu = '',
    this.ipv6 = '',
    this.language = '',
    this.menuAccordion = '',
    this.menuTabs = '',
    this.noAuthSetting = '',
    this.panelName = '',
    this.port = '',
    this.proxyType = '',
    this.scriptSync = '',
    this.securityEntrance = '',
    this.serverPort = '',
    this.systemVersion = '',
    this.theme = '',
    this.upgradeBackupCopies = '',
  });

  factory SettingBaseInfo.fromJson(Map<String, dynamic> json) {
    return SettingBaseInfo(
      bindAddress: json['bindAddress'] as String? ?? '',
      complexityVerification: json['complexityVerification'] as String? ?? '',
      dashboardMemoVisible: json['dashboardMemoVisible'] as String? ?? '',
      dashboardSimpleNodeVisible: json['dashboardSimpleNodeVisible'] as String? ?? '',
      developerMode: json['developerMode'] as String? ?? '',
      docSource: json['docSource'] as String? ?? '',
      edition: json['edition'] as String? ?? '',
      hideMenu: json['hideMenu'] as String? ?? '',
      ipv6: json['ipv6'] as String? ?? '',
      language: json['language'] as String? ?? '',
      menuAccordion: json['menuAccordion'] as String? ?? '',
      menuTabs: json['menuTabs'] as String? ?? '',
      noAuthSetting: json['noAuthSetting'] as String? ?? '',
      panelName: json['panelName'] as String? ?? '',
      port: json['port'] as String? ?? '',
      proxyType: json['proxyType'] as String? ?? '',
      scriptSync: json['scriptSync'] as String? ?? '',
      securityEntrance: json['securityEntrance'] as String? ?? '',
      serverPort: json['serverPort'] as String? ?? '',
      systemVersion: json['systemVersion'] as String? ?? '',
      theme: json['theme'] as String? ?? '',
      upgradeBackupCopies: json['upgradeBackupCopies'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'bindAddress': bindAddress,
      'complexityVerification': complexityVerification,
      'dashboardMemoVisible': dashboardMemoVisible,
      'dashboardSimpleNodeVisible': dashboardSimpleNodeVisible,
      'developerMode': developerMode,
      'docSource': docSource,
      'edition': edition,
      'hideMenu': hideMenu,
      'ipv6': ipv6,
      'language': language,
      'menuAccordion': menuAccordion,
      'menuTabs': menuTabs,
      'noAuthSetting': noAuthSetting,
      'panelName': panelName,
      'port': port,
      'proxyType': proxyType,
      'scriptSync': scriptSync,
      'securityEntrance': securityEntrance,
      'serverPort': serverPort,
      'systemVersion': systemVersion,
      'theme': theme,
      'upgradeBackupCopies': upgradeBackupCopies,
  };
}

class SettingInfo {
  final String appStoreLastModified;
  final String appStoreSyncStatus;
  final String appStoreVersion;
  final String defaultIO;
  final String defaultNetwork;
  final String dockerSockPath;
  final String fileRecycleBin;
  final String firewallPortWhiteList;
  final String lastCleanData;
  final String lastCleanSize;
  final String lastCleanTime;
  final String localSSHConnShow;
  final String localTime;
  final String monitorInterval;
  final String monitorStatus;
  final String monitorStoreDays;
  final String ntpSite;
  final String systemIP;
  final String systemVersion;
  final String timeZone;

  const SettingInfo({
    this.appStoreLastModified = '',
    this.appStoreSyncStatus = '',
    this.appStoreVersion = '',
    this.defaultIO = '',
    this.defaultNetwork = '',
    this.dockerSockPath = '',
    this.fileRecycleBin = '',
    this.firewallPortWhiteList = '',
    this.lastCleanData = '',
    this.lastCleanSize = '',
    this.lastCleanTime = '',
    this.localSSHConnShow = '',
    this.localTime = '',
    this.monitorInterval = '',
    this.monitorStatus = '',
    this.monitorStoreDays = '',
    this.ntpSite = '',
    this.systemIP = '',
    this.systemVersion = '',
    this.timeZone = '',
  });

  factory SettingInfo.fromJson(Map<String, dynamic> json) {
    return SettingInfo(
      appStoreLastModified: json['appStoreLastModified'] as String? ?? '',
      appStoreSyncStatus: json['appStoreSyncStatus'] as String? ?? '',
      appStoreVersion: json['appStoreVersion'] as String? ?? '',
      defaultIO: json['defaultIO'] as String? ?? '',
      defaultNetwork: json['defaultNetwork'] as String? ?? '',
      dockerSockPath: json['dockerSockPath'] as String? ?? '',
      fileRecycleBin: json['fileRecycleBin'] as String? ?? '',
      firewallPortWhiteList: json['firewallPortWhiteList'] as String? ?? '',
      lastCleanData: json['lastCleanData'] as String? ?? '',
      lastCleanSize: json['lastCleanSize'] as String? ?? '',
      lastCleanTime: json['lastCleanTime'] as String? ?? '',
      localSSHConnShow: json['localSSHConnShow'] as String? ?? '',
      localTime: json['localTime'] as String? ?? '',
      monitorInterval: json['monitorInterval'] as String? ?? '',
      monitorStatus: json['monitorStatus'] as String? ?? '',
      monitorStoreDays: json['monitorStoreDays'] as String? ?? '',
      ntpSite: json['ntpSite'] as String? ?? '',
      systemIP: json['systemIP'] as String? ?? '',
      systemVersion: json['systemVersion'] as String? ?? '',
      timeZone: json['timeZone'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'appStoreLastModified': appStoreLastModified,
      'appStoreSyncStatus': appStoreSyncStatus,
      'appStoreVersion': appStoreVersion,
      'defaultIO': defaultIO,
      'defaultNetwork': defaultNetwork,
      'dockerSockPath': dockerSockPath,
      'fileRecycleBin': fileRecycleBin,
      'firewallPortWhiteList': firewallPortWhiteList,
      'lastCleanData': lastCleanData,
      'lastCleanSize': lastCleanSize,
      'lastCleanTime': lastCleanTime,
      'localSSHConnShow': localSSHConnShow,
      'localTime': localTime,
      'monitorInterval': monitorInterval,
      'monitorStatus': monitorStatus,
      'monitorStoreDays': monitorStoreDays,
      'ntpSite': ntpSite,
      'systemIP': systemIP,
      'systemVersion': systemVersion,
      'timeZone': timeZone,
  };
}

class SettingUpdate {
  final String key;
  final String value;

  const SettingUpdate({
    this.key = '',
    this.value = '',
  });

  factory SettingUpdate.fromJson(Map<String, dynamic> json) {
    return SettingUpdate(
      key: json['key'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'key': key,
      'value': value,
  };
}

class SnapshotBatchDelete {
  final bool deleteWithFile;
  final List<int> ids;

  const SnapshotBatchDelete({
    this.deleteWithFile = false,
    this.ids = const [],
  });

  factory SnapshotBatchDelete.fromJson(Map<String, dynamic> json) {
    return SnapshotBatchDelete(
      deleteWithFile: json['deleteWithFile'] as bool? ?? false,
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'deleteWithFile': deleteWithFile,
      'ids': ids,
  };
}

class SnapshotCreate {
  final List<DataTree> appData;
  final List<DataTree> backupData;
  final String description;
  final int downloadAccountID;
  final int id;
  final List<String> ignoreFiles;
  final String interruptStep;
  final String name;
  final List<DataTree> panelData;
  final String secret;
  final String sourceAccountIDs;
  final String taskID;
  final int timeout;
  final bool withDockerConf;
  final bool withLoginLog;
  final bool withMonitorData;
  final bool withOperationLog;
  final bool withSystemLog;
  final bool withTaskLog;

  const SnapshotCreate({
    this.appData = const [],
    this.backupData = const [],
    this.description = '',
    this.downloadAccountID = 0,
    this.id = 0,
    this.ignoreFiles = const [],
    this.interruptStep = '',
    this.name = '',
    this.panelData = const [],
    this.secret = '',
    this.sourceAccountIDs = '',
    this.taskID = '',
    this.timeout = 0,
    this.withDockerConf = false,
    this.withLoginLog = false,
    this.withMonitorData = false,
    this.withOperationLog = false,
    this.withSystemLog = false,
    this.withTaskLog = false,
  });

  factory SnapshotCreate.fromJson(Map<String, dynamic> json) {
    return SnapshotCreate(
      appData: (json['appData'] as List<dynamic>?)?.map((e) => DataTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      backupData: (json['backupData'] as List<dynamic>?)?.map((e) => DataTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      description: json['description'] as String? ?? '',
      downloadAccountID: (json['downloadAccountID'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      ignoreFiles: (json['ignoreFiles'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      interruptStep: json['interruptStep'] as String? ?? '',
      name: json['name'] as String? ?? '',
      panelData: (json['panelData'] as List<dynamic>?)?.map((e) => DataTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      secret: json['secret'] as String? ?? '',
      sourceAccountIDs: json['sourceAccountIDs'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      timeout: (json['timeout'] as num?)?.toInt() ?? 0,
      withDockerConf: json['withDockerConf'] as bool? ?? false,
      withLoginLog: json['withLoginLog'] as bool? ?? false,
      withMonitorData: json['withMonitorData'] as bool? ?? false,
      withOperationLog: json['withOperationLog'] as bool? ?? false,
      withSystemLog: json['withSystemLog'] as bool? ?? false,
      withTaskLog: json['withTaskLog'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'appData': appData.map((e) => e.toJson()).toList(),
      'backupData': backupData.map((e) => e.toJson()).toList(),
      'description': description,
      'downloadAccountID': downloadAccountID,
      'id': id,
      'ignoreFiles': ignoreFiles,
      'interruptStep': interruptStep,
      'name': name,
      'panelData': panelData.map((e) => e.toJson()).toList(),
      'secret': secret,
      'sourceAccountIDs': sourceAccountIDs,
      'taskID': taskID,
      'timeout': timeout,
      'withDockerConf': withDockerConf,
      'withLoginLog': withLoginLog,
      'withMonitorData': withMonitorData,
      'withOperationLog': withOperationLog,
      'withSystemLog': withSystemLog,
      'withTaskLog': withTaskLog,
  };
}

class SnapshotData {
  final List<DataTree> appData;
  final List<DataTree> backupData;
  final List<String> ignoreFiles;
  final List<DataTree> panelData;
  final bool withDockerConf;
  final bool withLoginLog;
  final bool withMonitorData;
  final bool withOperationLog;
  final bool withSystemLog;
  final bool withTaskLog;

  const SnapshotData({
    this.appData = const [],
    this.backupData = const [],
    this.ignoreFiles = const [],
    this.panelData = const [],
    this.withDockerConf = false,
    this.withLoginLog = false,
    this.withMonitorData = false,
    this.withOperationLog = false,
    this.withSystemLog = false,
    this.withTaskLog = false,
  });

  factory SnapshotData.fromJson(Map<String, dynamic> json) {
    return SnapshotData(
      appData: (json['appData'] as List<dynamic>?)?.map((e) => DataTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      backupData: (json['backupData'] as List<dynamic>?)?.map((e) => DataTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      ignoreFiles: (json['ignoreFiles'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      panelData: (json['panelData'] as List<dynamic>?)?.map((e) => DataTree.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      withDockerConf: json['withDockerConf'] as bool? ?? false,
      withLoginLog: json['withLoginLog'] as bool? ?? false,
      withMonitorData: json['withMonitorData'] as bool? ?? false,
      withOperationLog: json['withOperationLog'] as bool? ?? false,
      withSystemLog: json['withSystemLog'] as bool? ?? false,
      withTaskLog: json['withTaskLog'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'appData': appData.map((e) => e.toJson()).toList(),
      'backupData': backupData.map((e) => e.toJson()).toList(),
      'ignoreFiles': ignoreFiles,
      'panelData': panelData.map((e) => e.toJson()).toList(),
      'withDockerConf': withDockerConf,
      'withLoginLog': withLoginLog,
      'withMonitorData': withMonitorData,
      'withOperationLog': withOperationLog,
      'withSystemLog': withSystemLog,
      'withTaskLog': withTaskLog,
  };
}

class SnapshotImport {
  final int backupAccountID;
  final String description;
  final List<String> names;

  const SnapshotImport({
    this.backupAccountID = 0,
    this.description = '',
    this.names = const [],
  });

  factory SnapshotImport.fromJson(Map<String, dynamic> json) {
    return SnapshotImport(
      backupAccountID: (json['backupAccountID'] as num?)?.toInt() ?? 0,
      description: json['description'] as String? ?? '',
      names: (json['names'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'backupAccountID': backupAccountID,
      'description': description,
      'names': names,
  };
}

class SnapshotRecover {
  final int id;
  final bool isNew;
  final bool reDownload;
  final String secret;
  final String taskID;

  const SnapshotRecover({
    this.id = 0,
    this.isNew = false,
    this.reDownload = false,
    this.secret = '',
    this.taskID = '',
  });

  factory SnapshotRecover.fromJson(Map<String, dynamic> json) {
    return SnapshotRecover(
      id: (json['id'] as num?)?.toInt() ?? 0,
      isNew: json['isNew'] as bool? ?? false,
      reDownload: json['reDownload'] as bool? ?? false,
      secret: json['secret'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'isNew': isNew,
      'reDownload': reDownload,
      'secret': secret,
      'taskID': taskID,
  };
}

class TerminalAIInfo {
  final String aiAccountId;
  final String aiPrefix;
  final String aiRiskCommands;
  final String aiRiskCommandsDefault;
  final String aiStatus;

  const TerminalAIInfo({
    this.aiAccountId = '',
    this.aiPrefix = '',
    this.aiRiskCommands = '',
    this.aiRiskCommandsDefault = '',
    this.aiStatus = '',
  });

  factory TerminalAIInfo.fromJson(Map<String, dynamic> json) {
    return TerminalAIInfo(
      aiAccountId: json['aiAccountId'] as String? ?? '',
      aiPrefix: json['aiPrefix'] as String? ?? '',
      aiRiskCommands: json['aiRiskCommands'] as String? ?? '',
      aiRiskCommandsDefault: json['aiRiskCommandsDefault'] as String? ?? '',
      aiStatus: json['aiStatus'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'aiAccountId': aiAccountId,
      'aiPrefix': aiPrefix,
      'aiRiskCommands': aiRiskCommands,
      'aiRiskCommandsDefault': aiRiskCommandsDefault,
      'aiStatus': aiStatus,
  };
}

class TerminalInfo {
  final String backgroundColor;
  final String cursorBlink;
  final String cursorStyle;
  final String fontFamily;
  final String fontSize;
  final String foregroundColor;
  final String letterSpacing;
  final String lineHeight;
  final String scrollSensitivity;
  final String scrollback;
  final String showTerminalButton;

  const TerminalInfo({
    this.backgroundColor = '',
    this.cursorBlink = '',
    this.cursorStyle = '',
    this.fontFamily = '',
    this.fontSize = '',
    this.foregroundColor = '',
    this.letterSpacing = '',
    this.lineHeight = '',
    this.scrollSensitivity = '',
    this.scrollback = '',
    this.showTerminalButton = '',
  });

  factory TerminalInfo.fromJson(Map<String, dynamic> json) {
    return TerminalInfo(
      backgroundColor: json['backgroundColor'] as String? ?? '',
      cursorBlink: json['cursorBlink'] as String? ?? '',
      cursorStyle: json['cursorStyle'] as String? ?? '',
      fontFamily: json['fontFamily'] as String? ?? '',
      fontSize: json['fontSize'] as String? ?? '',
      foregroundColor: json['foregroundColor'] as String? ?? '',
      letterSpacing: json['letterSpacing'] as String? ?? '',
      lineHeight: json['lineHeight'] as String? ?? '',
      scrollSensitivity: json['scrollSensitivity'] as String? ?? '',
      scrollback: json['scrollback'] as String? ?? '',
      showTerminalButton: json['showTerminalButton'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'backgroundColor': backgroundColor,
      'cursorBlink': cursorBlink,
      'cursorStyle': cursorStyle,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'foregroundColor': foregroundColor,
      'letterSpacing': letterSpacing,
      'lineHeight': lineHeight,
      'scrollSensitivity': scrollSensitivity,
      'scrollback': scrollback,
      'showTerminalButton': showTerminalButton,
  };
}

class TerminalUpdate {
  final String backgroundColor;
  final String cursorBlink;
  final String cursorStyle;
  final String fontFamily;
  final String fontSize;
  final String foregroundColor;
  final String letterSpacing;
  final String lineHeight;
  final String scrollSensitivity;
  final String scrollback;
  final String showTerminalButton;

  const TerminalUpdate({
    this.backgroundColor = '',
    this.cursorBlink = '',
    this.cursorStyle = '',
    this.fontFamily = '',
    this.fontSize = '',
    this.foregroundColor = '',
    this.letterSpacing = '',
    this.lineHeight = '',
    this.scrollSensitivity = '',
    this.scrollback = '',
    this.showTerminalButton = '',
  });

  factory TerminalUpdate.fromJson(Map<String, dynamic> json) {
    return TerminalUpdate(
      backgroundColor: json['backgroundColor'] as String? ?? '',
      cursorBlink: json['cursorBlink'] as String? ?? '',
      cursorStyle: json['cursorStyle'] as String? ?? '',
      fontFamily: json['fontFamily'] as String? ?? '',
      fontSize: json['fontSize'] as String? ?? '',
      foregroundColor: json['foregroundColor'] as String? ?? '',
      letterSpacing: json['letterSpacing'] as String? ?? '',
      lineHeight: json['lineHeight'] as String? ?? '',
      scrollSensitivity: json['scrollSensitivity'] as String? ?? '',
      scrollback: json['scrollback'] as String? ?? '',
      showTerminalButton: json['showTerminalButton'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'backgroundColor': backgroundColor,
      'cursorBlink': cursorBlink,
      'cursorStyle': cursorStyle,
      'fontFamily': fontFamily,
      'fontSize': fontSize,
      'foregroundColor': foregroundColor,
      'letterSpacing': letterSpacing,
      'lineHeight': lineHeight,
      'scrollSensitivity': scrollSensitivity,
      'scrollback': scrollback,
      'showTerminalButton': showTerminalButton,
  };
}

class UpdateDescription {
  final String description;
  final int id;

  const UpdateDescription({
    this.description = '',
    this.id = 0,
  });

  factory UpdateDescription.fromJson(Map<String, dynamic> json) {
    return UpdateDescription(
      description: json['description'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'description': description,
      'id': id,
  };
}

class Upgrade {
  final String version;

  const Upgrade({
    this.version = '',
  });

  factory Upgrade.fromJson(Map<String, dynamic> json) {
    return Upgrade(
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'version': version,
  };
}

class UpgradeInfo {
  final String latestVersion;
  final String newVersion;
  final String releaseNote;
  final String testVersion;

  const UpgradeInfo({
    this.latestVersion = '',
    this.newVersion = '',
    this.releaseNote = '',
    this.testVersion = '',
  });

  factory UpgradeInfo.fromJson(Map<String, dynamic> json) {
    return UpgradeInfo(
      latestVersion: json['latestVersion'] as String? ?? '',
      newVersion: json['newVersion'] as String? ?? '',
      releaseNote: json['releaseNote'] as String? ?? '',
      testVersion: json['testVersion'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'latestVersion': latestVersion,
      'newVersion': newVersion,
      'releaseNote': releaseNote,
      'testVersion': testVersion,
  };
}

class UploadForRecover {
  final String filePath;
  final String targetDir;

  const UploadForRecover({
    this.filePath = '',
    this.targetDir = '',
  });

  factory UploadForRecover.fromJson(Map<String, dynamic> json) {
    return UploadForRecover(
      filePath: json['filePath'] as String? ?? '',
      targetDir: json['targetDir'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'filePath': filePath,
      'targetDir': targetDir,
  };
}

class MfaOtp {
  final String qrImage;
  final String secret;

  const MfaOtp({
    this.qrImage = '',
    this.secret = '',
  });

  factory MfaOtp.fromJson(Map<String, dynamic> json) {
    return MfaOtp(
      qrImage: json['qrImage'] as String? ?? '',
      secret: json['secret'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'qrImage': qrImage,
      'secret': secret,
  };
}

class FileHistorySettingUpdate {
  final int diskQuotaMB;
  final String enable;
  final int maxPerPath;

  const FileHistorySettingUpdate({
    this.diskQuotaMB = 0,
    this.enable = '',
    this.maxPerPath = 0,
  });

  factory FileHistorySettingUpdate.fromJson(Map<String, dynamic> json) {
    return FileHistorySettingUpdate(
      diskQuotaMB: (json['diskQuotaMB'] as num?)?.toInt() ?? 0,
      enable: json['enable'] as String? ?? '',
      maxPerPath: (json['maxPerPath'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'diskQuotaMB': diskQuotaMB,
      'enable': enable,
      'maxPerPath': maxPerPath,
  };
}

class FileHistorySettingInfo {
  final int diskQuotaMB;
  final String enable;
  final int maxPerPath;

  const FileHistorySettingInfo({
    this.diskQuotaMB = 0,
    this.enable = '',
    this.maxPerPath = 0,
  });

  factory FileHistorySettingInfo.fromJson(Map<String, dynamic> json) {
    return FileHistorySettingInfo(
      diskQuotaMB: (json['diskQuotaMB'] as num?)?.toInt() ?? 0,
      enable: json['enable'] as String? ?? '',
      maxPerPath: (json['maxPerPath'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'diskQuotaMB': diskQuotaMB,
      'enable': enable,
      'maxPerPath': maxPerPath,
  };
}
