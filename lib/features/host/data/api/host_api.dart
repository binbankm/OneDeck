// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/host_models.dart';

class HostApi {
  final DioClient client;

  const HostApi(this.client);

  /// Create file
  Future<ApiResponse<void>> postFiles(FileCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// File search: content grep + optional AI summary
  Future<ApiResponse<FileAISearchResult>> postfilesaiSearch(FileAISearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FileAISearchResult>('/files/ai-search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FileAISearchResult.fromJson(d as Map<String, dynamic>));
  }

  /// Batch check file exist
  Future<ApiResponse<void>> postFilesBatchCheck(FilePathsCheck request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/batch/check', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Batch delete file
  Future<ApiResponse<void>> postFilesBatchDel(FileBatchDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/batch/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Batch change file mode and owner
  Future<ApiResponse<void>> postFilesBatchRole(FileRoleReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/batch/role', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Check file exist
  Future<ApiResponse<void>> postFilesCheck(FilePathCheck request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/check', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Chunk Download file
  Future<ApiResponse<void>> postFilesChunkdownload(FileDownload request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/chunkdownload', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// ChunkUpload file
  Future<ApiResponse<void>> postFilesChunkupload({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/chunkupload', queryParameters: queryParameters);
  }

  /// Compress file
  Future<ApiResponse<void>> postFilesCompress(FileCompress request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/compress', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Stop compress task
  Future<ApiResponse<void>> postFilesCompressStop(FileCompressStopReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/compress/stop', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load file content
  Future<ApiResponse<FileInfo>> postFilesContent(FileContentReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FileInfo>('/files/content', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FileInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Convert file
  Future<ApiResponse<void>> postFilesConvert(FileConvert request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/convert', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Convert file
  Future<ApiResponse<void>> postFilesConvertLog(PageInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/convert/log', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Decompress file
  Future<ApiResponse<void>> postFilesDecompress(FileDeCompress request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/decompress', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Stop decompress task
  Future<ApiResponse<void>> postFilesDecompressStop(FileDeCompressStopReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/decompress/stop', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete file
  Future<ApiResponse<void>> postFilesDel(FileDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Multi file size
  Future<ApiResponse<void>> postFilesDepthSize(DirSizeReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/depth/size', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Download file
  Future<ApiResponse<void>> getFilesDownload({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/files/download', queryParameters: queryParameters);
  }

  /// Create favorite
  Future<ApiResponse<Favorite>> postFilesFavorite(FavoriteCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<Favorite>('/files/favorite', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => Favorite.fromJson(d as Map<String, dynamic>));
  }

  /// Delete favorite
  Future<ApiResponse<void>> postFilesFavoriteDel(FavoriteDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/favorite/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List favorites
  Future<ApiResponse<PageResult>> postFilesFavoriteSearch(PageInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/files/favorite/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Load file history content
  Future<ApiResponse<FileHistoryInfo>> postFilesHistoryContent(FileHistoryContentReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FileHistoryInfo>('/files/history/content', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FileHistoryInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Delete file history record
  Future<ApiResponse<void>> postFilesHistoryDel(FileHistoryDeleteReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/history/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Restore file history record
  Future<ApiResponse<FileInfo>> postFilesHistoryRestore(FileHistoryRestoreReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FileInfo>('/files/history/restore', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FileInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Load file history list
  Future<ApiResponse<PageResult>> postFilesHistorySearch(FileHistorySearchReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/files/history/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Change file mode
  Future<ApiResponse<void>> postFilesMode(FileCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/mode', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// system mount
  Future<ApiResponse<DiskInfo>> postFilesMount({Map<String, dynamic>? queryParameters}) async {
    return client.post<DiskInfo>('/files/mount', queryParameters: queryParameters, fromData: (d) => DiskInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Move file
  Future<ApiResponse<void>> postFilesMove(FileMove request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/move', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Stop file move task
  Future<ApiResponse<void>> postFilesMoveStop(FileMoveStopReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/move/stop', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Change file owner
  Future<ApiResponse<void>> postFilesOwner(FileRoleUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/owner', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Preview file content
  Future<ApiResponse<FileInfo>> postFilesPreview(FileContentReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FileInfo>('/files/preview', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FileInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Read file by Line
  Future<ApiResponse<FileLineContent>> postFilesReadType(FileReadByLineReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FileLineContent>('/files/read/{type}', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FileLineContent.fromJson(d as Map<String, dynamic>));
  }

  /// Clear RecycleBin files
  Future<ApiResponse<void>> postFilesRecycleClear({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/recycle/clear', queryParameters: queryParameters);
  }

  /// Reduce RecycleBin files
  Future<ApiResponse<void>> postFilesRecycleReduce(RecycleBinReduce request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/recycle/reduce', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List RecycleBin files
  Future<ApiResponse<PageResult>> postFilesRecycleSearch(PageInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/files/recycle/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Get RecycleBin status
  Future<ApiResponse<void>> getFilesRecycleStatus({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/files/recycle/status', queryParameters: queryParameters);
  }

  /// Set file remark
  Future<ApiResponse<void>> postFilesRemark(FileRemarkUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/remark', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Batch get file remarks
  Future<ApiResponse<FileRemarksRes>> postFilesRemarks(FileRemarkBatch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FileRemarksRes>('/files/remarks', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FileRemarksRes.fromJson(d as Map<String, dynamic>));
  }

  /// Change file name
  Future<ApiResponse<void>> postFilesRename(FileRename request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/rename', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update file content
  Future<ApiResponse<void>> postFilesSave(FileEdit request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/save', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List files
  Future<ApiResponse<FileInfo>> postFilesSearch(FileOption request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FileInfo>('/files/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FileInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Check file share code (no login)
  Future<ApiResponse<Response>> getFilesShareCheck({Map<String, dynamic>? queryParameters}) async {
    return client.get<Response>('/files/share/check', queryParameters: queryParameters, fromData: (d) => Response.fromJson(d as Map<String, dynamic>));
  }

  /// Create temporary file share link
  Future<ApiResponse<FileShareInfo>> postFilesShareCreate(FileShareCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FileShareInfo>('/files/share/create', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FileShareInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Delete file share by path
  Future<ApiResponse<void>> postFilesShareDel(FilePath request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/share/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get file share detail by path
  Future<ApiResponse<FileShareInfo>> postFilesShareDetail(FilePath request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FileShareInfo>('/files/share/detail', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FileShareInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Download file by share code (no login)
  Future<ApiResponse<void>> getFilesShareDownload({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/files/share/download', queryParameters: queryParameters);
  }

  /// Get file share detail by code (no login)
  Future<ApiResponse<FileSharePublicInfo>> getFilesShareInfo({Map<String, dynamic>? queryParameters}) async {
    return client.get<FileSharePublicInfo>('/files/share/info', queryParameters: queryParameters, fromData: (d) => FileSharePublicInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Get file share QR code image
  Future<ApiResponse<void>> getFilesShareQrcode({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/files/share/qrcode', queryParameters: queryParameters);
  }

  /// List file shares
  Future<ApiResponse<PageResult>> postFilesShareSearch(PageInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/files/share/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Load file size
  Future<ApiResponse<DirSizeRes>> postFilesSize(DirSizeReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<DirSizeRes>('/files/size', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => DirSizeRes.fromJson(d as Map<String, dynamic>));
  }

  /// Load files tree
  Future<ApiResponse<void>> postFilesTree(FileOption request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/tree', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Upload file
  Future<ApiResponse<void>> postFilesUpload({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/upload', queryParameters: queryParameters);
  }

  /// Page file
  Future<ApiResponse<PageResult>> postFilesUploadSearch(SearchUploadWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/files/upload/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// system user and group
  Future<ApiResponse<UserGroupResponse>> postFilesUserGroup({Map<String, dynamic>? queryParameters}) async {
    return client.post<UserGroupResponse>('/files/user/group', queryParameters: queryParameters, fromData: (d) => UserGroupResponse.fromJson(d as Map<String, dynamic>));
  }

  /// Wget file
  Future<ApiResponse<FileWgetRes>> postFilesWget(FileWget request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FileWgetRes>('/files/wget', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FileWgetRes.fromJson(d as Map<String, dynamic>));
  }

  /// Wget process
  Future<ApiResponse<void>> getFilesWgetProcess({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/files/wget/process', queryParameters: queryParameters);
  }

  /// Process keys
  Future<ApiResponse<void>> getFilesWgetProcessKeys({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/files/wget/process/keys', queryParameters: queryParameters);
  }

  /// Stop wget file download
  Future<ApiResponse<void>> postFilesWgetStop(FileProcessReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/files/wget/stop', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create host
  Future<ApiResponse<void>> postHosts(HostOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Check if a system component exists
  Future<ApiResponse<ComponentInfo>> getHostsComponentsName({Map<String, dynamic>? queryParameters}) async {
    return client.get<ComponentInfo>('/hosts/components/{name}', queryParameters: queryParameters, fromData: (d) => ComponentInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Delete host
  Future<ApiResponse<void>> postHostsDel(OperateByIDs request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get complete disk information
  Future<ApiResponse<CompleteDiskInfo>> getHostsDisks({Map<String, dynamic>? queryParameters}) async {
    return client.get<CompleteDiskInfo>('/hosts/disks', queryParameters: queryParameters, fromData: (d) => CompleteDiskInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Mount disk
  Future<ApiResponse<void>> postHostsDisksMount(DiskMountRequest request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/disks/mount', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Partition disk
  Future<ApiResponse<void>> postHostsDisksPartition(DiskPartitionRequest request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/disks/partition', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Unmount disk
  Future<ApiResponse<void>> postHostsDisksUnmount(DiskUnmountRequest request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/disks/unmount', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load firewall base info
  Future<ApiResponse<FirewallSubsystemStatus>> postHostsFirewallBase(OperationWithName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FirewallSubsystemStatus>('/hosts/firewall/base', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FirewallSubsystemStatus.fromJson(d as Map<String, dynamic>));
  }

  /// Operate Docker port guard
  Future<ApiResponse<FilterChainOperationResponse>> postHostsFirewallDockerOperate(DockerPortGuardOperation request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FilterChainOperationResponse>('/hosts/firewall/docker/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FilterChainOperationResponse.fromJson(d as Map<String, dynamic>));
  }

  /// Batch upsert Docker port guard policies
  Future<ApiResponse<FilterChainOperationResponse>> postHostsFirewallDockerPoliciesBatch(DockerPortGuardPolicyBatch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FilterChainOperationResponse>('/hosts/firewall/docker/policies/batch', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FilterChainOperationResponse.fromJson(d as Map<String, dynamic>));
  }

  /// Delete Docker port guard policies
  Future<ApiResponse<FilterChainOperationResponse>> postHostsFirewallDockerPoliciesDeleteBatch(DockerPortGuardPolicyBatchDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FilterChainOperationResponse>('/hosts/firewall/docker/policies/delete/batch', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FilterChainOperationResponse.fromJson(d as Map<String, dynamic>));
  }

  /// List Docker port guard status and policies
  Future<ApiResponse<DockerPortGuardList>> getHostsFirewallDockerPorts({Map<String, dynamic>? queryParameters}) async {
    return client.get<DockerPortGuardList>('/hosts/firewall/docker/ports', queryParameters: queryParameters, fromData: (d) => DockerPortGuardList.fromJson(d as Map<String, dynamic>));
  }

  /// Sync Docker port guard rules
  Future<ApiResponse<void>> postHostsFirewallDockerSync({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/firewall/docker/sync', queryParameters: queryParameters);
  }

  /// Apply/Unload/Init firewall filter chain
  Future<ApiResponse<FilterChainOperationResponse>> postHostsFirewallFilterOperate(FilterChainOperation request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FilterChainOperationResponse>('/hosts/firewall/filter/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FilterChainOperationResponse.fromJson(d as Map<String, dynamic>));
  }

  /// Load forwarding base info
  Future<ApiResponse<FirewallSubsystemStatus>> postHostsFirewallForwardBase({Map<String, dynamic>? queryParameters}) async {
    return client.post<FirewallSubsystemStatus>('/hosts/firewall/forward/base', queryParameters: queryParameters, fromData: (d) => FirewallSubsystemStatus.fromJson(d as Map<String, dynamic>));
  }

  /// Enable forwarding
  Future<ApiResponse<FilterChainOperationResponse>> postHostsFirewallForwardEnable(FirewallInitializationTask request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FilterChainOperationResponse>('/hosts/firewall/forward/enable', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FilterChainOperationResponse.fromJson(d as Map<String, dynamic>));
  }

  /// Operate forwarding rules
  Future<ApiResponse<FilterChainOperationResponse>> postHostsFirewallForwardOperate(ForwardRuleOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FilterChainOperationResponse>('/hosts/firewall/forward/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FilterChainOperationResponse.fromJson(d as Map<String, dynamic>));
  }

  /// Page forwarding rules
  Future<ApiResponse<PageResult>> postHostsFirewallForwardSearch(ForwardRuleSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/hosts/firewall/forward/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Operate firewall
  Future<ApiResponse<void>> postHostsFirewallOperate(FirewallLifecycleOperation request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/firewall/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Queue firewall rule creation
  Future<ApiResponse<FirewallRuleCreateResponse>> postHostsFirewallRules(FirewallRuleCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FirewallRuleCreateResponse>('/hosts/firewall/rules', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FirewallRuleCreateResponse.fromJson(d as Map<String, dynamic>));
  }

  /// Adopt an external firewall rule
  Future<ApiResponse<void>> postHostsFirewallRulesAdopt(FirewallRuleAdopt request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/firewall/rules/adopt', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Queue firewall rule deletion
  Future<ApiResponse<FirewallRuleDeleteResponse>> postHostsFirewallRulesDelete(FirewallRuleDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FirewallRuleDeleteResponse>('/hosts/firewall/rules/delete', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FirewallRuleDeleteResponse.fromJson(d as Map<String, dynamic>));
  }

  /// Load one provider-native firewall object definition
  Future<ApiResponse<void>> postHostsFirewallRulesNativeDetail(FirewallNativeDetail request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/firewall/rules/native/detail', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Reorder a managed unified firewall v2 rule
  Future<ApiResponse<void>> postHostsFirewallRulesReorder(FirewallRuleReorder request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/firewall/rules/reorder', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List unified firewall v2 rules
  Future<ApiResponse<FirewallRuleInventoryResponse>> postHostsFirewallRulesSearch(FirewallRuleInventory request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FirewallRuleInventoryResponse>('/hosts/firewall/rules/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FirewallRuleInventoryResponse.fromJson(d as Map<String, dynamic>));
  }

  /// Update a managed unified firewall v2 rule
  Future<ApiResponse<void>> postHostsFirewallRulesUpdate(FirewallRuleUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/firewall/rules/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load firewall settings
  Future<ApiResponse<FirewallSettings>> getHostsFirewallSettings({Map<String, dynamic>? queryParameters}) async {
    return client.get<FirewallSettings>('/hosts/firewall/settings', queryParameters: queryParameters, fromData: (d) => FirewallSettings.fromJson(d as Map<String, dynamic>));
  }

  /// Operate firewall backend
  Future<ApiResponse<void>> postHostsFirewallSettingsOperate(FirewallBackendOperation request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/firewall/settings/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create firewall port whitelist rules
  Future<ApiResponse<void>> postHostsFirewallSettingsWhitelist(FirewallPortWhitelistCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/firewall/settings/whitelist', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete firewall port whitelist rules
  Future<ApiResponse<void>> postHostsFirewallSettingsWhitelistDelete(FirewallPortWhitelistDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/firewall/settings/whitelist/delete', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update firewall port whitelist rules
  Future<ApiResponse<void>> postHostsFirewallSettingsWhitelistUpdate(FirewallPortWhitelistUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/firewall/settings/whitelist/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get host by ID
  Future<ApiResponse<void>> postHostsInfo(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/info', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Search host
  Future<ApiResponse<void>> postHostsSearch(SearchPageWithGroup request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Generate host SSH secret
  Future<ApiResponse<void>> postHostsSshCert(RootCertOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/ssh/cert', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete host SSH secret
  Future<ApiResponse<void>> postHostsSshCertDelete(ForceDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/ssh/cert/delete', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load host SSH secret
  Future<ApiResponse<PageResult>> postHostsSshCertSearch(SearchWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/hosts/ssh/cert/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Sycn host SSH secret
  Future<ApiResponse<void>> postHostsSshCertSync({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/ssh/cert/sync', queryParameters: queryParameters);
  }

  /// Update host SSH secret
  Future<ApiResponse<void>> postHostsSshCertUpdate(RootCertOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/ssh/cert/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load host SSH conf
  Future<ApiResponse<void>> postHostsSshFile(OperationWithName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/ssh/file', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update host SSH setting by file
  Future<ApiResponse<void>> postHostsSshFileUpdate(SSHConfUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/ssh/file/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load host SSH logs
  Future<ApiResponse<PageResult>> postHostsSshLog(SearchSSHLog request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/hosts/ssh/log', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Clean host SSH logs
  Future<ApiResponse<void>> postHostsSshLogClean({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/ssh/log/clean', queryParameters: queryParameters);
  }

  /// Export host SSH logs
  Future<ApiResponse<void>> postHostsSshLogExport(SearchSSHLog request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/ssh/log/export', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Operate SSH
  Future<ApiResponse<void>> postHostsSshOperate(Operate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/ssh/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load host SSH setting info
  Future<ApiResponse<SSHInfo>> postHostsSshSearch({Map<String, dynamic>? queryParameters}) async {
    return client.post<SSHInfo>('/hosts/ssh/search', queryParameters: queryParameters, fromData: (d) => SSHInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Update host SSH setting
  Future<ApiResponse<void>> postHostsSshUpdate(SSHUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/ssh/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Test by ID
  Future<ApiResponse<void>> postHostsTestByid(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/test/byid', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Test by info
  Future<ApiResponse<void>> postHostsTestByinfo(HostConnTest request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/test/byinfo', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get tool config
  Future<ApiResponse<HostToolConfig>> postHostsToolConfigGet(HostToolTypeReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<HostToolConfig>('/hosts/tool/config/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => HostToolConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update tool config
  Future<ApiResponse<void>> postHostsToolConfigSet(HostToolConfigUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/tool/config/set', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create Host tool Config
  Future<ApiResponse<void>> postHostsToolInit(HostToolCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/tool/init', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Operate tool
  Future<ApiResponse<void>> postHostsToolOperate(HostToolOperateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/tool/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get tool status
  Future<ApiResponse<HostToolRes>> postHostsToolStatus(HostToolTypeReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<HostToolRes>('/hosts/tool/status', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => HostToolRes.fromJson(d as Map<String, dynamic>));
  }

  /// Get Supervisor process config
  Future<ApiResponse<SupervisorProcessConfig>> getHostsToolSupervisorProcess({Map<String, dynamic>? queryParameters}) async {
    return client.get<SupervisorProcessConfig>('/hosts/tool/supervisor/process', queryParameters: queryParameters, fromData: (d) => SupervisorProcessConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Create Supervisor process
  Future<ApiResponse<void>> postHostsToolSupervisorProcess(SupervisorProcessConfig request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/tool/supervisor/process', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Operate Supervisor process config file
  Future<ApiResponse<void>> postHostsToolSupervisorProcessFile(HostSupervisorProcessFileOperateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/tool/supervisor/process/file', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Supervisor process config file
  Future<ApiResponse<void>> postHostsToolSupervisorProcessFileGet(HostSupervisorProcessFileGetReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/tool/supervisor/process/file/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Host tree
  Future<ApiResponse<void>> postHostsTree(SearchForTree request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/tree', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update host
  Future<ApiResponse<void>> postHostsUpdate(HostOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update host group
  Future<ApiResponse<void>> postHostsUpdateGroup(ChangeGroup request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/update/group', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Listening Process
  Future<ApiResponse<void>> postProcessListening({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/process/listening', queryParameters: queryParameters);
  }

  /// Stop Process
  Future<ApiResponse<void>> postProcessStop(ProcessReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/process/stop', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Process ws
  Future<ApiResponse<void>> getProcessWs({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/process/ws', queryParameters: queryParameters);
  }

  /// Get Process Info By PID
  Future<ApiResponse<void>> getProcessPid({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/process/{pid}', queryParameters: queryParameters);
  }

  /// Clean system
  Future<ApiResponse<void>> postToolboxClean({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/clean', queryParameters: queryParameters);
  }

  /// Load device base info
  Future<ApiResponse<DeviceBaseInfo>> postToolboxDeviceBase({Map<String, dynamic>? queryParameters}) async {
    return client.post<DeviceBaseInfo>('/toolbox/device/base', queryParameters: queryParameters, fromData: (d) => DeviceBaseInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Check device DNS conf
  Future<ApiResponse<void>> postToolboxDeviceCheckDns(SettingUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/device/check/dns', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// load conf
  Future<ApiResponse<void>> postToolboxDeviceConf(OperationWithName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/device/conf', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update device conf by file
  Future<ApiResponse<void>> postToolboxDeviceUpdateByconf(UpdateByNameAndFile request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/device/update/byconf', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update device
  Future<ApiResponse<void>> postToolboxDeviceUpdateConf(SettingUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/device/update/conf', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update device hosts
  Future<ApiResponse<void>> postToolboxDeviceUpdate({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/device/update/host', queryParameters: queryParameters);
  }

  /// Update device passwd
  Future<ApiResponse<void>> postToolboxDeviceUpdatePasswd(ChangePasswd request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/device/update/passwd', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update device swap
  Future<ApiResponse<void>> postToolboxDeviceUpdateSwap(SwapHelper request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/device/update/swap', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load user list
  Future<ApiResponse<void>> getToolboxDeviceUsers({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/toolbox/device/users', queryParameters: queryParameters);
  }

  /// list time zone options
  Future<ApiResponse<void>> getToolboxDeviceZoneOptions({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/toolbox/device/zone/options', queryParameters: queryParameters);
  }

  /// Scan system
  Future<ApiResponse<CleanData>> postToolboxScan({Map<String, dynamic>? queryParameters}) async {
    return client.post<CleanData>('/toolbox/scan', queryParameters: queryParameters, fromData: (d) => CleanData.fromJson(d as Map<String, dynamic>));
  }

}