// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

class AlertConfigPageReq {
  final List<String> excludeTypes;
  final int page;
  final int pageSize;

  const AlertConfigPageReq({
    this.excludeTypes = const [],
    this.page = 0,
    this.pageSize = 0,
  });

  factory AlertConfigPageReq.fromJson(Map<String, dynamic> json) {
    return AlertConfigPageReq(
      excludeTypes: (json['excludeTypes'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'excludeTypes': excludeTypes,
      'page': page,
      'pageSize': pageSize,
  };
}

class AlertConfigTest {
  final String displayName;
  final String encryption;
  final String host;
  final String password;
  final int port;
  final String recipient;
  final String sender;
  final String userName;

  const AlertConfigTest({
    this.displayName = '',
    this.encryption = '',
    this.host = '',
    this.password = '',
    this.port = 0,
    this.recipient = '',
    this.sender = '',
    this.userName = '',
  });

  factory AlertConfigTest.fromJson(Map<String, dynamic> json) {
    return AlertConfigTest(
      displayName: json['displayName'] as String? ?? '',
      encryption: json['encryption'] as String? ?? '',
      host: json['host'] as String? ?? '',
      password: json['password'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      recipient: json['recipient'] as String? ?? '',
      sender: json['sender'] as String? ?? '',
      userName: json['userName'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'displayName': displayName,
      'encryption': encryption,
      'host': host,
      'password': password,
      'port': port,
      'recipient': recipient,
      'sender': sender,
      'userName': userName,
  };
}

class AlertConfigUpdate {
  final String config;
  final String displayName;
  final int id;
  final String status;
  final String title;
  final String type;

  const AlertConfigUpdate({
    this.config = '',
    this.displayName = '',
    this.id = 0,
    this.status = '',
    this.title = '',
    this.type = '',
  });

  factory AlertConfigUpdate.fromJson(Map<String, dynamic> json) {
    return AlertConfigUpdate(
      config: json['config'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'config': config,
      'displayName': displayName,
      'id': id,
      'status': status,
      'title': title,
      'type': type,
  };
}

class AlertCreate {
  final String advancedParams;
  final int count;
  final int cycle;
  final String method;
  final String project;
  final int sendCount;
  final String status;
  final String title;
  final String type;

  const AlertCreate({
    this.advancedParams = '',
    this.count = 0,
    this.cycle = 0,
    this.method = '',
    this.project = '',
    this.sendCount = 0,
    this.status = '',
    this.title = '',
    this.type = '',
  });

  factory AlertCreate.fromJson(Map<String, dynamic> json) {
    return AlertCreate(
      advancedParams: json['advancedParams'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
      cycle: (json['cycle'] as num?)?.toInt() ?? 0,
      method: json['method'] as String? ?? '',
      project: json['project'] as String? ?? '',
      sendCount: (json['sendCount'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'advancedParams': advancedParams,
      'count': count,
      'cycle': cycle,
      'method': method,
      'project': project,
      'sendCount': sendCount,
      'status': status,
      'title': title,
      'type': type,
  };
}

class AlertLogSearch {
  final int count;
  final String endTime;
  final int page;
  final int pageSize;
  final String startTime;
  final String status;

  const AlertLogSearch({
    this.count = 0,
    this.endTime = '',
    this.page = 0,
    this.pageSize = 0,
    this.startTime = '',
    this.status = '',
  });

  factory AlertLogSearch.fromJson(Map<String, dynamic> json) {
    return AlertLogSearch(
      count: (json['count'] as num?)?.toInt() ?? 0,
      endTime: json['endTime'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      startTime: json['startTime'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'count': count,
      'endTime': endTime,
      'page': page,
      'pageSize': pageSize,
      'startTime': startTime,
      'status': status,
  };
}

class AlertSearch {
  final String method;
  final String order;
  final String orderBy;
  final int page;
  final int pageSize;
  final String status;
  final String type;

  const AlertSearch({
    this.method = '',
    this.order = '',
    this.orderBy = '',
    this.page = 0,
    this.pageSize = 0,
    this.status = '',
    this.type = '',
  });

  factory AlertSearch.fromJson(Map<String, dynamic> json) {
    return AlertSearch(
      method: json['method'] as String? ?? '',
      order: json['order'] as String? ?? '',
      orderBy: json['orderBy'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'method': method,
      'order': order,
      'orderBy': orderBy,
      'page': page,
      'pageSize': pageSize,
      'status': status,
      'type': type,
  };
}

class AlertUpdate {
  final String advancedParams;
  final int count;
  final int cycle;
  final int id;
  final String method;
  final String project;
  final int sendCount;
  final String status;
  final String title;
  final String type;

  const AlertUpdate({
    this.advancedParams = '',
    this.count = 0,
    this.cycle = 0,
    this.id = 0,
    this.method = '',
    this.project = '',
    this.sendCount = 0,
    this.status = '',
    this.title = '',
    this.type = '',
  });

  factory AlertUpdate.fromJson(Map<String, dynamic> json) {
    return AlertUpdate(
      advancedParams: json['advancedParams'] as String? ?? '',
      count: (json['count'] as num?)?.toInt() ?? 0,
      cycle: (json['cycle'] as num?)?.toInt() ?? 0,
      id: (json['id'] as num?)?.toInt() ?? 0,
      method: json['method'] as String? ?? '',
      project: json['project'] as String? ?? '',
      sendCount: (json['sendCount'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'advancedParams': advancedParams,
      'count': count,
      'cycle': cycle,
      'id': id,
      'method': method,
      'project': project,
      'sendCount': sendCount,
      'status': status,
      'title': title,
      'type': type,
  };
}

class AlertUpdateStatus {
  final int id;
  final String status;

  const AlertUpdateStatus({
    this.id = 0,
    this.status = '',
  });

  factory AlertUpdateStatus.fromJson(Map<String, dynamic> json) {
    return AlertUpdateStatus(
      id: (json['id'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
      'status': status,
  };
}

class CronJobReq {
  final String name;
  final String status;
  final String type;

  const CronJobReq({
    this.name = '',
    this.status = '',
    this.type = '',
  });

  factory CronJobReq.fromJson(Map<String, dynamic> json) {
    return CronJobReq(
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'status': status,
      'type': type,
  };
}

class DeleteRequest {
  final int id;

  const DeleteRequest({
    this.id = 0,
  });

  factory DeleteRequest.fromJson(Map<String, dynamic> json) {
    return DeleteRequest(
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'id': id,
  };
}
