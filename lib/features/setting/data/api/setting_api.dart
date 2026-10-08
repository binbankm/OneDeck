// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/setting_models.dart';

class SettingApi {
  final DioClient client;

  const SettingApi(this.client);

  /// Create backup account
  Future<ApiResponse<void>> postBackups(BackupOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Backup system data
  Future<ApiResponse<void>> postBackupsBackup(CommonBackup request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/backup', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List buckets
  Future<ApiResponse<void>> postBackupsBuckets(ForBuckets request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/buckets', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Check backup used
  Future<ApiResponse<void>> getBackupsCheckName({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/backups/check/{name}', queryParameters: queryParameters);
  }

  /// Check backup account
  Future<ApiResponse<void>> postBackupsConnCheck(BackupOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/conn/check', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete backup account
  Future<ApiResponse<void>> postBackupsDel(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// get local backup dir
  Future<ApiResponse<void>> getBackupsLocal({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/backups/local', queryParameters: queryParameters);
  }

  /// Load backup account options
  Future<ApiResponse<void>> getBackupsOptions({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/backups/options', queryParameters: queryParameters);
  }

  /// Delete backup record
  Future<ApiResponse<void>> postBackupsRecordDel(BatchDeleteReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/record/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update backup record description
  Future<ApiResponse<void>> postBackupsRecordDescriptionUpdate(UpdateDescription request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/record/description/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Download backup record
  Future<ApiResponse<void>> postBackupsRecordDownload(DownloadRecord request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/record/download', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page backup records
  Future<ApiResponse<PageResult>> postBackupsRecordSearch(RecordSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/backups/record/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Page backup records by cronjob
  Future<ApiResponse<PageResult>> postBackupsRecordSearchBycronjob(RecordSearchByCronjob request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/backups/record/search/bycronjob', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Load backup record size
  Future<ApiResponse<void>> postBackupsRecordSize(SearchForSize request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/record/size', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Recover system data
  Future<ApiResponse<void>> postBackupsRecover(CommonRecover request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/recover', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Recover system data by upload
  Future<ApiResponse<void>> postBackupsRecoverByupload(CommonRecover request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/recover/byupload', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Refresh token
  Future<ApiResponse<void>> postBackupsRefreshToken(BackupOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/refresh/token', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Search backup accounts with page
  Future<ApiResponse<void>> postBackupsSearch(SearchPageWithType request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List files from backup accounts
  Future<ApiResponse<void>> postBackupsSearchFiles(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/search/files', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update backup account
  Future<ApiResponse<void>> postBackupsUpdate(BackupOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Upload file for recover
  Future<ApiResponse<void>> postBackupsUpload(UploadForRecover request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/backups/upload', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load mfa info
  Future<ApiResponse<MfaOtp>> postAuthMfa(MfaCredential request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<MfaOtp>('/core/auth/mfa', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => MfaOtp.fromJson(d as Map<String, dynamic>));
  }

  /// Bind mfa
  Future<ApiResponse<void>> postAuthMfaBind(MfaCredential request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/auth/mfa/bind', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Close mfa
  Future<ApiResponse<void>> postAuthMfaClose({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/auth/mfa/close', queryParameters: queryParameters);
  }

  /// Create backup account
  Future<ApiResponse<void>> postBackups2(BackupOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/backups', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load backup account base info
  Future<ApiResponse<BackupClientInfo>> getBackupsClientClienttype(String clientType, {Map<String, dynamic>? queryParameters}) async {
    return client.get<BackupClientInfo>('/core/backups/client/$clientType', queryParameters: queryParameters, fromData: (d) => BackupClientInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Delete backup account
  Future<ApiResponse<void>> postBackupsDel2(OperateByName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/backups/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Refresh token
  Future<ApiResponse<void>> postBackupsRefreshToken2(OperateByName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/backups/refresh/token', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update backup account
  Future<ApiResponse<void>> postBackupsUpdate2(BackupOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/backups/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create group
  Future<ApiResponse<void>> postGroups(GroupCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/groups', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete group
  Future<ApiResponse<void>> postGroupsDel(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/groups/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List groups
  Future<ApiResponse<void>> postGroupsSearch(GroupSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/groups/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update group
  Future<ApiResponse<void>> postGroupsUpdate(GroupUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/groups/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update system bind info
  Future<ApiResponse<void>> postSettingsBindUpdate(BindInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/bind/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load system address
  Future<ApiResponse<void>> getSettingsInterface({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/core/settings/interface', queryParameters: queryParameters);
  }

  /// Load dashboard memo
  Future<ApiResponse<void>> getSettingsMemo({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/core/settings/memo', queryParameters: queryParameters);
  }

  /// Update dashboard memo
  Future<ApiResponse<void>> postSettingsMemo(MemoUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/memo', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Default menu
  Future<ApiResponse<void>> postSettingsMenuDefault({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/menu/default', queryParameters: queryParameters);
  }

  /// Update system setting
  Future<ApiResponse<void>> postSettingsMenuUpdate(SettingUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/menu/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update system port
  Future<ApiResponse<void>> postSettingsPortUpdate(PortUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/port/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update proxy setting
  Future<ApiResponse<void>> postSettingsProxyUpdate(ProxyUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/proxy/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load system setting info
  Future<ApiResponse<SettingInfo>> postSettingsSearch({Map<String, dynamic>? queryParameters}) async {
    return client.post<SettingInfo>('/core/settings/search', queryParameters: queryParameters, fromData: (d) => SettingInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Load system available status
  Future<ApiResponse<void>> getSettingsSearchAvailable({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/core/settings/search/available', queryParameters: queryParameters);
  }

  /// Load base system setting info
  Future<ApiResponse<SettingBaseInfo>> postSettingsSearchBase({Map<String, dynamic>? queryParameters}) async {
    return client.post<SettingBaseInfo>('/core/settings/search/base', queryParameters: queryParameters, fromData: (d) => SettingBaseInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Download system cert
  Future<ApiResponse<void>> postSettingsSslDownload({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/ssl/download', queryParameters: queryParameters);
  }

  /// Load system cert info
  Future<ApiResponse<SSLInfo>> getSettingsSslInfo({Map<String, dynamic>? queryParameters}) async {
    return client.get<SSLInfo>('/core/settings/ssl/info', queryParameters: queryParameters, fromData: (d) => SSLInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Reload SSL
  Future<ApiResponse<void>> postSettingsSslReload({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/ssl/reload', queryParameters: queryParameters);
  }

  /// Update system ssl
  Future<ApiResponse<void>> postSettingsSslUpdate(SSLUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/ssl/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load system terminal setting info
  Future<ApiResponse<TerminalInfo>> postSettingsTerminalSearch({Map<String, dynamic>? queryParameters}) async {
    return client.post<TerminalInfo>('/core/settings/terminal/search', queryParameters: queryParameters, fromData: (d) => TerminalInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Update system terminal setting
  Future<ApiResponse<void>> postSettingsTerminalUpdate(TerminalUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/terminal/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update system setting
  Future<ApiResponse<void>> postSettingsUpdate(SettingUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load upgrade info
  Future<ApiResponse<UpgradeInfo>> getSettingsUpgrade({Map<String, dynamic>? queryParameters}) async {
    return client.get<UpgradeInfo>('/core/settings/upgrade', queryParameters: queryParameters, fromData: (d) => UpgradeInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Upgrade
  Future<ApiResponse<void>> postSettingsUpgrade(Upgrade request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/upgrade', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load release notes by version
  Future<ApiResponse<void>> postSettingsUpgradeNotes(Upgrade request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/settings/upgrade/notes', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load upgrade notes
  Future<ApiResponse<void>> getSettingsUpgradeReleases({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/core/settings/upgrade/releases', queryParameters: queryParameters);
  }

  /// Create group
  Future<ApiResponse<void>> postGroups2(GroupCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/groups', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete group
  Future<ApiResponse<void>> postGroupsDel2(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/groups/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List groups
  Future<ApiResponse<void>> postGroupsSearch2(GroupSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/groups/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update group
  Future<ApiResponse<void>> postGroupsUpdate2(GroupUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/groups/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load local backup dir
  Future<ApiResponse<void>> getSettingsBasedir({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/settings/basedir', queryParameters: queryParameters);
  }

  /// Save common description
  Future<ApiResponse<void>> postSettingsDescriptionSave(CommonDescription request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/description/save', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load file history setting info
  Future<ApiResponse<FileHistorySettingInfo>> postsettingsfileHistorysearch({Map<String, dynamic>? queryParameters}) async {
    return client.post<FileHistorySettingInfo>('/settings/file-history/search', queryParameters: queryParameters, fromData: (d) => FileHistorySettingInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Update file history setting
  Future<ApiResponse<void>> postsettingsfileHistoryupdate(FileHistorySettingUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/file-history/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get file manage AI setting info
  Future<ApiResponse<void>> postSettingsFilesAiSearch({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/files/ai/search', queryParameters: queryParameters);
  }

  /// Update file manage AI setting
  Future<ApiResponse<void>> postSettingsFilesAiUpdate(FileManageAIInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/files/ai/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load system setting info
  Future<ApiResponse<SettingInfo>> postSettingsSearch2({Map<String, dynamic>? queryParameters}) async {
    return client.post<SettingInfo>('/settings/search', queryParameters: queryParameters, fromData: (d) => SettingInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Load system available status
  Future<ApiResponse<void>> getSettingsSearchAvailable2({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/settings/search/available', queryParameters: queryParameters);
  }

  /// Create system snapshot
  Future<ApiResponse<void>> postSettingsSnapshot(SnapshotCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/snapshot', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete system backup
  Future<ApiResponse<void>> postSettingsSnapshotDel(SnapshotBatchDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/snapshot/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update snapshot description
  Future<ApiResponse<void>> postSettingsSnapshotDescriptionUpdate(UpdateDescription request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/snapshot/description/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Import system snapshot
  Future<ApiResponse<void>> postSettingsSnapshotImport(SnapshotImport request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/snapshot/import', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load system snapshot data
  Future<ApiResponse<SnapshotData>> getSettingsSnapshotLoad({Map<String, dynamic>? queryParameters}) async {
    return client.get<SnapshotData>('/settings/snapshot/load', queryParameters: queryParameters, fromData: (d) => SnapshotData.fromJson(d as Map<String, dynamic>));
  }

  /// Recover system backup
  Future<ApiResponse<void>> postSettingsSnapshotRecover(SnapshotRecover request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/snapshot/recover', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Recreate system snapshot
  Future<ApiResponse<void>> postSettingsSnapshotRecreate(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/snapshot/recreate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Rollback system backup
  Future<ApiResponse<void>> postSettingsSnapshotRollback(SnapshotRecover request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/snapshot/rollback', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page system snapshot
  Future<ApiResponse<PageResult>> postSettingsSnapshotSearch(PageSnapshot request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/settings/snapshot/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Save local conn info
  Future<ApiResponse<void>> postSettingsSsh({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/ssh', queryParameters: queryParameters);
  }

  /// Check local conn
  Future<ApiResponse<void>> postSettingsSshCheck({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/ssh/check', queryParameters: queryParameters);
  }

  /// Check local conn info
  Future<ApiResponse<void>> postSettingsSshCheckInfo({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/ssh/check/info', queryParameters: queryParameters);
  }

  /// Load local conn
  Future<ApiResponse<SSHConnData>> getSettingsSshConn({Map<String, dynamic>? queryParameters}) async {
    return client.get<SSHConnData>('/settings/ssh/conn', queryParameters: queryParameters, fromData: (d) => SSHConnData.fromJson(d as Map<String, dynamic>));
  }

  /// Update local is conn
  Future<ApiResponse<void>> postSettingsSshDefault(SSHDefaultConn request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/ssh/default', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get terminal AI setting info
  Future<ApiResponse<void>> postSettingsTerminalAiSearch({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/terminal/ai/search', queryParameters: queryParameters);
  }

  /// Update terminal AI setting
  Future<ApiResponse<void>> postSettingsTerminalAiUpdate(TerminalAIInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/terminal/ai/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update system setting
  Future<ApiResponse<void>> postSettingsUpdate2(AgentSettingUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/settings/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load website dir
  Future<ApiResponse<void>> getSettingsWebsiteDir({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/settings/website/dir', queryParameters: queryParameters);
  }

}