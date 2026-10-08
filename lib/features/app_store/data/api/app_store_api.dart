// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/app_store_models.dart';

class AppStoreApi {
  final DioClient client;

  const AppStoreApi(this.client);

  /// Search app by key
  Future<ApiResponse<AppDTO>> getAppsKey(String key, {Map<String, dynamic>? queryParameters}) async {
    return client.get<AppDTO>('/apps/$key', queryParameters: queryParameters, fromData: (d) => AppDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Get app list update
  Future<ApiResponse<AppUpdateRes>> getAppsCheckupdate({Map<String, dynamic>? queryParameters}) async {
    return client.get<AppUpdateRes>('/apps/checkupdate', queryParameters: queryParameters, fromData: (d) => AppUpdateRes.fromJson(d as Map<String, dynamic>));
  }

  /// Search app detail by appid
  Future<ApiResponse<AppDetailDTO>> getAppsDetailAppidVersionType(String appId, String version, String type, {Map<String, dynamic>? queryParameters}) async {
    return client.get<AppDetailDTO>('/apps/detail/$appId/$version/$type', queryParameters: queryParameters, fromData: (d) => AppDetailDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Search app detail by appkey and version
  Future<ApiResponse<AppDetailSimpleDTO>> getAppsDetailNodeAppkeyVersion(String appKey, String version, {Map<String, dynamic>? queryParameters}) async {
    return client.get<AppDetailSimpleDTO>('/apps/detail/node/$appKey/$version', queryParameters: queryParameters, fromData: (d) => AppDetailSimpleDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Get app detail by id
  Future<ApiResponse<AppDetailDTO>> getAppsDetailsId(String id, {Map<String, dynamic>? queryParameters}) async {
    return client.get<AppDetailDTO>('/apps/details/$id', queryParameters: queryParameters, fromData: (d) => AppDetailDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Get app icon by app_id
  Future<ApiResponse<void>> getAppsIconKey(String key, {Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/apps/icon/$key', queryParameters: queryParameters);
  }

  /// Cancel Ignore Upgrade App
  Future<ApiResponse<void>> postAppsIgnoredCancel(ReqWithID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/apps/ignored/cancel', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List Upgrade Ignored App
  Future<ApiResponse<void>> getAppsIgnoredDetail({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/apps/ignored/detail', queryParameters: queryParameters);
  }

  /// Install app
  Future<ApiResponse<AppInstall>> postAppsInstall(AppInstallCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AppInstall>('/apps/install', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AppInstall.fromJson(d as Map<String, dynamic>));
  }

  /// Check app installed
  Future<ApiResponse<AppInstalledCheck>> postAppsInstalledCheck(AppInstalledInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AppInstalledCheck>('/apps/installed/check', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AppInstalledCheck.fromJson(d as Map<String, dynamic>));
  }

  /// Search default config by key
  Future<ApiResponse<void>> postAppsInstalledConf(OperationWithNameAndType request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/apps/installed/conf', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update app config
  Future<ApiResponse<void>> postAppsInstalledConfigUpdate(AppConfigUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/apps/installed/config/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Search app password by key
  Future<ApiResponse<DatabaseConn>> postAppsInstalledConninfo(OperationWithNameAndType request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<DatabaseConn>('/apps/installed/conninfo', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => DatabaseConn.fromJson(d as Map<String, dynamic>));
  }

  /// Check before delete
  Future<ApiResponse<void>> getAppsInstalledDeleteCheckAppinstallid(String appInstallId, {Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/apps/installed/delete/check/$appInstallId', queryParameters: queryParameters);
  }

  /// Ignore Upgrade App
  Future<ApiResponse<void>> postAppsInstalledIgnore(AppIgnoreUpgradeReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/apps/installed/ignore', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get app install info
  Future<ApiResponse<AppInstallInfo>> getAppsInstalledInfoAppinstallid(String appInstallId, {Map<String, dynamic>? queryParameters}) async {
    return client.get<AppInstallInfo>('/apps/installed/info/$appInstallId', queryParameters: queryParameters, fromData: (d) => AppInstallInfo.fromJson(d as Map<String, dynamic>));
  }

  /// List app installed
  Future<ApiResponse<void>> getAppsInstalledList({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/apps/installed/list', queryParameters: queryParameters);
  }

  /// Search app port by key
  Future<ApiResponse<void>> postAppsInstalledLoadport(OperationWithNameAndType request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/apps/installed/loadport', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Operate installed app
  Future<ApiResponse<void>> postAppsInstalledOp(AppInstalledOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/apps/installed/op', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Search params by appInstallId
  Future<ApiResponse<AppConfig>> getAppsInstalledParamsAppinstallid(String appInstallId, {Map<String, dynamic>? queryParameters}) async {
    return client.get<AppConfig>('/apps/installed/params/$appInstallId', queryParameters: queryParameters, fromData: (d) => AppConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Change app params
  Future<ApiResponse<void>> postAppsInstalledParamsUpdate(AppInstalledUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/apps/installed/params/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Change app port
  Future<ApiResponse<void>> postAppsInstalledPortChange(PortUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/apps/installed/port/change', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page app installed
  Future<ApiResponse<PageResult>> postAppsInstalledSearch(AppInstalledSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/apps/installed/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Update app install sort
  Future<ApiResponse<void>> postAppsInstalledSortUpdate(AppInstallSort request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/apps/installed/sort/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Sync app installed
  Future<ApiResponse<void>> postAppsInstalledSync({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/apps/installed/sync', queryParameters: queryParameters);
  }

  /// Search app update version by install id
  Future<ApiResponse<void>> postAppsInstalledUpdateVersions({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/apps/installed/update/versions', queryParameters: queryParameters);
  }

  /// List apps
  Future<ApiResponse<AppRes>> postAppsSearch(AppSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AppRes>('/apps/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AppRes.fromJson(d as Map<String, dynamic>));
  }

  /// Search app service by key
  Future<ApiResponse<void>> getAppsServicesKey(String key, {Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/apps/services/$key', queryParameters: queryParameters);
  }

  /// Sync local  app list
  Future<ApiResponse<void>> postAppsSyncLocal({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/apps/sync/local', queryParameters: queryParameters);
  }

  /// Sync remote app list
  Future<ApiResponse<void>> postAppsSyncRemote({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/apps/sync/remote', queryParameters: queryParameters);
  }

  /// Get app tags
  Future<ApiResponse<void>> getAppsTags({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/apps/tags', queryParameters: queryParameters);
  }

  /// Get appstore config
  Future<ApiResponse<AppstoreConfig>> getSettingsAppsStoreConfig({Map<String, dynamic>? queryParameters}) async {
    return client.get<AppstoreConfig>('/core/settings/apps/store/config', queryParameters: queryParameters, fromData: (d) => AppstoreConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update appstore config
  Future<ApiResponse<void>> postSettingsAppsStoreUpdate(AppstoreUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/apps/store/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

}