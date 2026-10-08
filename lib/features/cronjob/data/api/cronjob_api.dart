// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/cronjob_models.dart';

class CronjobApi {
  final DioClient client;

  const CronjobApi(this.client);

  /// Add script
  Future<ApiResponse<void>> postScript(ScriptOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/script', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete script
  Future<ApiResponse<void>> postScriptDel(OperateByIDs request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/script/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Run script
  Future<ApiResponse<void>> getScriptRun({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/core/script/run', queryParameters: queryParameters);
  }

  /// Page script
  Future<ApiResponse<PageResult>> postScriptSearch(SearchPageWithGroup request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/core/script/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Sync script from remote
  Future<ApiResponse<void>> postScriptSync(OperateByTaskID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/script/sync', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update script
  Future<ApiResponse<void>> postScriptUpdate(ScriptOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/script/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create cronjob
  Future<ApiResponse<void>> postCronjobs(CronjobOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/cronjobs', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete cronjob
  Future<ApiResponse<void>> postCronjobsDel(CronjobBatchDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/cronjobs/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Export cronjob list
  Future<ApiResponse<void>> postCronjobsExport(OperateByIDs request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/cronjobs/export', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update cronjob group
  Future<ApiResponse<void>> postCronjobsGroupUpdate(ChangeGroup request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/cronjobs/group/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Handle cronjob once
  Future<ApiResponse<void>> postCronjobsHandle(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/cronjobs/handle', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Import cronjob list
  Future<ApiResponse<void>> postCronjobsImport(CronjobImport request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/cronjobs/import', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load cronjob info
  Future<ApiResponse<void>> postCronjobsLoadInfo(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/cronjobs/load/info', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load cronjob spec time
  Future<ApiResponse<void>> postCronjobsNext(CronjobSpec request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/cronjobs/next', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Clean job records
  Future<ApiResponse<void>> postCronjobsRecordsClean(CronjobClean request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/cronjobs/records/clean', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load Cronjob record log
  Future<ApiResponse<void>> postCronjobsRecordsLog(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/cronjobs/records/log', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load script options
  Future<ApiResponse<void>> getCronjobsScriptOptions({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/cronjobs/script/options', queryParameters: queryParameters);
  }

  /// Page cronjobs
  Future<ApiResponse<PageResult>> postCronjobsSearch(PageCronjob request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/cronjobs/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Page job records
  Future<ApiResponse<PageResult>> postCronjobsSearchRecords(SearchRecord request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/cronjobs/search/records', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Update cronjob status
  Future<ApiResponse<void>> postCronjobsStatus(CronjobUpdateStatus request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/cronjobs/status', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Handle stop job
  Future<ApiResponse<void>> postCronjobsStop(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/cronjobs/stop', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update cronjob
  Future<ApiResponse<void>> postCronjobsUpdate(CronjobOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/cronjobs/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

}