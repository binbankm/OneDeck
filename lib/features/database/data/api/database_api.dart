// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/database_models.dart';

class DatabaseApi {
  final DioClient client;

  const DatabaseApi(this.client);

  /// Create mysql database
  Future<ApiResponse<void>> postDatabases(MysqlDBCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Change mysql root access
  Future<ApiResponse<void>> postDatabasesChangeAccess(ChangeDBInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/change/access', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Change mysql root password
  Future<ApiResponse<void>> postDatabasesChangePassword(ChangeDBInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/change/password', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load base info
  Future<ApiResponse<DBBaseInfo>> postDatabasesCommonInfo(OperationWithNameAndType request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<DBBaseInfo>('/databases/common/info', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => DBBaseInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Load Database conf
  Future<ApiResponse<void>> postDatabasesCommonLoadFile(OperationWithNameAndType request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/common/load/file', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update conf by upload file
  Future<ApiResponse<void>> postDatabasesCommonUpdateConf(DBConfUpdateByFile request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/common/update/conf', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create database
  Future<ApiResponse<void>> postDatabasesDb(DatabaseCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/db', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get databases
  Future<ApiResponse<DatabaseInfo>> getDatabasesDbName(String name, {Map<String, dynamic>? queryParameters}) async {
    return client.get<DatabaseInfo>('/databases/db/$name', queryParameters: queryParameters, fromData: (d) => DatabaseInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Check database
  Future<ApiResponse<void>> postDatabasesDbCheck(DatabaseCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/db/check', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete database
  Future<ApiResponse<void>> postDatabasesDbDel(DatabaseDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/db/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Check before delete remote database
  Future<ApiResponse<void>> postDatabasesDbDelCheck(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/db/del/check', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List databases
  Future<ApiResponse<void>> getDatabasesDbItemType(String type, {Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/databases/db/item/$type', queryParameters: queryParameters);
  }

  /// List databases
  Future<ApiResponse<void>> getDatabasesDbListType(String type, {Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/databases/db/list/$type', queryParameters: queryParameters);
  }

  /// Page databases
  Future<ApiResponse<PageResult>> postDatabasesDbSearch(DatabaseSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/databases/db/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Update database
  Future<ApiResponse<void>> postDatabasesDbUpdate(DatabaseUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/db/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete mysql database
  Future<ApiResponse<void>> postDatabasesDel(MysqlDBDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Check before delete mysql database
  Future<ApiResponse<void>> postDatabasesDelCheck(MysqlDBDeleteCheck request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/del/check', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update mysql database description
  Future<ApiResponse<void>> postDatabasesDescriptionUpdate(UpdateDescription request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/description/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List mysql database format collation options
  Future<ApiResponse<void>> postDatabasesFormatOptions(OperationWithName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/format/options', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Grant mysql user
  Future<ApiResponse<void>> postDatabasesGrants(MysqlGrantCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/grants', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Revoke mysql grant
  Future<ApiResponse<void>> postDatabasesGrantsDel(MysqlGrantDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/grants/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List mysql grants
  Future<ApiResponse<void>> postDatabasesGrantsSearch(MysqlUserSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/grants/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List mysql grant summary
  Future<ApiResponse<void>> postDatabasesGrantsSummary(MysqlGrantSummarySearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/grants/summary', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load mysql database from remote
  Future<ApiResponse<void>> postDatabasesLoad(MysqlLoadDB request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/load', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create mongodb database
  Future<ApiResponse<void>> postDatabasesMongodb(MongodbDBCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/mongodb', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Bind mongodb database user info
  Future<ApiResponse<void>> postDatabasesMongodbBind(MongodbBind request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/mongodb/bind', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete mongodb database
  Future<ApiResponse<void>> postDatabasesMongodbDel(MongodbDBDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/mongodb/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Check before delete mongodb database
  Future<ApiResponse<void>> postDatabasesMongodbDelCheck(MongodbDBDeleteCheck request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/mongodb/del/check', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update mongodb database description
  Future<ApiResponse<void>> postDatabasesMongodbDescription(UpdateDescription request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/mongodb/description', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load mongodb database from remote
  Future<ApiResponse<void>> postDatabasesMongodbLoad(MongodbLoadDB request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/mongodb/load', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Change mongodb database password
  Future<ApiResponse<void>> postDatabasesMongodbPassword(MongodbPassword request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/mongodb/password', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load mongodb privileges
  Future<ApiResponse<void>> postDatabasesMongodbPrivileges(MongodbPrivilegesLoad request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/mongodb/privileges', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Change mongodb privileges
  Future<ApiResponse<void>> postDatabasesMongodbPrivilegesChange(MongodbPrivileges request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/mongodb/privileges/change', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Change mongodb root password
  Future<ApiResponse<void>> postDatabasesMongodbRootPassword(ChangeDBInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/mongodb/root/password', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page mongodb databases
  Future<ApiResponse<PageResult>> postDatabasesMongodbSearch(MongodbDBSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/databases/mongodb/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Create postgresql database
  Future<ApiResponse<void>> postDatabasesPg(PostgresqlDBCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/pg', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load postgresql database from remote
  Future<ApiResponse<void>> postDatabasesPgLoad(String database, PostgresqlLoadDB request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/pg/$database/load', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Bind postgresql user
  Future<ApiResponse<void>> postDatabasesPgBind(PostgresqlBindUser request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/pg/bind', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete postgresql database
  Future<ApiResponse<void>> postDatabasesPgDel(PostgresqlDBDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/pg/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Check before delete postgresql database
  Future<ApiResponse<void>> postDatabasesPgDelCheck(PostgresqlDBDeleteCheck request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/pg/del/check', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update postgresql database description
  Future<ApiResponse<void>> postDatabasesPgDescription(UpdateDescription request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/pg/description', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Change postgresql password
  Future<ApiResponse<void>> postDatabasesPgPassword(ChangeDBInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/pg/password', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Change postgresql privileges
  Future<ApiResponse<void>> postDatabasesPgPrivileges(ChangeDBInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/pg/privileges', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page postgresql databases
  Future<ApiResponse<PageResult>> postDatabasesPgSearch(PostgresqlDBSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/databases/pg/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Check has cli
  Future<ApiResponse<void>> getDatabasesRedisCheck({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/databases/redis/check', queryParameters: queryParameters);
  }

  /// Load redis conf
  Future<ApiResponse<RedisConf>> postDatabasesRedisConf(LoadRedisStatus request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<RedisConf>('/databases/redis/conf', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => RedisConf.fromJson(d as Map<String, dynamic>));
  }

  /// Update redis conf
  Future<ApiResponse<void>> postDatabasesRedisConfUpdate(RedisConfUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/redis/conf/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Install redis-cli
  Future<ApiResponse<void>> postDatabasesRedisInstallCli({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/redis/install/cli', queryParameters: queryParameters);
  }

  /// Change redis password
  Future<ApiResponse<void>> postDatabasesRedisPassword(ChangeRedisPass request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/redis/password', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load redis persistence conf
  Future<ApiResponse<RedisPersistence>> postDatabasesRedisPersistenceConf(LoadRedisStatus request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<RedisPersistence>('/databases/redis/persistence/conf', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => RedisPersistence.fromJson(d as Map<String, dynamic>));
  }

  /// Update redis persistence conf
  Future<ApiResponse<void>> postDatabasesRedisPersistenceUpdate(RedisConfPersistenceUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/redis/persistence/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load redis status info
  Future<ApiResponse<RedisStatus>> postDatabasesRedisStatus(LoadRedisStatus request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<RedisStatus>('/databases/redis/status', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => RedisStatus.fromJson(d as Map<String, dynamic>));
  }

  /// Load mysql remote access
  Future<ApiResponse<void>> postDatabasesRemote(OperationWithNameAndType request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/remote', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page mysql databases
  Future<ApiResponse<PageResult>> postDatabasesSearch(MysqlDBSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/databases/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Load mysql status info
  Future<ApiResponse<MysqlStatus>> postDatabasesStatus(OperationWithNameAndType request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<MysqlStatus>('/databases/status', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => MysqlStatus.fromJson(d as Map<String, dynamic>));
  }

  /// Create mysql user
  Future<ApiResponse<void>> postDatabasesUsers(MysqlUserCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/users', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete mysql user
  Future<ApiResponse<void>> postDatabasesUsersDel(MysqlUserDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/users/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Change mysql user password
  Future<ApiResponse<void>> postDatabasesUsersPassword(MysqlUserPassword request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/users/password', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Save mysql user password locally
  Future<ApiResponse<void>> postDatabasesUsersPasswordSave(MysqlUserPassword request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/users/password/save', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List mysql users
  Future<ApiResponse<void>> postDatabasesUsersSearch(MysqlUserSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/users/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update mysql user
  Future<ApiResponse<void>> postDatabasesUsersUpdate(MysqlUserUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/users/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load mysql variables info
  Future<ApiResponse<MysqlVariables>> postDatabasesVariables(OperationWithNameAndType request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<MysqlVariables>('/databases/variables', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => MysqlVariables.fromJson(d as Map<String, dynamic>));
  }

  /// Update mysql variables
  Future<ApiResponse<void>> postDatabasesVariablesUpdate(MysqlVariablesUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/databases/variables/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

}