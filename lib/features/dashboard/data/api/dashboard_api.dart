// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/dashboard_models.dart';

class DashboardApi {
  final DioClient client;

  const DashboardApi(this.client);

  /// Load monitor data
  Future<ApiResponse<MonitorGPUData>> postAiGpuSearch(MonitorGPUSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<MonitorGPUData>('/ai/gpu/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => MonitorGPUData.fromJson(d as Map<String, dynamic>));
  }

  /// Load app launcher
  Future<ApiResponse<void>> getAppLauncher({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/dashboard/app/launcher', queryParameters: queryParameters);
  }

  /// Load app launcher options
  Future<ApiResponse<void>> postAppLauncherOption(SearchByFilter request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/dashboard/app/launcher/option', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update app Launcher
  Future<ApiResponse<void>> postAppLauncherShow(SettingUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/dashboard/app/launcher/show', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load dashboard base info
  Future<ApiResponse<DashboardBase>> getBaseIooptionNetoption(String ioOption, String netOption, {Map<String, dynamic>? queryParameters}) async {
    return client.get<DashboardBase>('/dashboard/base/$ioOption/$netOption', queryParameters: queryParameters, fromData: (d) => DashboardBase.fromJson(d as Map<String, dynamic>));
  }

  /// Load os info
  Future<ApiResponse<OsInfo>> getBaseOs({Map<String, dynamic>? queryParameters}) async {
    return client.get<OsInfo>('/dashboard/base/os', queryParameters: queryParameters, fromData: (d) => OsInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Load dashboard current info
  Future<ApiResponse<DashboardCurrent>> getCurrentIooptionNetoption(String ioOption, String netOption, {Map<String, dynamic>? queryParameters}) async {
    return client.get<DashboardCurrent>('/dashboard/current/$ioOption/$netOption', queryParameters: queryParameters, fromData: (d) => DashboardCurrent.fromJson(d as Map<String, dynamic>));
  }

  /// Load dashboard current info for node
  Future<ApiResponse<NodeCurrent>> getCurrentNode({Map<String, dynamic>? queryParameters}) async {
    return client.get<NodeCurrent>('/dashboard/current/node', queryParameters: queryParameters, fromData: (d) => NodeCurrent.fromJson(d as Map<String, dynamic>));
  }

  /// Load top cpu processes
  Future<ApiResponse<List<Process>>> getCurrentTopCpu({Map<String, dynamic>? queryParameters}) async {
    return client.get<List<Process>>(
      '/dashboard/current/top/cpu',
      queryParameters: queryParameters,
      fromData: (d) => (d as List<dynamic>?)?.map((e) => Process.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  /// Load top memory processes
  Future<ApiResponse<List<Process>>> getCurrentTopMem({Map<String, dynamic>? queryParameters}) async {
    return client.get<List<Process>>(
      '/dashboard/current/top/mem',
      queryParameters: queryParameters,
      fromData: (d) => (d as List<dynamic>?)?.map((e) => Process.fromJson(e as Map<String, dynamic>)).toList() ?? const [],
    );
  }

  /// Update quick jump
  Future<ApiResponse<void>> postQuickChange(ChangeQuicks request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/dashboard/quick/change', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load quick jump options
  Future<ApiResponse<void>> getQuickOption({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/dashboard/quick/option', queryParameters: queryParameters);
  }

  /// System restart
  Future<ApiResponse<void>> postSystemRestartOperation(String operation, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/dashboard/system/restart/$operation', queryParameters: queryParameters);
  }

  /// Check health
  Future<ApiResponse<void>> getHealthCheck({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/health/check', queryParameters: queryParameters);
  }

  /// Clean monitor data
  Future<ApiResponse<void>> postHostsMonitorClean({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/monitor/clean', queryParameters: queryParameters);
  }

  /// Get IO options
  Future<ApiResponse<void>> getHostsMonitorIooptions({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/hosts/monitor/iooptions', queryParameters: queryParameters);
  }

  /// Get network options
  Future<ApiResponse<void>> getHostsMonitorNetoptions({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/hosts/monitor/netoptions', queryParameters: queryParameters);
  }

  /// Load monitor data
  Future<ApiResponse<void>> postHostsMonitorSearch(MonitorSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/monitor/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load monitor setting
  Future<ApiResponse<MonitorSetting>> getHostsMonitorSetting({Map<String, dynamic>? queryParameters}) async {
    return client.get<MonitorSetting>('/hosts/monitor/setting', queryParameters: queryParameters, fromData: (d) => MonitorSetting.fromJson(d as Map<String, dynamic>));
  }

  /// Update monitor setting
  Future<ApiResponse<void>> postHostsMonitorSettingUpdate(MonitorSettingUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/monitor/setting/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

}