// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

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

class ClamBaseInfo {
  final bool freshIsActive;
  final bool freshIsExist;
  final String freshVersion;
  final bool isActive;
  final bool isExist;
  final String version;

  const ClamBaseInfo({
    this.freshIsActive = false,
    this.freshIsExist = false,
    this.freshVersion = '',
    this.isActive = false,
    this.isExist = false,
    this.version = '',
  });

  factory ClamBaseInfo.fromJson(Map<String, dynamic> json) {
    return ClamBaseInfo(
      freshIsActive: json['freshIsActive'] as bool? ?? false,
      freshIsExist: json['freshIsExist'] as bool? ?? false,
      freshVersion: json['freshVersion'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      isExist: json['isExist'] as bool? ?? false,
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'freshIsActive': freshIsActive,
      'freshIsExist': freshIsExist,
      'freshVersion': freshVersion,
      'isActive': isActive,
      'isExist': isExist,
      'version': version,
  };
}

class ClamCreate {
  final int alertCount;
  final String alertMethod;
  final String alertTitle;
  final String description;
  final String infectedDir;
  final String infectedStrategy;
  final String name;
  final String path;
  final String spec;
  final String status;
  final int timeout;

  const ClamCreate({
    this.alertCount = 0,
    this.alertMethod = '',
    this.alertTitle = '',
    this.description = '',
    this.infectedDir = '',
    this.infectedStrategy = '',
    this.name = '',
    this.path = '',
    this.spec = '',
    this.status = '',
    this.timeout = 0,
  });

  factory ClamCreate.fromJson(Map<String, dynamic> json) {
    return ClamCreate(
      alertCount: (json['alertCount'] as num?)?.toInt() ?? 0,
      alertMethod: json['alertMethod'] as String? ?? '',
      alertTitle: json['alertTitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      infectedDir: json['infectedDir'] as String? ?? '',
      infectedStrategy: json['infectedStrategy'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      spec: json['spec'] as String? ?? '',
      status: json['status'] as String? ?? '',
      timeout: (json['timeout'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'alertCount': alertCount,
      'alertMethod': alertMethod,
      'alertTitle': alertTitle,
      'description': description,
      'infectedDir': infectedDir,
      'infectedStrategy': infectedStrategy,
      'name': name,
      'path': path,
      'spec': spec,
      'status': status,
      'timeout': timeout,
  };
}

class ClamDelete {
  final List<int> ids;
  final bool removeInfected;

  const ClamDelete({
    this.ids = const [],
    this.removeInfected = false,
  });

  factory ClamDelete.fromJson(Map<String, dynamic> json) {
    return ClamDelete(
      ids: (json['ids'] as List<dynamic>?)?.map((e) => e as int).toList() ?? const [],
      removeInfected: json['removeInfected'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'ids': ids,
      'removeInfected': removeInfected,
  };
}

class ClamFileReq {
  final String name;
  final String tail;

  const ClamFileReq({
    this.name = '',
    this.tail = '',
  });

  factory ClamFileReq.fromJson(Map<String, dynamic> json) {
    return ClamFileReq(
      name: json['name'] as String? ?? '',
      tail: json['tail'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'tail': tail,
  };
}

class ClamLogSearch {
  final int clamID;
  final String endTime;
  final int page;
  final int pageSize;
  final String startTime;
  final String status;

  const ClamLogSearch({
    this.clamID = 0,
    this.endTime = '',
    this.page = 0,
    this.pageSize = 0,
    this.startTime = '',
    this.status = '',
  });

  factory ClamLogSearch.fromJson(Map<String, dynamic> json) {
    return ClamLogSearch(
      clamID: (json['clamID'] as num?)?.toInt() ?? 0,
      endTime: json['endTime'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      startTime: json['startTime'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'clamID': clamID,
      'endTime': endTime,
      'page': page,
      'pageSize': pageSize,
      'startTime': startTime,
      'status': status,
  };
}

class ClamUpdate {
  final int alertCount;
  final String alertMethod;
  final String alertTitle;
  final String description;
  final int id;
  final String infectedDir;
  final String infectedStrategy;
  final String name;
  final String path;
  final String spec;
  final int timeout;

  const ClamUpdate({
    this.alertCount = 0,
    this.alertMethod = '',
    this.alertTitle = '',
    this.description = '',
    this.id = 0,
    this.infectedDir = '',
    this.infectedStrategy = '',
    this.name = '',
    this.path = '',
    this.spec = '',
    this.timeout = 0,
  });

  factory ClamUpdate.fromJson(Map<String, dynamic> json) {
    return ClamUpdate(
      alertCount: (json['alertCount'] as num?)?.toInt() ?? 0,
      alertMethod: json['alertMethod'] as String? ?? '',
      alertTitle: json['alertTitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      infectedDir: json['infectedDir'] as String? ?? '',
      infectedStrategy: json['infectedStrategy'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      spec: json['spec'] as String? ?? '',
      timeout: (json['timeout'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'alertCount': alertCount,
      'alertMethod': alertMethod,
      'alertTitle': alertTitle,
      'description': description,
      'id': id,
      'infectedDir': infectedDir,
      'infectedStrategy': infectedStrategy,
      'name': name,
      'path': path,
      'spec': spec,
      'timeout': timeout,
  };
}

class ClamUpdateStatus {
  final int id;
  final String status;

  const ClamUpdateStatus({
    this.id = 0,
    this.status = '',
  });

  factory ClamUpdateStatus.fromJson(Map<String, dynamic> json) {
    return ClamUpdateStatus(
      id: (json['id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'status': status,
  };
}

class Fail2BanBaseInfo {
  final String banAction;
  final String banTime;
  final String findTime;
  final bool isActive;
  final bool isEnable;
  final bool isExist;
  final String logPath;
  final int maxRetry;
  final int port;
  final String version;

  const Fail2BanBaseInfo({
    this.banAction = '',
    this.banTime = '',
    this.findTime = '',
    this.isActive = false,
    this.isEnable = false,
    this.isExist = false,
    this.logPath = '',
    this.maxRetry = 0,
    this.port = 0,
    this.version = '',
  });

  factory Fail2BanBaseInfo.fromJson(Map<String, dynamic> json) {
    return Fail2BanBaseInfo(
      banAction: json['banAction'] as String? ?? '',
      banTime: json['banTime'] as String? ?? '',
      findTime: json['findTime'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? false,
      isEnable: json['isEnable'] as bool? ?? false,
      isExist: json['isExist'] as bool? ?? false,
      logPath: json['logPath'] as String? ?? '',
      maxRetry: (json['maxRetry'] as num?)?.toInt() ?? 0,
      port: (json['port'] as num?)?.toInt() ?? 0,
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'banAction': banAction,
      'banTime': banTime,
      'findTime': findTime,
      'isActive': isActive,
      'isEnable': isEnable,
      'isExist': isExist,
      'logPath': logPath,
      'maxRetry': maxRetry,
      'port': port,
      'version': version,
  };
}

class Fail2BanSearch {
  final String status;

  const Fail2BanSearch({
    this.status = '',
  });

  factory Fail2BanSearch.fromJson(Map<String, dynamic> json) {
    return Fail2BanSearch(
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'status': status,
  };
}

class Fail2BanSet {
  final List<String> ips;
  final String operate;

  const Fail2BanSet({
    this.ips = const [],
    this.operate = '',
  });

  factory Fail2BanSet.fromJson(Map<String, dynamic> json) {
    return Fail2BanSet(
      ips: (json['ips'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      operate: json['operate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'ips': ips,
      'operate': operate,
  };
}

class Fail2BanUpdate {
  final String key;
  final String value;

  const Fail2BanUpdate({
    this.key = '',
    this.value = '',
  });

  factory Fail2BanUpdate.fromJson(Map<String, dynamic> json) {
    return Fail2BanUpdate(
      key: json['key'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'key': key,
      'value': value,
  };
}

class FtpBaseInfo {
  final bool isActive;
  final bool isExist;

  const FtpBaseInfo({
    this.isActive = false,
    this.isExist = false,
  });

  factory FtpBaseInfo.fromJson(Map<String, dynamic> json) {
    return FtpBaseInfo(
      isActive: json['isActive'] as bool? ?? false,
      isExist: json['isExist'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'isActive': isActive,
      'isExist': isExist,
  };
}

class FtpCreate {
  final String description;
  final String password;
  final String path;
  final String user;

  const FtpCreate({
    this.description = '',
    this.password = '',
    this.path = '',
    this.user = '',
  });

  factory FtpCreate.fromJson(Map<String, dynamic> json) {
    return FtpCreate(
      description: json['description'] as String? ?? '',
      password: json['password'] as String? ?? '',
      path: json['path'] as String? ?? '',
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'description': description,
      'password': password,
      'path': path,
      'user': user,
  };
}

class FtpLogSearch {
  final String operation;
  final int page;
  final int pageSize;
  final String user;

  const FtpLogSearch({
    this.operation = '',
    this.page = 0,
    this.pageSize = 0,
    this.user = '',
  });

  factory FtpLogSearch.fromJson(Map<String, dynamic> json) {
    return FtpLogSearch(
      operation: json['operation'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'operation': operation,
      'page': page,
      'pageSize': pageSize,
      'user': user,
  };
}

class FtpUpdate {
  final String description;
  final int id;
  final String password;
  final String path;
  final String status;

  const FtpUpdate({
    this.description = '',
    this.id = 0,
    this.password = '',
    this.path = '',
    this.status = '',
  });

  factory FtpUpdate.fromJson(Map<String, dynamic> json) {
    return FtpUpdate(
      description: json['description'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      password: json['password'] as String? ?? '',
      path: json['path'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'description': description,
      'id': id,
      'password': password,
      'path': path,
      'status': status,
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

class Operate {
  final String operation;

  const Operate({
    this.operation = '',
  });

  factory Operate.fromJson(Map<String, dynamic> json) {
    return Operate(
      operation: json['operation'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'operation': operation,
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

class RuntimeDiagnosticsSummary {
  final int goroutines;
  final int heapAlloc;
  final int heapObjects;
  final int rss;

  const RuntimeDiagnosticsSummary({
    this.goroutines = 0,
    this.heapAlloc = 0,
    this.heapObjects = 0,
    this.rss = 0,
  });

  factory RuntimeDiagnosticsSummary.fromJson(Map<String, dynamic> json) {
    return RuntimeDiagnosticsSummary(
      goroutines: (json['goroutines'] as num?)?.toInt() ?? 0,
      heapAlloc: (json['heapAlloc'] as num?)?.toInt() ?? 0,
      heapObjects: (json['heapObjects'] as num?)?.toInt() ?? 0,
      rss: (json['rss'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'goroutines': goroutines,
      'heapAlloc': heapAlloc,
      'heapObjects': heapObjects,
      'rss': rss,
  };
}

class RuntimeGoroutineGroup {
  final int count;
  final List<String> stack;
  final String state;
  final String top;

  const RuntimeGoroutineGroup({
    this.count = 0,
    this.stack = const [],
    this.state = '',
    this.top = '',
  });

  factory RuntimeGoroutineGroup.fromJson(Map<String, dynamic> json) {
    return RuntimeGoroutineGroup(
      count: (json['count'] as num?)?.toInt() ?? 0,
      stack: (json['stack'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      state: json['state'] as String? ?? '',
      top: json['top'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'count': count,
      'stack': stack,
      'state': state,
      'top': top,
  };
}

class RuntimeGoroutineSnapshot {
  final String capturedAt;
  final List<RuntimeGoroutineGroup> goroutines;
  final int groupCount;
  final int total;
  final bool truncated;

  const RuntimeGoroutineSnapshot({
    this.capturedAt = '',
    this.goroutines = const [],
    this.groupCount = 0,
    this.total = 0,
    this.truncated = false,
  });

  factory RuntimeGoroutineSnapshot.fromJson(Map<String, dynamic> json) {
    return RuntimeGoroutineSnapshot(
      capturedAt: json['capturedAt'] as String? ?? '',
      goroutines: (json['goroutines'] as List<dynamic>?)?.map((e) => RuntimeGoroutineGroup.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      groupCount: (json['groupCount'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      truncated: json['truncated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
      'capturedAt': capturedAt,
      'goroutines': goroutines.map((e) => e.toJson()).toList(),
      'groupCount': groupCount,
      'total': total,
      'truncated': truncated,
  };
}

class RuntimeProfileCreate {
  final int duration;
  final String type;

  const RuntimeProfileCreate({
    this.duration = 0,
    this.type = '',
  });

  factory RuntimeProfileCreate.fromJson(Map<String, dynamic> json) {
    return RuntimeProfileCreate(
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'duration': duration,
      'type': type,
  };
}

class SearchClamWithPage {
  final String info;
  final String order;
  final String orderBy;
  final int page;
  final int pageSize;

  const SearchClamWithPage({
    this.info = '',
    this.order = '',
    this.orderBy = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory SearchClamWithPage.fromJson(Map<String, dynamic> json) {
    return SearchClamWithPage(
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

class UpdateByFile {
  final String file;

  const UpdateByFile({
    this.file = '',
  });

  factory UpdateByFile.fromJson(Map<String, dynamic> json) {
    return UpdateByFile(
      file: json['file'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'file': file,
  };
}

class UpdateByNameAndFile {
  final String file;
  final String name;

  const UpdateByNameAndFile({
    this.file = '',
    this.name = '',
  });

  factory UpdateByNameAndFile.fromJson(Map<String, dynamic> json) {
    return UpdateByNameAndFile(
      file: json['file'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'file': file,
      'name': name,
  };
}

class FilesFileinfo {
  final String content;
  final String extension;
  final int favoriteID;
  final String gid;
  final String group;
  final bool isAppendOnly;
  final bool isDetail;
  final bool isDir;
  final bool isHidden;
  final bool isImmutable;
  final bool isSymlink;
  final int itemTotal;
  final List<FilesFileinfo> items;
  final String linkPath;
  final String mimeType;
  final String modTime;
  final String mode;
  final String name;
  final String path;
  final String shareCode;
  final int size;
  final String type;
  final String uid;
  final String updateTime;
  final String user;

  const FilesFileinfo({
    this.content = '',
    this.extension = '',
    this.favoriteID = 0,
    this.gid = '',
    this.group = '',
    this.isAppendOnly = false,
    this.isDetail = false,
    this.isDir = false,
    this.isHidden = false,
    this.isImmutable = false,
    this.isSymlink = false,
    this.itemTotal = 0,
    this.items = const [],
    this.linkPath = '',
    this.mimeType = '',
    this.modTime = '',
    this.mode = '',
    this.name = '',
    this.path = '',
    this.shareCode = '',
    this.size = 0,
    this.type = '',
    this.uid = '',
    this.updateTime = '',
    this.user = '',
  });

  factory FilesFileinfo.fromJson(Map<String, dynamic> json) {
    return FilesFileinfo(
      content: json['content'] as String? ?? '',
      extension: json['extension'] as String? ?? '',
      favoriteID: (json['favoriteID'] as num?)?.toInt() ?? 0,
      gid: json['gid'] as String? ?? '',
      group: json['group'] as String? ?? '',
      isAppendOnly: json['isAppendOnly'] as bool? ?? false,
      isDetail: json['isDetail'] as bool? ?? false,
      isDir: json['isDir'] as bool? ?? false,
      isHidden: json['isHidden'] as bool? ?? false,
      isImmutable: json['isImmutable'] as bool? ?? false,
      isSymlink: json['isSymlink'] as bool? ?? false,
      itemTotal: (json['itemTotal'] as num?)?.toInt() ?? 0,
      items: (json['items'] as List<dynamic>?)?.map((e) => FilesFileinfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      linkPath: json['linkPath'] as String? ?? '',
      mimeType: json['mimeType'] as String? ?? '',
      modTime: json['modTime'] as String? ?? '',
      mode: json['mode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      shareCode: json['shareCode'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      updateTime: json['updateTime'] as String? ?? '',
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'extension': extension,
      'favoriteID': favoriteID,
      'gid': gid,
      'group': group,
      'isAppendOnly': isAppendOnly,
      'isDetail': isDetail,
      'isDir': isDir,
      'isHidden': isHidden,
      'isImmutable': isImmutable,
      'isSymlink': isSymlink,
      'itemTotal': itemTotal,
      'items': items.map((e) => e.toJson()).toList(),
      'linkPath': linkPath,
      'mimeType': mimeType,
      'modTime': modTime,
      'mode': mode,
      'name': name,
      'path': path,
      'shareCode': shareCode,
      'size': size,
      'type': type,
      'uid': uid,
      'updateTime': updateTime,
      'user': user,
  };
}

class Runtime {
  final int appDetailID;
  final String codeDir;
  final String containerName;
  final String createdAt;
  final String dockerCompose;
  final String env;
  final int id;
  final String image;
  final String message;
  final String name;
  final String params;
  final String port;
  final String remark;
  final String resource;
  final String status;
  final String type;
  final String updatedAt;
  final String version;
  final String workDir;

  const Runtime({
    this.appDetailID = 0,
    this.codeDir = '',
    this.containerName = '',
    this.createdAt = '',
    this.dockerCompose = '',
    this.env = '',
    this.id = 0,
    this.image = '',
    this.message = '',
    this.name = '',
    this.params = '',
    this.port = '',
    this.remark = '',
    this.resource = '',
    this.status = '',
    this.type = '',
    this.updatedAt = '',
    this.version = '',
    this.workDir = '',
  });

  factory Runtime.fromJson(Map<String, dynamic> json) {
    return Runtime(
      appDetailID: (json['appDetailID'] as num?)?.toInt() ?? 0,
      codeDir: json['codeDir'] as String? ?? '',
      containerName: json['containerName'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      dockerCompose: json['dockerCompose'] as String? ?? '',
      env: json['env'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      image: json['image'] as String? ?? '',
      message: json['message'] as String? ?? '',
      name: json['name'] as String? ?? '',
      params: json['params'] as String? ?? '',
      port: json['port'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      resource: json['resource'] as String? ?? '',
      status: json['status'] as String? ?? '',
      type: json['type'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      version: json['version'] as String? ?? '',
      workDir: json['workDir'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'appDetailID': appDetailID,
      'codeDir': codeDir,
      'containerName': containerName,
      'createdAt': createdAt,
      'dockerCompose': dockerCompose,
      'env': env,
      'id': id,
      'image': image,
      'message': message,
      'name': name,
      'params': params,
      'port': port,
      'remark': remark,
      'resource': resource,
      'status': status,
      'type': type,
      'updatedAt': updatedAt,
      'version': version,
      'workDir': workDir,
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

class ExtraHost {
  final String hostname;
  final String ip;

  const ExtraHost({
    this.hostname = '',
    this.ip = '',
  });

  factory ExtraHost.fromJson(Map<String, dynamic> json) {
    return ExtraHost(
      hostname: json['hostname'] as String? ?? '',
      ip: json['ip'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'hostname': hostname,
      'ip': ip,
  };
}

class FPMConfig {
  final int id;
  final Map<String, dynamic> params;

  const FPMConfig({
    this.id = 0,
    this.params = const {},
  });

  factory FPMConfig.fromJson(Map<String, dynamic> json) {
    return FPMConfig(
      id: (json['id'] as num?)?.toInt() ?? 0,
      params: json['params'] as Map<String, dynamic>? ?? const {},
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'params': params,
  };
}

class NodeModuleReq {
  final int iD;

  const NodeModuleReq({
    this.iD = 0,
  });

  factory NodeModuleReq.fromJson(Map<String, dynamic> json) {
    return NodeModuleReq(
      iD: (json['ID'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'ID': iD,
  };
}

class NodePackageReq {
  final String codeDir;

  const NodePackageReq({
    this.codeDir = '',
  });

  factory NodePackageReq.fromJson(Map<String, dynamic> json) {
    return NodePackageReq(
      codeDir: json['codeDir'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'codeDir': codeDir,
  };
}

class PHPConfigUpdate {
  final List<String> disableFunctions;
  final int id;
  final String maxExecutionTime;
  final Map<String, dynamic> params;
  final String scope;
  final String uploadMaxSize;

  const PHPConfigUpdate({
    this.disableFunctions = const [],
    this.id = 0,
    this.maxExecutionTime = '',
    this.params = const {},
    this.scope = '',
    this.uploadMaxSize = '',
  });

  factory PHPConfigUpdate.fromJson(Map<String, dynamic> json) {
    return PHPConfigUpdate(
      disableFunctions: (json['disableFunctions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
      maxExecutionTime: json['maxExecutionTime'] as String? ?? '',
      params: json['params'] as Map<String, dynamic>? ?? const {},
      scope: json['scope'] as String? ?? '',
      uploadMaxSize: json['uploadMaxSize'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'disableFunctions': disableFunctions,
      'id': id,
      'maxExecutionTime': maxExecutionTime,
      'params': params,
      'scope': scope,
      'uploadMaxSize': uploadMaxSize,
  };
}

class PHPContainerConfig {
  final String containerName;
  final List<Environment> environments;
  final List<ExposedPort> exposedPorts;
  final List<ExtraHost> extraHosts;
  final int id;
  final List<Volume> volumes;

  const PHPContainerConfig({
    this.containerName = '',
    this.environments = const [],
    this.exposedPorts = const [],
    this.extraHosts = const [],
    this.id = 0,
    this.volumes = const [],
  });

  factory PHPContainerConfig.fromJson(Map<String, dynamic> json) {
    return PHPContainerConfig(
      containerName: json['containerName'] as String? ?? '',
      environments: (json['environments'] as List<dynamic>?)?.map((e) => Environment.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      exposedPorts: (json['exposedPorts'] as List<dynamic>?)?.map((e) => ExposedPort.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      extraHosts: (json['extraHosts'] as List<dynamic>?)?.map((e) => ExtraHost.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
      volumes: (json['volumes'] as List<dynamic>?)?.map((e) => Volume.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'containerName': containerName,
      'environments': environments.map((e) => e.toJson()).toList(),
      'exposedPorts': exposedPorts.map((e) => e.toJson()).toList(),
      'extraHosts': extraHosts.map((e) => e.toJson()).toList(),
      'id': id,
      'volumes': volumes.map((e) => e.toJson()).toList(),
  };
}

class PHPExtensionInstallReq {
  final int iD;
  final String name;
  final String taskID;

  const PHPExtensionInstallReq({
    this.iD = 0,
    this.name = '',
    this.taskID = '',
  });

  factory PHPExtensionInstallReq.fromJson(Map<String, dynamic> json) {
    return PHPExtensionInstallReq(
      iD: (json['ID'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'ID': iD,
      'name': name,
      'taskID': taskID,
  };
}

class PHPFileReq {
  final int id;
  final String type;

  const PHPFileReq({
    this.id = 0,
    this.type = '',
  });

  factory PHPFileReq.fromJson(Map<String, dynamic> json) {
    return PHPFileReq(
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'type': type,
  };
}

class PHPFileUpdate {
  final String content;
  final int id;
  final String type;

  const PHPFileUpdate({
    this.content = '',
    this.id = 0,
    this.type = '',
  });

  factory PHPFileUpdate.fromJson(Map<String, dynamic> json) {
    return PHPFileUpdate(
      content: json['content'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'id': id,
      'type': type,
  };
}

class PHPSupervisorProcessConfig {
  final String autoRestart;
  final String autoStart;
  final String command;
  final String dir;
  final String environment;
  final int id;
  final String name;
  final String numprocs;
  final String operate;
  final String user;

  const PHPSupervisorProcessConfig({
    this.autoRestart = '',
    this.autoStart = '',
    this.command = '',
    this.dir = '',
    this.environment = '',
    this.id = 0,
    this.name = '',
    this.numprocs = '',
    this.operate = '',
    this.user = '',
  });

  factory PHPSupervisorProcessConfig.fromJson(Map<String, dynamic> json) {
    return PHPSupervisorProcessConfig(
      autoRestart: json['autoRestart'] as String? ?? '',
      autoStart: json['autoStart'] as String? ?? '',
      command: json['command'] as String? ?? '',
      dir: json['dir'] as String? ?? '',
      environment: json['environment'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      numprocs: json['numprocs'] as String? ?? '',
      operate: json['operate'] as String? ?? '',
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'autoRestart': autoRestart,
      'autoStart': autoStart,
      'command': command,
      'dir': dir,
      'environment': environment,
      'id': id,
      'name': name,
      'numprocs': numprocs,
      'operate': operate,
      'user': user,
  };
}

class PHPSupervisorProcessFileReq {
  final String content;
  final String file;
  final int id;
  final String name;
  final String operate;

  const PHPSupervisorProcessFileReq({
    this.content = '',
    this.file = '',
    this.id = 0,
    this.name = '',
    this.operate = '',
  });

  factory PHPSupervisorProcessFileReq.fromJson(Map<String, dynamic> json) {
    return PHPSupervisorProcessFileReq(
      content: json['content'] as String? ?? '',
      file: json['file'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
      operate: json['operate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'file': file,
      'id': id,
      'name': name,
      'operate': operate,
  };
}

class RuntimeCreate {
  final int appDetailId;
  final bool clean;
  final String codeDir;
  final List<Environment> environments;
  final List<ExposedPort> exposedPorts;
  final List<ExtraHost> extraHosts;
  final String image;
  final bool install;
  final String name;
  final Map<String, dynamic> params;
  final String remark;
  final String resource;
  final String source;
  final String taskID;
  final String type;
  final String version;
  final List<Volume> volumes;

  const RuntimeCreate({
    this.appDetailId = 0,
    this.clean = false,
    this.codeDir = '',
    this.environments = const [],
    this.exposedPorts = const [],
    this.extraHosts = const [],
    this.image = '',
    this.install = false,
    this.name = '',
    this.params = const {},
    this.remark = '',
    this.resource = '',
    this.source = '',
    this.taskID = '',
    this.type = '',
    this.version = '',
    this.volumes = const [],
  });

  factory RuntimeCreate.fromJson(Map<String, dynamic> json) {
    return RuntimeCreate(
      appDetailId: (json['appDetailId'] as num?)?.toInt() ?? 0,
      clean: json['clean'] as bool? ?? false,
      codeDir: json['codeDir'] as String? ?? '',
      environments: (json['environments'] as List<dynamic>?)?.map((e) => Environment.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      exposedPorts: (json['exposedPorts'] as List<dynamic>?)?.map((e) => ExposedPort.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      extraHosts: (json['extraHosts'] as List<dynamic>?)?.map((e) => ExtraHost.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      image: json['image'] as String? ?? '',
      install: json['install'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      params: json['params'] as Map<String, dynamic>? ?? const {},
      remark: json['remark'] as String? ?? '',
      resource: json['resource'] as String? ?? '',
      source: json['source'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      type: json['type'] as String? ?? '',
      version: json['version'] as String? ?? '',
      volumes: (json['volumes'] as List<dynamic>?)?.map((e) => Volume.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'appDetailId': appDetailId,
      'clean': clean,
      'codeDir': codeDir,
      'environments': environments.map((e) => e.toJson()).toList(),
      'exposedPorts': exposedPorts.map((e) => e.toJson()).toList(),
      'extraHosts': extraHosts.map((e) => e.toJson()).toList(),
      'image': image,
      'install': install,
      'name': name,
      'params': params,
      'remark': remark,
      'resource': resource,
      'source': source,
      'taskID': taskID,
      'type': type,
      'version': version,
      'volumes': volumes.map((e) => e.toJson()).toList(),
  };
}

class RuntimeOperate {
  final int iD;
  final String operate;

  const RuntimeOperate({
    this.iD = 0,
    this.operate = '',
  });

  factory RuntimeOperate.fromJson(Map<String, dynamic> json) {
    return RuntimeOperate(
      iD: (json['ID'] as num?)?.toInt() ?? 0,
      operate: json['operate'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'ID': iD,
      'operate': operate,
  };
}

class RuntimeRemark {
  final int id;
  final String remark;

  const RuntimeRemark({
    this.id = 0,
    this.remark = '',
  });

  factory RuntimeRemark.fromJson(Map<String, dynamic> json) {
    return RuntimeRemark(
      id: (json['id'] as num?)?.toInt() ?? 0,
      remark: json['remark'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'remark': remark,
  };
}

class RuntimeSearch {
  final String name;
  final int page;
  final int pageSize;
  final String status;
  final String type;

  const RuntimeSearch({
    this.name = '',
    this.page = 0,
    this.pageSize = 0,
    this.status = '',
    this.type = '',
  });

  factory RuntimeSearch.fromJson(Map<String, dynamic> json) {
    return RuntimeSearch(
      name: json['name'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'page': page,
      'pageSize': pageSize,
      'status': status,
      'type': type,
  };
}

class RuntimeUpdate {
  final bool clean;
  final String codeDir;
  final List<Environment> environments;
  final List<ExposedPort> exposedPorts;
  final List<ExtraHost> extraHosts;
  final int id;
  final String image;
  final bool install;
  final String name;
  final Map<String, dynamic> params;
  final bool rebuild;
  final String remark;
  final String source;
  final String version;
  final List<Volume> volumes;

  const RuntimeUpdate({
    this.clean = false,
    this.codeDir = '',
    this.environments = const [],
    this.exposedPorts = const [],
    this.extraHosts = const [],
    this.id = 0,
    this.image = '',
    this.install = false,
    this.name = '',
    this.params = const {},
    this.rebuild = false,
    this.remark = '',
    this.source = '',
    this.version = '',
    this.volumes = const [],
  });

  factory RuntimeUpdate.fromJson(Map<String, dynamic> json) {
    return RuntimeUpdate(
      clean: json['clean'] as bool? ?? false,
      codeDir: json['codeDir'] as String? ?? '',
      environments: (json['environments'] as List<dynamic>?)?.map((e) => Environment.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      exposedPorts: (json['exposedPorts'] as List<dynamic>?)?.map((e) => ExposedPort.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      extraHosts: (json['extraHosts'] as List<dynamic>?)?.map((e) => ExtraHost.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
      image: json['image'] as String? ?? '',
      install: json['install'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      params: json['params'] as Map<String, dynamic>? ?? const {},
      rebuild: json['rebuild'] as bool? ?? false,
      remark: json['remark'] as String? ?? '',
      source: json['source'] as String? ?? '',
      version: json['version'] as String? ?? '',
      volumes: (json['volumes'] as List<dynamic>?)?.map((e) => Volume.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'clean': clean,
      'codeDir': codeDir,
      'environments': environments.map((e) => e.toJson()).toList(),
      'exposedPorts': exposedPorts.map((e) => e.toJson()).toList(),
      'extraHosts': extraHosts.map((e) => e.toJson()).toList(),
      'id': id,
      'image': image,
      'install': install,
      'name': name,
      'params': params,
      'rebuild': rebuild,
      'remark': remark,
      'source': source,
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

class FileInfo {
  final String content;
  final String extension;
  final int favoriteID;
  final String gid;
  final String group;
  final bool isAppendOnly;
  final bool isDetail;
  final bool isDir;
  final bool isHidden;
  final bool isImmutable;
  final bool isSymlink;
  final int itemTotal;
  final List<FilesFileinfo> items;
  final String linkPath;
  final String mimeType;
  final String modTime;
  final String mode;
  final String name;
  final String path;
  final String shareCode;
  final int size;
  final String type;
  final String uid;
  final String updateTime;
  final String user;

  const FileInfo({
    this.content = '',
    this.extension = '',
    this.favoriteID = 0,
    this.gid = '',
    this.group = '',
    this.isAppendOnly = false,
    this.isDetail = false,
    this.isDir = false,
    this.isHidden = false,
    this.isImmutable = false,
    this.isSymlink = false,
    this.itemTotal = 0,
    this.items = const [],
    this.linkPath = '',
    this.mimeType = '',
    this.modTime = '',
    this.mode = '',
    this.name = '',
    this.path = '',
    this.shareCode = '',
    this.size = 0,
    this.type = '',
    this.uid = '',
    this.updateTime = '',
    this.user = '',
  });

  factory FileInfo.fromJson(Map<String, dynamic> json) {
    return FileInfo(
      content: json['content'] as String? ?? '',
      extension: json['extension'] as String? ?? '',
      favoriteID: (json['favoriteID'] as num?)?.toInt() ?? 0,
      gid: json['gid'] as String? ?? '',
      group: json['group'] as String? ?? '',
      isAppendOnly: json['isAppendOnly'] as bool? ?? false,
      isDetail: json['isDetail'] as bool? ?? false,
      isDir: json['isDir'] as bool? ?? false,
      isHidden: json['isHidden'] as bool? ?? false,
      isImmutable: json['isImmutable'] as bool? ?? false,
      isSymlink: json['isSymlink'] as bool? ?? false,
      itemTotal: (json['itemTotal'] as num?)?.toInt() ?? 0,
      items: (json['items'] as List<dynamic>?)?.map((e) => FilesFileinfo.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      linkPath: json['linkPath'] as String? ?? '',
      mimeType: json['mimeType'] as String? ?? '',
      modTime: json['modTime'] as String? ?? '',
      mode: json['mode'] as String? ?? '',
      name: json['name'] as String? ?? '',
      path: json['path'] as String? ?? '',
      shareCode: json['shareCode'] as String? ?? '',
      size: (json['size'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      uid: json['uid'] as String? ?? '',
      updateTime: json['updateTime'] as String? ?? '',
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'content': content,
      'extension': extension,
      'favoriteID': favoriteID,
      'gid': gid,
      'group': group,
      'isAppendOnly': isAppendOnly,
      'isDetail': isDetail,
      'isDir': isDir,
      'isHidden': isHidden,
      'isImmutable': isImmutable,
      'isSymlink': isSymlink,
      'itemTotal': itemTotal,
      'items': items.map((e) => e.toJson()).toList(),
      'linkPath': linkPath,
      'mimeType': mimeType,
      'modTime': modTime,
      'mode': mode,
      'name': name,
      'path': path,
      'shareCode': shareCode,
      'size': size,
      'type': type,
      'uid': uid,
      'updateTime': updateTime,
      'user': user,
  };
}

class NodeModule {
  final String description;
  final String license;
  final String name;
  final String version;

  const NodeModule({
    this.description = '',
    this.license = '',
    this.name = '',
    this.version = '',
  });

  factory NodeModule.fromJson(Map<String, dynamic> json) {
    return NodeModule(
      description: json['description'] as String? ?? '',
      license: json['license'] as String? ?? '',
      name: json['name'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'description': description,
      'license': license,
      'name': name,
      'version': version,
  };
}

class PHPConfig {
  final List<String> disableFunctions;
  final String maxExecutionTime;
  final Map<String, dynamic> params;
  final String uploadMaxSize;

  const PHPConfig({
    this.disableFunctions = const [],
    this.maxExecutionTime = '',
    this.params = const {},
    this.uploadMaxSize = '',
  });

  factory PHPConfig.fromJson(Map<String, dynamic> json) {
    return PHPConfig(
      disableFunctions: (json['disableFunctions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      maxExecutionTime: json['maxExecutionTime'] as String? ?? '',
      params: json['params'] as Map<String, dynamic>? ?? const {},
      uploadMaxSize: json['uploadMaxSize'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'disableFunctions': disableFunctions,
      'maxExecutionTime': maxExecutionTime,
      'params': params,
      'uploadMaxSize': uploadMaxSize,
  };
}

class PHPExtensionRes {
  final List<String> extensions;
  final List<SupportExtension> supportExtensions;

  const PHPExtensionRes({
    this.extensions = const [],
    this.supportExtensions = const [],
  });

  factory PHPExtensionRes.fromJson(Map<String, dynamic> json) {
    return PHPExtensionRes(
      extensions: (json['extensions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      supportExtensions: (json['supportExtensions'] as List<dynamic>?)?.map((e) => SupportExtension.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'extensions': extensions,
      'supportExtensions': supportExtensions.map((e) => e.toJson()).toList(),
  };
}

class PackageScripts {
  final String name;
  final String script;

  const PackageScripts({
    this.name = '',
    this.script = '',
  });

  factory PackageScripts.fromJson(Map<String, dynamic> json) {
    return PackageScripts(
      name: json['name'] as String? ?? '',
      script: json['script'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'script': script,
  };
}

class ProcessStatus {
  final String pID;
  final String msg;
  final String name;
  final String status;
  final String uptime;

  const ProcessStatus({
    this.pID = '',
    this.msg = '',
    this.name = '',
    this.status = '',
    this.uptime = '',
  });

  factory ProcessStatus.fromJson(Map<String, dynamic> json) {
    return ProcessStatus(
      pID: json['PID'] as String? ?? '',
      msg: json['msg'] as String? ?? '',
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      uptime: json['uptime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'PID': pID,
      'msg': msg,
      'name': name,
      'status': status,
      'uptime': uptime,
  };
}

class RuntimeDTO {
  final int appDetailID;
  final int appID;
  final List<AppParam> appParams;
  final String codeDir;
  final String container;
  final String containerStatus;
  final String createdAt;
  final List<Environment> environments;
  final List<ExposedPort> exposedPorts;
  final List<ExtraHost> extraHosts;
  final int id;
  final String image;
  final String message;
  final String name;
  final Map<String, dynamic> params;
  final String path;
  final String port;
  final String remark;
  final String resource;
  final String source;
  final String status;
  final String type;
  final String version;
  final List<Volume> volumes;

  const RuntimeDTO({
    this.appDetailID = 0,
    this.appID = 0,
    this.appParams = const [],
    this.codeDir = '',
    this.container = '',
    this.containerStatus = '',
    this.createdAt = '',
    this.environments = const [],
    this.exposedPorts = const [],
    this.extraHosts = const [],
    this.id = 0,
    this.image = '',
    this.message = '',
    this.name = '',
    this.params = const {},
    this.path = '',
    this.port = '',
    this.remark = '',
    this.resource = '',
    this.source = '',
    this.status = '',
    this.type = '',
    this.version = '',
    this.volumes = const [],
  });

  factory RuntimeDTO.fromJson(Map<String, dynamic> json) {
    return RuntimeDTO(
      appDetailID: (json['appDetailID'] as num?)?.toInt() ?? 0,
      appID: (json['appID'] as num?)?.toInt() ?? 0,
      appParams: (json['appParams'] as List<dynamic>?)?.map((e) => AppParam.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      codeDir: json['codeDir'] as String? ?? '',
      container: json['container'] as String? ?? '',
      containerStatus: json['containerStatus'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      environments: (json['environments'] as List<dynamic>?)?.map((e) => Environment.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      exposedPorts: (json['exposedPorts'] as List<dynamic>?)?.map((e) => ExposedPort.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      extraHosts: (json['extraHosts'] as List<dynamic>?)?.map((e) => ExtraHost.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      id: (json['id'] as num?)?.toInt() ?? 0,
      image: json['image'] as String? ?? '',
      message: json['message'] as String? ?? '',
      name: json['name'] as String? ?? '',
      params: json['params'] as Map<String, dynamic>? ?? const {},
      path: json['path'] as String? ?? '',
      port: json['port'] as String? ?? '',
      remark: json['remark'] as String? ?? '',
      resource: json['resource'] as String? ?? '',
      source: json['source'] as String? ?? '',
      status: json['status'] as String? ?? '',
      type: json['type'] as String? ?? '',
      version: json['version'] as String? ?? '',
      volumes: (json['volumes'] as List<dynamic>?)?.map((e) => Volume.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'appDetailID': appDetailID,
      'appID': appID,
      'appParams': appParams.map((e) => e.toJson()).toList(),
      'codeDir': codeDir,
      'container': container,
      'containerStatus': containerStatus,
      'createdAt': createdAt,
      'environments': environments.map((e) => e.toJson()).toList(),
      'exposedPorts': exposedPorts.map((e) => e.toJson()).toList(),
      'extraHosts': extraHosts.map((e) => e.toJson()).toList(),
      'id': id,
      'image': image,
      'message': message,
      'name': name,
      'params': params,
      'path': path,
      'port': port,
      'remark': remark,
      'resource': resource,
      'source': source,
      'status': status,
      'type': type,
      'version': version,
      'volumes': volumes.map((e) => e.toJson()).toList(),
  };
}

class SupervisorProcessConfig {
  final String autoRestart;
  final String autoStart;
  final String command;
  final String dir;
  final String environment;
  final String msg;
  final String name;
  final String numprocs;
  final List<ProcessStatus> status;
  final String user;

  const SupervisorProcessConfig({
    this.autoRestart = '',
    this.autoStart = '',
    this.command = '',
    this.dir = '',
    this.environment = '',
    this.msg = '',
    this.name = '',
    this.numprocs = '',
    this.status = const [],
    this.user = '',
  });

  factory SupervisorProcessConfig.fromJson(Map<String, dynamic> json) {
    return SupervisorProcessConfig(
      autoRestart: json['autoRestart'] as String? ?? '',
      autoStart: json['autoStart'] as String? ?? '',
      command: json['command'] as String? ?? '',
      dir: json['dir'] as String? ?? '',
      environment: json['environment'] as String? ?? '',
      msg: json['msg'] as String? ?? '',
      name: json['name'] as String? ?? '',
      numprocs: json['numprocs'] as String? ?? '',
      status: (json['status'] as List<dynamic>?)?.map((e) => ProcessStatus.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      user: json['user'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'autoRestart': autoRestart,
      'autoStart': autoStart,
      'command': command,
      'dir': dir,
      'environment': environment,
      'msg': msg,
      'name': name,
      'numprocs': numprocs,
      'status': status.map((e) => e.toJson()).toList(),
      'user': user,
  };
}

class SupportExtension {
  final String check;
  final String description;
  final String file;
  final bool installed;
  final String name;
  final List<String> versions;

  const SupportExtension({
    this.check = '',
    this.description = '',
    this.file = '',
    this.installed = false,
    this.name = '',
    this.versions = const [],
  });

  factory SupportExtension.fromJson(Map<String, dynamic> json) {
    return SupportExtension(
      check: json['check'] as String? ?? '',
      description: json['description'] as String? ?? '',
      file: json['file'] as String? ?? '',
      installed: json['installed'] as bool? ?? false,
      name: json['name'] as String? ?? '',
      versions: (json['versions'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'check': check,
      'description': description,
      'file': file,
      'installed': installed,
      'name': name,
      'versions': versions,
  };
}
