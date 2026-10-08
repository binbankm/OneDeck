// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated Models

class ChangeDBInfo {
  final String database;
  final String from;
  final int id;
  final String type;
  final String value;

  const ChangeDBInfo({
    this.database = '',
    this.from = '',
    this.id = 0,
    this.type = '',
    this.value = '',
  });

  factory ChangeDBInfo.fromJson(Map<String, dynamic> json) {
    return ChangeDBInfo(
      database: json['database'] as String? ?? '',
      from: json['from'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'from': from,
      'id': id,
      'type': type,
      'value': value,
  };
}

class ChangeRedisPass {
  final String database;
  final String value;

  const ChangeRedisPass({
    this.database = '',
    this.value = '',
  });

  factory ChangeRedisPass.fromJson(Map<String, dynamic> json) {
    return ChangeRedisPass(
      database: json['database'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'value': value,
  };
}

class DBBaseInfo {
  final String containerName;
  final String name;
  final int port;

  const DBBaseInfo({
    this.containerName = '',
    this.name = '',
    this.port = 0,
  });

  factory DBBaseInfo.fromJson(Map<String, dynamic> json) {
    return DBBaseInfo(
      containerName: json['containerName'] as String? ?? '',
      name: json['name'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'containerName': containerName,
      'name': name,
      'port': port,
  };
}

class DBConfUpdateByFile {
  final String database;
  final String file;
  final String type;

  const DBConfUpdateByFile({
    this.database = '',
    this.file = '',
    this.type = '',
  });

  factory DBConfUpdateByFile.fromJson(Map<String, dynamic> json) {
    return DBConfUpdateByFile(
      database: json['database'] as String? ?? '',
      file: json['file'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'file': file,
      'type': type,
  };
}

class DatabaseCreate {
  final String address;
  final String clientCert;
  final String clientKey;
  final String description;
  final String from;
  final String initialDB;
  final String name;
  final String password;
  final int port;
  final String rootCert;
  final bool skipVerify;
  final bool ssl;
  final int timeout;
  final String type;
  final String username;
  final String version;

  const DatabaseCreate({
    this.address = '',
    this.clientCert = '',
    this.clientKey = '',
    this.description = '',
    this.from = '',
    this.initialDB = '',
    this.name = '',
    this.password = '',
    this.port = 0,
    this.rootCert = '',
    this.skipVerify = false,
    this.ssl = false,
    this.timeout = 0,
    this.type = '',
    this.username = '',
    this.version = '',
  });

  factory DatabaseCreate.fromJson(Map<String, dynamic> json) {
    return DatabaseCreate(
      address: json['address'] as String? ?? '',
      clientCert: json['clientCert'] as String? ?? '',
      clientKey: json['clientKey'] as String? ?? '',
      description: json['description'] as String? ?? '',
      from: json['from'] as String? ?? '',
      initialDB: json['initialDB'] as String? ?? '',
      name: json['name'] as String? ?? '',
      password: json['password'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      rootCert: json['rootCert'] as String? ?? '',
      skipVerify: json['skipVerify'] as bool? ?? false,
      ssl: json['ssl'] as bool? ?? false,
      timeout: (json['timeout'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      username: json['username'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'address': address,
      'clientCert': clientCert,
      'clientKey': clientKey,
      'description': description,
      'from': from,
      'initialDB': initialDB,
      'name': name,
      'password': password,
      'port': port,
      'rootCert': rootCert,
      'skipVerify': skipVerify,
      'ssl': ssl,
      'timeout': timeout,
      'type': type,
      'username': username,
      'version': version,
  };
}

class DatabaseDelete {
  final bool deleteBackup;
  final bool forceDelete;
  final int id;

  const DatabaseDelete({
    this.deleteBackup = false,
    this.forceDelete = false,
    this.id = 0,
  });

  factory DatabaseDelete.fromJson(Map<String, dynamic> json) {
    return DatabaseDelete(
      deleteBackup: json['deleteBackup'] as bool? ?? false,
      forceDelete: json['forceDelete'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'deleteBackup': deleteBackup,
      'forceDelete': forceDelete,
      'id': id,
  };
}

class DatabaseInfo {
  final String address;
  final String clientCert;
  final String clientKey;
  final String createdAt;
  final String description;
  final String from;
  final int id;
  final String initialDB;
  final String name;
  final String password;
  final int port;
  final String rootCert;
  final bool skipVerify;
  final bool ssl;
  final int timeout;
  final String type;
  final String username;
  final String version;

  const DatabaseInfo({
    this.address = '',
    this.clientCert = '',
    this.clientKey = '',
    this.createdAt = '',
    this.description = '',
    this.from = '',
    this.id = 0,
    this.initialDB = '',
    this.name = '',
    this.password = '',
    this.port = 0,
    this.rootCert = '',
    this.skipVerify = false,
    this.ssl = false,
    this.timeout = 0,
    this.type = '',
    this.username = '',
    this.version = '',
  });

  factory DatabaseInfo.fromJson(Map<String, dynamic> json) {
    return DatabaseInfo(
      address: json['address'] as String? ?? '',
      clientCert: json['clientCert'] as String? ?? '',
      clientKey: json['clientKey'] as String? ?? '',
      createdAt: json['createdAt'] as String? ?? '',
      description: json['description'] as String? ?? '',
      from: json['from'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      initialDB: json['initialDB'] as String? ?? '',
      name: json['name'] as String? ?? '',
      password: json['password'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      rootCert: json['rootCert'] as String? ?? '',
      skipVerify: json['skipVerify'] as bool? ?? false,
      ssl: json['ssl'] as bool? ?? false,
      timeout: (json['timeout'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      username: json['username'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'address': address,
      'clientCert': clientCert,
      'clientKey': clientKey,
      'createdAt': createdAt,
      'description': description,
      'from': from,
      'id': id,
      'initialDB': initialDB,
      'name': name,
      'password': password,
      'port': port,
      'rootCert': rootCert,
      'skipVerify': skipVerify,
      'ssl': ssl,
      'timeout': timeout,
      'type': type,
      'username': username,
      'version': version,
  };
}

class DatabaseItem {
  final String database;
  final String from;
  final int id;
  final String name;

  const DatabaseItem({
    this.database = '',
    this.from = '',
    this.id = 0,
    this.name = '',
  });

  factory DatabaseItem.fromJson(Map<String, dynamic> json) {
    return DatabaseItem(
      database: json['database'] as String? ?? '',
      from: json['from'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'from': from,
      'id': id,
      'name': name,
  };
}

class DatabaseOption {
  final String address;
  final String database;
  final String from;
  final int id;
  final String type;
  final String version;

  const DatabaseOption({
    this.address = '',
    this.database = '',
    this.from = '',
    this.id = 0,
    this.type = '',
    this.version = '',
  });

  factory DatabaseOption.fromJson(Map<String, dynamic> json) {
    return DatabaseOption(
      address: json['address'] as String? ?? '',
      database: json['database'] as String? ?? '',
      from: json['from'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'address': address,
      'database': database,
      'from': from,
      'id': id,
      'type': type,
      'version': version,
  };
}

class DatabaseSearch {
  final String info;
  final String order;
  final String orderBy;
  final int page;
  final int pageSize;
  final String type;

  const DatabaseSearch({
    this.info = '',
    this.order = '',
    this.orderBy = '',
    this.page = 0,
    this.pageSize = 0,
    this.type = '',
  });

  factory DatabaseSearch.fromJson(Map<String, dynamic> json) {
    return DatabaseSearch(
      info: json['info'] as String? ?? '',
      order: json['order'] as String? ?? '',
      orderBy: json['orderBy'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'info': info,
      'order': order,
      'orderBy': orderBy,
      'page': page,
      'pageSize': pageSize,
      'type': type,
  };
}

class DatabaseUpdate {
  final String address;
  final String clientCert;
  final String clientKey;
  final String description;
  final int id;
  final String initialDB;
  final String password;
  final int port;
  final String rootCert;
  final bool skipVerify;
  final bool ssl;
  final int timeout;
  final String type;
  final String username;
  final String version;

  const DatabaseUpdate({
    this.address = '',
    this.clientCert = '',
    this.clientKey = '',
    this.description = '',
    this.id = 0,
    this.initialDB = '',
    this.password = '',
    this.port = 0,
    this.rootCert = '',
    this.skipVerify = false,
    this.ssl = false,
    this.timeout = 0,
    this.type = '',
    this.username = '',
    this.version = '',
  });

  factory DatabaseUpdate.fromJson(Map<String, dynamic> json) {
    return DatabaseUpdate(
      address: json['address'] as String? ?? '',
      clientCert: json['clientCert'] as String? ?? '',
      clientKey: json['clientKey'] as String? ?? '',
      description: json['description'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      initialDB: json['initialDB'] as String? ?? '',
      password: json['password'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      rootCert: json['rootCert'] as String? ?? '',
      skipVerify: json['skipVerify'] as bool? ?? false,
      ssl: json['ssl'] as bool? ?? false,
      timeout: (json['timeout'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
      username: json['username'] as String? ?? '',
      version: json['version'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'address': address,
      'clientCert': clientCert,
      'clientKey': clientKey,
      'description': description,
      'id': id,
      'initialDB': initialDB,
      'password': password,
      'port': port,
      'rootCert': rootCert,
      'skipVerify': skipVerify,
      'ssl': ssl,
      'timeout': timeout,
      'type': type,
      'username': username,
      'version': version,
  };
}

class LoadRedisStatus {
  final String name;
  final String type;

  const LoadRedisStatus({
    this.name = '',
    this.type = '',
  });

  factory LoadRedisStatus.fromJson(Map<String, dynamic> json) {
    return LoadRedisStatus(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
      'type': type,
  };
}

class MongodbBind {
  final String database;
  final String name;
  final String password;
  final String username;

  const MongodbBind({
    this.database = '',
    this.name = '',
    this.password = '',
    this.username = '',
  });

  factory MongodbBind.fromJson(Map<String, dynamic> json) {
    return MongodbBind(
      database: json['database'] as String? ?? '',
      name: json['name'] as String? ?? '',
      password: json['password'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'name': name,
      'password': password,
      'username': username,
  };
}

class MongodbDBCreate {
  final String database;
  final String description;
  final String from;
  final String name;
  final String password;
  final String permission;
  final String username;

  const MongodbDBCreate({
    this.database = '',
    this.description = '',
    this.from = '',
    this.name = '',
    this.password = '',
    this.permission = '',
    this.username = '',
  });

  factory MongodbDBCreate.fromJson(Map<String, dynamic> json) {
    return MongodbDBCreate(
      database: json['database'] as String? ?? '',
      description: json['description'] as String? ?? '',
      from: json['from'] as String? ?? '',
      name: json['name'] as String? ?? '',
      password: json['password'] as String? ?? '',
      permission: json['permission'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'description': description,
      'from': from,
      'name': name,
      'password': password,
      'permission': permission,
      'username': username,
  };
}

class MongodbDBDelete {
  final String database;
  final bool deleteBackup;
  final bool forceDelete;
  final int id;
  final String type;

  const MongodbDBDelete({
    this.database = '',
    this.deleteBackup = false,
    this.forceDelete = false,
    this.id = 0,
    this.type = '',
  });

  factory MongodbDBDelete.fromJson(Map<String, dynamic> json) {
    return MongodbDBDelete(
      database: json['database'] as String? ?? '',
      deleteBackup: json['deleteBackup'] as bool? ?? false,
      forceDelete: json['forceDelete'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'deleteBackup': deleteBackup,
      'forceDelete': forceDelete,
      'id': id,
      'type': type,
  };
}

class MongodbDBDeleteCheck {
  final String database;
  final int id;
  final String type;

  const MongodbDBDeleteCheck({
    this.database = '',
    this.id = 0,
    this.type = '',
  });

  factory MongodbDBDeleteCheck.fromJson(Map<String, dynamic> json) {
    return MongodbDBDeleteCheck(
      database: json['database'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'id': id,
      'type': type,
  };
}

class MongodbDBSearch {
  final String database;
  final String info;
  final String order;
  final String orderBy;
  final int page;
  final int pageSize;

  const MongodbDBSearch({
    this.database = '',
    this.info = '',
    this.order = '',
    this.orderBy = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory MongodbDBSearch.fromJson(Map<String, dynamic> json) {
    return MongodbDBSearch(
      database: json['database'] as String? ?? '',
      info: json['info'] as String? ?? '',
      order: json['order'] as String? ?? '',
      orderBy: json['orderBy'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'info': info,
      'order': order,
      'orderBy': orderBy,
      'page': page,
      'pageSize': pageSize,
  };
}

class MongodbLoadDB {
  final String database;
  final String from;
  final String type;

  const MongodbLoadDB({
    this.database = '',
    this.from = '',
    this.type = '',
  });

  factory MongodbLoadDB.fromJson(Map<String, dynamic> json) {
    return MongodbLoadDB(
      database: json['database'] as String? ?? '',
      from: json['from'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'from': from,
      'type': type,
  };
}

class MongodbPassword {
  final String database;
  final String name;
  final String password;

  const MongodbPassword({
    this.database = '',
    this.name = '',
    this.password = '',
  });

  factory MongodbPassword.fromJson(Map<String, dynamic> json) {
    return MongodbPassword(
      database: json['database'] as String? ?? '',
      name: json['name'] as String? ?? '',
      password: json['password'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'name': name,
      'password': password,
  };
}

class MongodbPrivileges {
  final String database;
  final String name;
  final String permission;
  final String username;

  const MongodbPrivileges({
    this.database = '',
    this.name = '',
    this.permission = '',
    this.username = '',
  });

  factory MongodbPrivileges.fromJson(Map<String, dynamic> json) {
    return MongodbPrivileges(
      database: json['database'] as String? ?? '',
      name: json['name'] as String? ?? '',
      permission: json['permission'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'name': name,
      'permission': permission,
      'username': username,
  };
}

class MongodbPrivilegesLoad {
  final String database;
  final String name;
  final String username;

  const MongodbPrivilegesLoad({
    this.database = '',
    this.name = '',
    this.username = '',
  });

  factory MongodbPrivilegesLoad.fromJson(Map<String, dynamic> json) {
    return MongodbPrivilegesLoad(
      database: json['database'] as String? ?? '',
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'name': name,
      'username': username,
  };
}

class MysqlDBCreate {
  final String collation;
  final String database;
  final String description;
  final String format;
  final String from;
  final String name;
  final String password;
  final String permission;
  final String username;

  const MysqlDBCreate({
    this.collation = '',
    this.database = '',
    this.description = '',
    this.format = '',
    this.from = '',
    this.name = '',
    this.password = '',
    this.permission = '',
    this.username = '',
  });

  factory MysqlDBCreate.fromJson(Map<String, dynamic> json) {
    return MysqlDBCreate(
      collation: json['collation'] as String? ?? '',
      database: json['database'] as String? ?? '',
      description: json['description'] as String? ?? '',
      format: json['format'] as String? ?? '',
      from: json['from'] as String? ?? '',
      name: json['name'] as String? ?? '',
      password: json['password'] as String? ?? '',
      permission: json['permission'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'collation': collation,
      'database': database,
      'description': description,
      'format': format,
      'from': from,
      'name': name,
      'password': password,
      'permission': permission,
      'username': username,
  };
}

class MysqlDBDelete {
  final String database;
  final bool deleteBackup;
  final bool forceDelete;
  final int id;
  final String type;

  const MysqlDBDelete({
    this.database = '',
    this.deleteBackup = false,
    this.forceDelete = false,
    this.id = 0,
    this.type = '',
  });

  factory MysqlDBDelete.fromJson(Map<String, dynamic> json) {
    return MysqlDBDelete(
      database: json['database'] as String? ?? '',
      deleteBackup: json['deleteBackup'] as bool? ?? false,
      forceDelete: json['forceDelete'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'deleteBackup': deleteBackup,
      'forceDelete': forceDelete,
      'id': id,
      'type': type,
  };
}

class MysqlDBDeleteCheck {
  final String database;
  final int id;
  final String type;

  const MysqlDBDeleteCheck({
    this.database = '',
    this.id = 0,
    this.type = '',
  });

  factory MysqlDBDeleteCheck.fromJson(Map<String, dynamic> json) {
    return MysqlDBDeleteCheck(
      database: json['database'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'id': id,
      'type': type,
  };
}

class MysqlDBSearch {
  final String database;
  final String info;
  final String order;
  final String orderBy;
  final int page;
  final int pageSize;

  const MysqlDBSearch({
    this.database = '',
    this.info = '',
    this.order = '',
    this.orderBy = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory MysqlDBSearch.fromJson(Map<String, dynamic> json) {
    return MysqlDBSearch(
      database: json['database'] as String? ?? '',
      info: json['info'] as String? ?? '',
      order: json['order'] as String? ?? '',
      orderBy: json['orderBy'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'info': info,
      'order': order,
      'orderBy': orderBy,
      'page': page,
      'pageSize': pageSize,
  };
}

class MysqlFormatCollationOption {
  final List<String> collations;
  final String format;

  const MysqlFormatCollationOption({
    this.collations = const [],
    this.format = '',
  });

  factory MysqlFormatCollationOption.fromJson(Map<String, dynamic> json) {
    return MysqlFormatCollationOption(
      collations: (json['collations'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      format: json['format'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'collations': collations,
      'format': format,
  };
}

class MysqlGrant {
  final String database;
  final String host;
  final String username;

  const MysqlGrant({
    this.database = '',
    this.host = '',
    this.username = '',
  });

  factory MysqlGrant.fromJson(Map<String, dynamic> json) {
    return MysqlGrant(
      database: json['database'] as String? ?? '',
      host: json['host'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'host': host,
      'username': username,
  };
}

class MysqlGrantCreate {
  final String database;
  final String db;
  final String host;
  final String username;

  const MysqlGrantCreate({
    this.database = '',
    this.db = '',
    this.host = '',
    this.username = '',
  });

  factory MysqlGrantCreate.fromJson(Map<String, dynamic> json) {
    return MysqlGrantCreate(
      database: json['database'] as String? ?? '',
      db: json['db'] as String? ?? '',
      host: json['host'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'db': db,
      'host': host,
      'username': username,
  };
}

class MysqlGrantDelete {
  final String database;
  final String db;
  final String host;
  final String username;

  const MysqlGrantDelete({
    this.database = '',
    this.db = '',
    this.host = '',
    this.username = '',
  });

  factory MysqlGrantDelete.fromJson(Map<String, dynamic> json) {
    return MysqlGrantDelete(
      database: json['database'] as String? ?? '',
      db: json['db'] as String? ?? '',
      host: json['host'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'db': db,
      'host': host,
      'username': username,
  };
}

class MysqlGrantSummarySearch {
  final String database;
  final List<String> dbs;

  const MysqlGrantSummarySearch({
    this.database = '',
    this.dbs = const [],
  });

  factory MysqlGrantSummarySearch.fromJson(Map<String, dynamic> json) {
    return MysqlGrantSummarySearch(
      database: json['database'] as String? ?? '',
      dbs: (json['dbs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'dbs': dbs,
  };
}

class MysqlLoadDB {
  final String database;
  final String from;
  final String type;

  const MysqlLoadDB({
    this.database = '',
    this.from = '',
    this.type = '',
  });

  factory MysqlLoadDB.fromJson(Map<String, dynamic> json) {
    return MysqlLoadDB(
      database: json['database'] as String? ?? '',
      from: json['from'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'from': from,
      'type': type,
  };
}

class MysqlStatus {
  final String abortedClients;
  final String abortedConnects;
  final String bytesReceived;
  final String bytesSent;
  final String comCommit;
  final String comRollback;
  final String connections;
  final String createdTmpDiskTables;
  final String createdTmpTables;
  final String file;
  final String innodbBufferPoolPagesDirty;
  final String innodbBufferPoolReadRequests;
  final String innodbBufferPoolReads;
  final String keyReadRequests;
  final String keyReads;
  final String keyWriteRequests;
  final String keyWrites;
  final String maxUsedConnections;
  final String openTables;
  final String openedFiles;
  final String openedTables;
  final String position;
  final String qcacheHits;
  final String qcacheInserts;
  final String questions;
  final String run;
  final String selectFullJoin;
  final String selectRangeCheck;
  final String sortMergePasses;
  final String tableLocksWaited;
  final String threadsCached;
  final String threadsConnected;
  final String threadsCreated;
  final String threadsRunning;
  final String uptime;

  const MysqlStatus({
    this.abortedClients = '',
    this.abortedConnects = '',
    this.bytesReceived = '',
    this.bytesSent = '',
    this.comCommit = '',
    this.comRollback = '',
    this.connections = '',
    this.createdTmpDiskTables = '',
    this.createdTmpTables = '',
    this.file = '',
    this.innodbBufferPoolPagesDirty = '',
    this.innodbBufferPoolReadRequests = '',
    this.innodbBufferPoolReads = '',
    this.keyReadRequests = '',
    this.keyReads = '',
    this.keyWriteRequests = '',
    this.keyWrites = '',
    this.maxUsedConnections = '',
    this.openTables = '',
    this.openedFiles = '',
    this.openedTables = '',
    this.position = '',
    this.qcacheHits = '',
    this.qcacheInserts = '',
    this.questions = '',
    this.run = '',
    this.selectFullJoin = '',
    this.selectRangeCheck = '',
    this.sortMergePasses = '',
    this.tableLocksWaited = '',
    this.threadsCached = '',
    this.threadsConnected = '',
    this.threadsCreated = '',
    this.threadsRunning = '',
    this.uptime = '',
  });

  factory MysqlStatus.fromJson(Map<String, dynamic> json) {
    return MysqlStatus(
      abortedClients: json['Aborted_clients'] as String? ?? '',
      abortedConnects: json['Aborted_connects'] as String? ?? '',
      bytesReceived: json['Bytes_received'] as String? ?? '',
      bytesSent: json['Bytes_sent'] as String? ?? '',
      comCommit: json['Com_commit'] as String? ?? '',
      comRollback: json['Com_rollback'] as String? ?? '',
      connections: json['Connections'] as String? ?? '',
      createdTmpDiskTables: json['Created_tmp_disk_tables'] as String? ?? '',
      createdTmpTables: json['Created_tmp_tables'] as String? ?? '',
      file: json['File'] as String? ?? '',
      innodbBufferPoolPagesDirty: json['Innodb_buffer_pool_pages_dirty'] as String? ?? '',
      innodbBufferPoolReadRequests: json['Innodb_buffer_pool_read_requests'] as String? ?? '',
      innodbBufferPoolReads: json['Innodb_buffer_pool_reads'] as String? ?? '',
      keyReadRequests: json['Key_read_requests'] as String? ?? '',
      keyReads: json['Key_reads'] as String? ?? '',
      keyWriteRequests: json['Key_write_requests'] as String? ?? '',
      keyWrites: json['Key_writes'] as String? ?? '',
      maxUsedConnections: json['Max_used_connections'] as String? ?? '',
      openTables: json['Open_tables'] as String? ?? '',
      openedFiles: json['Opened_files'] as String? ?? '',
      openedTables: json['Opened_tables'] as String? ?? '',
      position: json['Position'] as String? ?? '',
      qcacheHits: json['Qcache_hits'] as String? ?? '',
      qcacheInserts: json['Qcache_inserts'] as String? ?? '',
      questions: json['Questions'] as String? ?? '',
      run: json['Run'] as String? ?? '',
      selectFullJoin: json['Select_full_join'] as String? ?? '',
      selectRangeCheck: json['Select_range_check'] as String? ?? '',
      sortMergePasses: json['Sort_merge_passes'] as String? ?? '',
      tableLocksWaited: json['Table_locks_waited'] as String? ?? '',
      threadsCached: json['Threads_cached'] as String? ?? '',
      threadsConnected: json['Threads_connected'] as String? ?? '',
      threadsCreated: json['Threads_created'] as String? ?? '',
      threadsRunning: json['Threads_running'] as String? ?? '',
      uptime: json['Uptime'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'Aborted_clients': abortedClients,
      'Aborted_connects': abortedConnects,
      'Bytes_received': bytesReceived,
      'Bytes_sent': bytesSent,
      'Com_commit': comCommit,
      'Com_rollback': comRollback,
      'Connections': connections,
      'Created_tmp_disk_tables': createdTmpDiskTables,
      'Created_tmp_tables': createdTmpTables,
      'File': file,
      'Innodb_buffer_pool_pages_dirty': innodbBufferPoolPagesDirty,
      'Innodb_buffer_pool_read_requests': innodbBufferPoolReadRequests,
      'Innodb_buffer_pool_reads': innodbBufferPoolReads,
      'Key_read_requests': keyReadRequests,
      'Key_reads': keyReads,
      'Key_write_requests': keyWriteRequests,
      'Key_writes': keyWrites,
      'Max_used_connections': maxUsedConnections,
      'Open_tables': openTables,
      'Opened_files': openedFiles,
      'Opened_tables': openedTables,
      'Position': position,
      'Qcache_hits': qcacheHits,
      'Qcache_inserts': qcacheInserts,
      'Questions': questions,
      'Run': run,
      'Select_full_join': selectFullJoin,
      'Select_range_check': selectRangeCheck,
      'Sort_merge_passes': sortMergePasses,
      'Table_locks_waited': tableLocksWaited,
      'Threads_cached': threadsCached,
      'Threads_connected': threadsConnected,
      'Threads_created': threadsCreated,
      'Threads_running': threadsRunning,
      'Uptime': uptime,
  };
}

class MysqlUser {
  final String description;
  final String host;
  final bool isDelete;
  final String password;
  final String username;

  const MysqlUser({
    this.description = '',
    this.host = '',
    this.isDelete = false,
    this.password = '',
    this.username = '',
  });

  factory MysqlUser.fromJson(Map<String, dynamic> json) {
    return MysqlUser(
      description: json['description'] as String? ?? '',
      host: json['host'] as String? ?? '',
      isDelete: json['isDelete'] as bool? ?? false,
      password: json['password'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'description': description,
      'host': host,
      'isDelete': isDelete,
      'password': password,
      'username': username,
  };
}

class MysqlUserCreate {
  final String database;
  final List<String> dbs;
  final String description;
  final String host;
  final String password;
  final String username;

  const MysqlUserCreate({
    this.database = '',
    this.dbs = const [],
    this.description = '',
    this.host = '',
    this.password = '',
    this.username = '',
  });

  factory MysqlUserCreate.fromJson(Map<String, dynamic> json) {
    return MysqlUserCreate(
      database: json['database'] as String? ?? '',
      dbs: (json['dbs'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const [],
      description: json['description'] as String? ?? '',
      host: json['host'] as String? ?? '',
      password: json['password'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'dbs': dbs,
      'description': description,
      'host': host,
      'password': password,
      'username': username,
  };
}

class MysqlUserDelete {
  final String database;
  final String host;
  final String username;

  const MysqlUserDelete({
    this.database = '',
    this.host = '',
    this.username = '',
  });

  factory MysqlUserDelete.fromJson(Map<String, dynamic> json) {
    return MysqlUserDelete(
      database: json['database'] as String? ?? '',
      host: json['host'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'host': host,
      'username': username,
  };
}

class MysqlUserPassword {
  final String database;
  final String host;
  final String password;
  final String username;

  const MysqlUserPassword({
    this.database = '',
    this.host = '',
    this.password = '',
    this.username = '',
  });

  factory MysqlUserPassword.fromJson(Map<String, dynamic> json) {
    return MysqlUserPassword(
      database: json['database'] as String? ?? '',
      host: json['host'] as String? ?? '',
      password: json['password'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'host': host,
      'password': password,
      'username': username,
  };
}

class MysqlUserSearch {
  final String database;

  const MysqlUserSearch({
    this.database = '',
  });

  factory MysqlUserSearch.fromJson(Map<String, dynamic> json) {
    return MysqlUserSearch(
      database: json['database'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
  };
}

class MysqlUserUpdate {
  final String database;
  final String description;
  final String host;
  final String newHost;
  final String username;

  const MysqlUserUpdate({
    this.database = '',
    this.description = '',
    this.host = '',
    this.newHost = '',
    this.username = '',
  });

  factory MysqlUserUpdate.fromJson(Map<String, dynamic> json) {
    return MysqlUserUpdate(
      database: json['database'] as String? ?? '',
      description: json['description'] as String? ?? '',
      host: json['host'] as String? ?? '',
      newHost: json['newHost'] as String? ?? '',
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'description': description,
      'host': host,
      'newHost': newHost,
      'username': username,
  };
}

class MysqlVariables {
  final String binlogCacheSize;
  final String innodbBufferPoolSize;
  final String innodbLogBufferSize;
  final String joinBufferSize;
  final String keyBufferSize;
  final String longQueryTime;
  final String maxConnections;
  final String maxHeapTableSize;
  final String queryCacheSize;
  final String queryCacheType;
  final String readBufferSize;
  final String readRndBufferSize;
  final String slowQueryLog;
  final String sortBufferSize;
  final String tableOpenCache;
  final String threadCacheSize;
  final String threadStack;
  final String tmpTableSize;

  const MysqlVariables({
    this.binlogCacheSize = '',
    this.innodbBufferPoolSize = '',
    this.innodbLogBufferSize = '',
    this.joinBufferSize = '',
    this.keyBufferSize = '',
    this.longQueryTime = '',
    this.maxConnections = '',
    this.maxHeapTableSize = '',
    this.queryCacheSize = '',
    this.queryCacheType = '',
    this.readBufferSize = '',
    this.readRndBufferSize = '',
    this.slowQueryLog = '',
    this.sortBufferSize = '',
    this.tableOpenCache = '',
    this.threadCacheSize = '',
    this.threadStack = '',
    this.tmpTableSize = '',
  });

  factory MysqlVariables.fromJson(Map<String, dynamic> json) {
    return MysqlVariables(
      binlogCacheSize: json['binlog_cache_size'] as String? ?? '',
      innodbBufferPoolSize: json['innodb_buffer_pool_size'] as String? ?? '',
      innodbLogBufferSize: json['innodb_log_buffer_size'] as String? ?? '',
      joinBufferSize: json['join_buffer_size'] as String? ?? '',
      keyBufferSize: json['key_buffer_size'] as String? ?? '',
      longQueryTime: json['long_query_time'] as String? ?? '',
      maxConnections: json['max_connections'] as String? ?? '',
      maxHeapTableSize: json['max_heap_table_size'] as String? ?? '',
      queryCacheSize: json['query_cache_size'] as String? ?? '',
      queryCacheType: json['query_cache_type'] as String? ?? '',
      readBufferSize: json['read_buffer_size'] as String? ?? '',
      readRndBufferSize: json['read_rnd_buffer_size'] as String? ?? '',
      slowQueryLog: json['slow_query_log'] as String? ?? '',
      sortBufferSize: json['sort_buffer_size'] as String? ?? '',
      tableOpenCache: json['table_open_cache'] as String? ?? '',
      threadCacheSize: json['thread_cache_size'] as String? ?? '',
      threadStack: json['thread_stack'] as String? ?? '',
      tmpTableSize: json['tmp_table_size'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'binlog_cache_size': binlogCacheSize,
      'innodb_buffer_pool_size': innodbBufferPoolSize,
      'innodb_log_buffer_size': innodbLogBufferSize,
      'join_buffer_size': joinBufferSize,
      'key_buffer_size': keyBufferSize,
      'long_query_time': longQueryTime,
      'max_connections': maxConnections,
      'max_heap_table_size': maxHeapTableSize,
      'query_cache_size': queryCacheSize,
      'query_cache_type': queryCacheType,
      'read_buffer_size': readBufferSize,
      'read_rnd_buffer_size': readRndBufferSize,
      'slow_query_log': slowQueryLog,
      'sort_buffer_size': sortBufferSize,
      'table_open_cache': tableOpenCache,
      'thread_cache_size': threadCacheSize,
      'thread_stack': threadStack,
      'tmp_table_size': tmpTableSize,
  };
}

class MysqlVariablesUpdate {
  final String database;
  final String type;
  final List<MysqlVariablesUpdateHelper> variables;

  const MysqlVariablesUpdate({
    this.database = '',
    this.type = '',
    this.variables = const [],
  });

  factory MysqlVariablesUpdate.fromJson(Map<String, dynamic> json) {
    return MysqlVariablesUpdate(
      database: json['database'] as String? ?? '',
      type: json['type'] as String? ?? '',
      variables: (json['variables'] as List<dynamic>?)?.map((e) => MysqlVariablesUpdateHelper.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'type': type,
      'variables': variables.map((e) => e.toJson()).toList(),
  };
}

class MysqlVariablesUpdateHelper {
  final String param;
  final dynamic value;

  const MysqlVariablesUpdateHelper({
    this.param = '',
    this.value,
  });

  factory MysqlVariablesUpdateHelper.fromJson(Map<String, dynamic> json) {
    return MysqlVariablesUpdateHelper(
      param: json['param'] as String? ?? '',
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() => {
      'param': param,
      'value': value,
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

class OperationWithName {
  final String name;

  const OperationWithName({
    this.name = '',
  });

  factory OperationWithName.fromJson(Map<String, dynamic> json) {
    return OperationWithName(
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'name': name,
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

class PostgresqlBindUser {
  final String database;
  final String name;
  final String password;
  final bool superUser;
  final String username;

  const PostgresqlBindUser({
    this.database = '',
    this.name = '',
    this.password = '',
    this.superUser = false,
    this.username = '',
  });

  factory PostgresqlBindUser.fromJson(Map<String, dynamic> json) {
    return PostgresqlBindUser(
      database: json['database'] as String? ?? '',
      name: json['name'] as String? ?? '',
      password: json['password'] as String? ?? '',
      superUser: json['superUser'] as bool? ?? false,
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'name': name,
      'password': password,
      'superUser': superUser,
      'username': username,
  };
}

class PostgresqlDBCreate {
  final String database;
  final String description;
  final String format;
  final String from;
  final String name;
  final String password;
  final bool superUser;
  final String username;

  const PostgresqlDBCreate({
    this.database = '',
    this.description = '',
    this.format = '',
    this.from = '',
    this.name = '',
    this.password = '',
    this.superUser = false,
    this.username = '',
  });

  factory PostgresqlDBCreate.fromJson(Map<String, dynamic> json) {
    return PostgresqlDBCreate(
      database: json['database'] as String? ?? '',
      description: json['description'] as String? ?? '',
      format: json['format'] as String? ?? '',
      from: json['from'] as String? ?? '',
      name: json['name'] as String? ?? '',
      password: json['password'] as String? ?? '',
      superUser: json['superUser'] as bool? ?? false,
      username: json['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'description': description,
      'format': format,
      'from': from,
      'name': name,
      'password': password,
      'superUser': superUser,
      'username': username,
  };
}

class PostgresqlDBDelete {
  final String database;
  final bool deleteBackup;
  final bool forceDelete;
  final int id;
  final String type;

  const PostgresqlDBDelete({
    this.database = '',
    this.deleteBackup = false,
    this.forceDelete = false,
    this.id = 0,
    this.type = '',
  });

  factory PostgresqlDBDelete.fromJson(Map<String, dynamic> json) {
    return PostgresqlDBDelete(
      database: json['database'] as String? ?? '',
      deleteBackup: json['deleteBackup'] as bool? ?? false,
      forceDelete: json['forceDelete'] as bool? ?? false,
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'deleteBackup': deleteBackup,
      'forceDelete': forceDelete,
      'id': id,
      'type': type,
  };
}

class PostgresqlDBDeleteCheck {
  final String database;
  final int id;
  final String type;

  const PostgresqlDBDeleteCheck({
    this.database = '',
    this.id = 0,
    this.type = '',
  });

  factory PostgresqlDBDeleteCheck.fromJson(Map<String, dynamic> json) {
    return PostgresqlDBDeleteCheck(
      database: json['database'] as String? ?? '',
      id: (json['id'] as num?)?.toInt() ?? 0,
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'id': id,
      'type': type,
  };
}

class PostgresqlDBSearch {
  final String database;
  final String info;
  final String order;
  final String orderBy;
  final int page;
  final int pageSize;

  const PostgresqlDBSearch({
    this.database = '',
    this.info = '',
    this.order = '',
    this.orderBy = '',
    this.page = 0,
    this.pageSize = 0,
  });

  factory PostgresqlDBSearch.fromJson(Map<String, dynamic> json) {
    return PostgresqlDBSearch(
      database: json['database'] as String? ?? '',
      info: json['info'] as String? ?? '',
      order: json['order'] as String? ?? '',
      orderBy: json['orderBy'] as String? ?? '',
      page: (json['page'] as num?)?.toInt() ?? 0,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'info': info,
      'order': order,
      'orderBy': orderBy,
      'page': page,
      'pageSize': pageSize,
  };
}

class PostgresqlLoadDB {
  final String database;
  final String from;
  final String type;

  const PostgresqlLoadDB({
    this.database = '',
    this.from = '',
    this.type = '',
  });

  factory PostgresqlLoadDB.fromJson(Map<String, dynamic> json) {
    return PostgresqlLoadDB(
      database: json['database'] as String? ?? '',
      from: json['from'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'from': from,
      'type': type,
  };
}

class RedisConf {
  final String containerName;
  final String database;
  final String maxclients;
  final String maxmemory;
  final String name;
  final int port;
  final String requirepass;
  final String timeout;

  const RedisConf({
    this.containerName = '',
    this.database = '',
    this.maxclients = '',
    this.maxmemory = '',
    this.name = '',
    this.port = 0,
    this.requirepass = '',
    this.timeout = '',
  });

  factory RedisConf.fromJson(Map<String, dynamic> json) {
    return RedisConf(
      containerName: json['containerName'] as String? ?? '',
      database: json['database'] as String? ?? '',
      maxclients: json['maxclients'] as String? ?? '',
      maxmemory: json['maxmemory'] as String? ?? '',
      name: json['name'] as String? ?? '',
      port: (json['port'] as num?)?.toInt() ?? 0,
      requirepass: json['requirepass'] as String? ?? '',
      timeout: json['timeout'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'containerName': containerName,
      'database': database,
      'maxclients': maxclients,
      'maxmemory': maxmemory,
      'name': name,
      'port': port,
      'requirepass': requirepass,
      'timeout': timeout,
  };
}

class RedisConfPersistenceUpdate {
  final String appendfsync;
  final String appendonly;
  final String database;
  final String dbType;
  final String save;
  final String type;

  const RedisConfPersistenceUpdate({
    this.appendfsync = '',
    this.appendonly = '',
    this.database = '',
    this.dbType = '',
    this.save = '',
    this.type = '',
  });

  factory RedisConfPersistenceUpdate.fromJson(Map<String, dynamic> json) {
    return RedisConfPersistenceUpdate(
      appendfsync: json['appendfsync'] as String? ?? '',
      appendonly: json['appendonly'] as String? ?? '',
      database: json['database'] as String? ?? '',
      dbType: json['dbType'] as String? ?? '',
      save: json['save'] as String? ?? '',
      type: json['type'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'appendfsync': appendfsync,
      'appendonly': appendonly,
      'database': database,
      'dbType': dbType,
      'save': save,
      'type': type,
  };
}

class RedisConfUpdate {
  final String database;
  final String dbType;
  final String maxclients;
  final String maxmemory;
  final String timeout;

  const RedisConfUpdate({
    this.database = '',
    this.dbType = '',
    this.maxclients = '',
    this.maxmemory = '',
    this.timeout = '',
  });

  factory RedisConfUpdate.fromJson(Map<String, dynamic> json) {
    return RedisConfUpdate(
      database: json['database'] as String? ?? '',
      dbType: json['dbType'] as String? ?? '',
      maxclients: json['maxclients'] as String? ?? '',
      maxmemory: json['maxmemory'] as String? ?? '',
      timeout: json['timeout'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'database': database,
      'dbType': dbType,
      'maxclients': maxclients,
      'maxmemory': maxmemory,
      'timeout': timeout,
  };
}

class RedisPersistence {
  final String appendfsync;
  final String appendonly;
  final String database;
  final String save;

  const RedisPersistence({
    this.appendfsync = '',
    this.appendonly = '',
    this.database = '',
    this.save = '',
  });

  factory RedisPersistence.fromJson(Map<String, dynamic> json) {
    return RedisPersistence(
      appendfsync: json['appendfsync'] as String? ?? '',
      appendonly: json['appendonly'] as String? ?? '',
      database: json['database'] as String? ?? '',
      save: json['save'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'appendfsync': appendfsync,
      'appendonly': appendonly,
      'database': database,
      'save': save,
  };
}

class RedisStatus {
  final String connectedClients;
  final String database;
  final String instantaneousOpsPerSec;
  final String keyspaceHits;
  final String keyspaceMisses;
  final String latestForkUsec;
  final String memFragmentationRatio;
  final String tcpPort;
  final String totalCommandsProcessed;
  final String totalConnectionsReceived;
  final String uptimeInDays;
  final String usedMemory;
  final String usedMemoryPeak;
  final String usedMemoryRss;

  const RedisStatus({
    this.connectedClients = '',
    this.database = '',
    this.instantaneousOpsPerSec = '',
    this.keyspaceHits = '',
    this.keyspaceMisses = '',
    this.latestForkUsec = '',
    this.memFragmentationRatio = '',
    this.tcpPort = '',
    this.totalCommandsProcessed = '',
    this.totalConnectionsReceived = '',
    this.uptimeInDays = '',
    this.usedMemory = '',
    this.usedMemoryPeak = '',
    this.usedMemoryRss = '',
  });

  factory RedisStatus.fromJson(Map<String, dynamic> json) {
    return RedisStatus(
      connectedClients: json['connected_clients'] as String? ?? '',
      database: json['database'] as String? ?? '',
      instantaneousOpsPerSec: json['instantaneous_ops_per_sec'] as String? ?? '',
      keyspaceHits: json['keyspace_hits'] as String? ?? '',
      keyspaceMisses: json['keyspace_misses'] as String? ?? '',
      latestForkUsec: json['latest_fork_usec'] as String? ?? '',
      memFragmentationRatio: json['mem_fragmentation_ratio'] as String? ?? '',
      tcpPort: json['tcp_port'] as String? ?? '',
      totalCommandsProcessed: json['total_commands_processed'] as String? ?? '',
      totalConnectionsReceived: json['total_connections_received'] as String? ?? '',
      uptimeInDays: json['uptime_in_days'] as String? ?? '',
      usedMemory: json['used_memory'] as String? ?? '',
      usedMemoryPeak: json['used_memory_peak'] as String? ?? '',
      usedMemoryRss: json['used_memory_rss'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
      'connected_clients': connectedClients,
      'database': database,
      'instantaneous_ops_per_sec': instantaneousOpsPerSec,
      'keyspace_hits': keyspaceHits,
      'keyspace_misses': keyspaceMisses,
      'latest_fork_usec': latestForkUsec,
      'mem_fragmentation_ratio': memFragmentationRatio,
      'tcp_port': tcpPort,
      'total_commands_processed': totalCommandsProcessed,
      'total_connections_received': totalConnectionsReceived,
      'uptime_in_days': uptimeInDays,
      'used_memory': usedMemory,
      'used_memory_peak': usedMemoryPeak,
      'used_memory_rss': usedMemoryRss,
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
