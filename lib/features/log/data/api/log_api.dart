// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/log_models.dart';

class LogApi {
  final DioClient client;

  const LogApi(this.client);

  /// Clean operation logs
  Future<ApiResponse<PageResult>> postLogsClean(CleanLog request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/core/logs/clean', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Page login logs
  Future<ApiResponse<PageResult>> postLogsLogin(SearchLgLogWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/core/logs/login', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Page operation logs
  Future<ApiResponse<PageResult>> postLogsOperation(SearchOpLogWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/core/logs/operation', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Load system log files
  Future<ApiResponse<void>> getLogsSystemFiles({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/logs/system/files', queryParameters: queryParameters);
  }

  /// Read host logs
  Future<ApiResponse<SystemLogRes>> postLogsSystemRead(SystemLogReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<SystemLogRes>('/logs/system/read', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => SystemLogRes.fromJson(d as Map<String, dynamic>));
  }

  /// List running host services
  Future<ApiResponse<void>> getLogsSystemServices({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/logs/system/services', queryParameters: queryParameters);
  }

  /// Get host system log status
  Future<ApiResponse<SystemLogStatus>> getLogsSystemStatus({Map<String, dynamic>? queryParameters}) async {
    return client.get<SystemLogStatus>('/logs/system/status', queryParameters: queryParameters, fromData: (d) => SystemLogStatus.fromJson(d as Map<String, dynamic>));
  }

  /// Get the number of executing tasks
  Future<ApiResponse<void>> getLogsTasksExecutingCount({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/logs/tasks/executing/count', queryParameters: queryParameters);
  }

  /// Read task log by Line
  Future<ApiResponse<FileLineContent>> postLogsTasksRead(TaskLogReadReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FileLineContent>('/logs/tasks/read', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FileLineContent.fromJson(d as Map<String, dynamic>));
  }

  /// Page task logs
  Future<ApiResponse<PageResult>> postLogsTasksSearch(SearchTaskLogReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/logs/tasks/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

}