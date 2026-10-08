// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

class CleanLog {
  final String logType;

  const CleanLog({
    this.logType = '',
  });

  factory CleanLog.fromJson(Map<String, dynamic> json) {
    return CleanLog(
      logType: json['logType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'logType': logType,
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

class SearchLgLogWithPage {
  final String endTime;
  final String info;
  final int page;
  final int pageSize;
  final String startTime;
  final String status;

  const SearchLgLogWithPage({
    this.endTime = '',
    this.info = '',
    this.page = 0,
    this.pageSize = 0,
    this.startTime = '',
    this.status = '',
  });

  factory SearchLgLogWithPage.fromJson(Map<String, dynamic> json) {
    return SearchLgLogWithPage(
      endTime: json['endTime'] as String? ?? '',
      info: json['info'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      startTime: json['startTime'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'endTime': endTime,
      'info': info,
      'page': page,
      'pageSize': pageSize,
      'startTime': startTime,
      'status': status,
  };
}

class SearchOpLogWithPage {
  final String node;
  final String operation;
  final int page;
  final int pageSize;
  final String source;
  final String status;

  const SearchOpLogWithPage({
    this.node = '',
    this.operation = '',
    this.page = 0,
    this.pageSize = 0,
    this.source = '',
    this.status = '',
  });

  factory SearchOpLogWithPage.fromJson(Map<String, dynamic> json) {
    return SearchOpLogWithPage(
      node: json['node'] as String? ?? '',
      operation: json['operation'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      source: json['source'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'node': node,
      'operation': operation,
      'page': page,
      'pageSize': pageSize,
      'source': source,
      'status': status,
  };
}

class SearchTaskLogReq {
  final int page;
  final int pageSize;
  final String status;
  final String taskID;
  final String type;

  const SearchTaskLogReq({
    this.page = 0,
    this.pageSize = 0,
    this.status = '',
    this.taskID = '',
    this.type = '',
  });

  factory SearchTaskLogReq.fromJson(Map<String, dynamic> json) {
    return SearchTaskLogReq(
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      taskID: json['taskID'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'page': page,
      'pageSize': pageSize,
      'status': status,
      'taskID': taskID,
      'type': type,
  };
}

class SystemLogItem {
  final String message;
  final String priority;
  final String raw;
  final String service;
  final String time;

  const SystemLogItem({
    this.message = '',
    this.priority = '',
    this.raw = '',
    this.service = '',
    this.time = '',
  });

  factory SystemLogItem.fromJson(Map<String, dynamic> json) {
    return SystemLogItem(
      message: json['message'] as String? ?? '',
      priority: json['priority'] as String? ?? '',
      raw: json['raw'] as String? ?? '',
      service: json['service'] as String? ?? '',
      time: json['time'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'message': message,
      'priority': priority,
      'raw': raw,
      'service': service,
      'time': time,
  };
}

class SystemLogReq {
  final String cursor;
  final String endTime;
  final String keyword;
  final int pageSize;
  final String priority;
  final String service;
  final String startTime;

  const SystemLogReq({
    this.cursor = '',
    this.endTime = '',
    this.keyword = '',
    this.pageSize = 0,
    this.priority = '',
    this.service = '',
    this.startTime = '',
  });

  factory SystemLogReq.fromJson(Map<String, dynamic> json) {
    return SystemLogReq(
      cursor: json['cursor'] as String? ?? '',
      endTime: json['endTime'] as String? ?? '',
      keyword: json['keyword'] as String? ?? '',
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      priority: json['priority'] as String? ?? '',
      service: json['service'] as String? ?? '',
      startTime: json['startTime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'cursor': cursor,
      'endTime': endTime,
      'keyword': keyword,
      'pageSize': pageSize,
      'priority': priority,
      'service': service,
      'startTime': startTime,
  };
}

class SystemLogRes {
  final bool hasMore;
  final List<SystemLogItem> items;
  final String nextCursor;
  final String source;

  const SystemLogRes({
    this.hasMore = false,
    this.items = const [],
    this.nextCursor = '',
    this.source = '',
  });

  factory SystemLogRes.fromJson(Map<String, dynamic> json) {
    return SystemLogRes(
      hasMore: json['hasMore'] as bool? ?? false,
      items: (json['items'] as List<dynamic>?)?.map((e) => SystemLogItem.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
      nextCursor: json['nextCursor'] as String? ?? '',
      source: json['source'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'hasMore': hasMore,
      'items': items.map((e) => e.toJson()).toList(),
      'nextCursor': nextCursor,
      'source': source,
  };
}

class SystemLogStatus {
  final bool keywordFilterSupported;
  final String message;
  final String source;
  final String version;

  const SystemLogStatus({
    this.keywordFilterSupported = false,
    this.message = '',
    this.source = '',
    this.version = '',
  });

  factory SystemLogStatus.fromJson(Map<String, dynamic> json) {
    return SystemLogStatus(
      keywordFilterSupported: json['keywordFilterSupported'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      source: json['source'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'keywordFilterSupported': keywordFilterSupported,
      'message': message,
      'source': source,
      'version': version,
  };
}

class TaskLogReadReq {
  final bool latest;
  final int page;
  final int pageSize;
  final int resourceID;
  final String taskID;
  final String taskOperate;
  final String taskType;

  const TaskLogReadReq({
    this.latest = false,
    this.page = 0,
    this.pageSize = 0,
    this.resourceID = 0,
    this.taskID = '',
    this.taskOperate = '',
    this.taskType = '',
  });

  factory TaskLogReadReq.fromJson(Map<String, dynamic> json) {
    return TaskLogReadReq(
      latest: json['latest'] as bool? ?? false,
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      resourceID: (json['resourceID'] as num?)?.toInt() ?? 0,
      taskID: json['taskID'] as String? ?? '',
      taskOperate: json['taskOperate'] as String? ?? '',
      taskType: json['taskType'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'latest': latest,
      'page': page,
      'pageSize': pageSize,
      'resourceID': resourceID,
      'taskID': taskID,
      'taskOperate': taskOperate,
      'taskType': taskType,
  };
}

class FileLineContent {
  final bool end;
  final List<String> lines;
  final String path;
  final String scope;
  final String taskStatus;
  final int total;
  final int totalLines;

  const FileLineContent({
    this.end = false,
    this.lines = const [],
    this.path = '',
    this.scope = '',
    this.taskStatus = '',
    this.total = 0,
    this.totalLines = 0,
  });

  factory FileLineContent.fromJson(Map<String, dynamic> json) {
    return FileLineContent(
      end: json['end'] as bool? ?? false,
      lines: (json['lines'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      path: json['path'] as String? ?? '',
      scope: json['scope'] as String? ?? '',
      taskStatus: json['taskStatus'] as String? ?? '',
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalLines: (json['totalLines'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'end': end,
      'lines': lines,
      'path': path,
      'scope': scope,
      'taskStatus': taskStatus,
      'total': total,
      'totalLines': totalLines,
  };
}
