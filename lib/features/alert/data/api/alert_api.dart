// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/alert_models.dart';

class AlertApi {
  final DioClient client;

  const AlertApi(this.client);

  /// Create alert
  Future<ApiResponse<void>> postAlert(AlertCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/alert', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get clams
  Future<ApiResponse<void>> getClamsList({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/alert/clams/list', queryParameters: queryParameters);
  }

  /// Delete alert config
  Future<ApiResponse<void>> postConfigDel(DeleteRequest request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/alert/config/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get alert config
  Future<ApiResponse<void>> postConfigInfo({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/alert/config/info', queryParameters: queryParameters);
  }

  /// Page alert config
  Future<ApiResponse<void>> postConfigSearch(AlertConfigPageReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/alert/config/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Test alert config
  Future<ApiResponse<void>> postConfigTest(AlertConfigTest request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/alert/config/test', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update alert config
  Future<ApiResponse<void>> postConfigUpdate(AlertConfigUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/alert/config/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get cron jobs
  Future<ApiResponse<void>> postCronjobList(CronJobReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/alert/cronjob/list', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete alert
  Future<ApiResponse<void>> postDel(DeleteRequest request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/alert/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get disks
  Future<ApiResponse<void>> getDisksList({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/alert/disks/list', queryParameters: queryParameters);
  }

  /// Clean alert logs
  Future<ApiResponse<void>> postLogsClean({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/alert/logs/clean', queryParameters: queryParameters);
  }

  /// Page alert logs
  Future<ApiResponse<void>> postLogsSearch(AlertLogSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/alert/logs/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page alert
  Future<ApiResponse<void>> postSearch(AlertSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/alert/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update alert status
  Future<ApiResponse<void>> postStatus(AlertUpdateStatus request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/alert/status', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update alert
  Future<ApiResponse<void>> postUpdate(AlertUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/alert/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

}