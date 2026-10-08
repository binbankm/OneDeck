// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/container_models.dart';

class ContainerApi {
  final DioClient client;

  const ContainerApi(this.client);

  /// Create container
  Future<ApiResponse<void>> postContainers(ContainerOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Clean container log
  Future<ApiResponse<void>> postContainersCleanLog(OperationWithName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/clean/log', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Commit Container
  Future<ApiResponse<void>> postContainersCommit(ContainerCommit request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/commit', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create compose
  Future<ApiResponse<void>> postContainersCompose(ComposeCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/compose', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Clean compose log
  Future<ApiResponse<void>> postContainersComposeCleanLog(ComposeLogClean request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/compose/clean/log', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load compose environment variables
  Future<ApiResponse<void>> postContainersComposeEnv(FilePath request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/compose/env', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Operate compose
  Future<ApiResponse<void>> postContainersComposeOperate(ComposeOperation request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/compose/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Pin compose
  Future<ApiResponse<void>> postContainersComposePin(ComposePin request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/compose/pin', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page composes
  Future<ApiResponse<PageResult>> postContainersComposeSearch(SearchWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/containers/compose/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Test compose
  Future<ApiResponse<void>> postContainersComposeTest(ComposeCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/compose/test', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update compose
  Future<ApiResponse<void>> postContainersComposeUpdate(ComposeUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/compose/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load docker daemon.json
  Future<ApiResponse<DaemonJsonConf>> getContainersDaemonjson({Map<String, dynamic>? queryParameters}) async {
    return client.get<DaemonJsonConf>('/containers/daemonjson', queryParameters: queryParameters, fromData: (d) => DaemonJsonConf.fromJson(d as Map<String, dynamic>));
  }

  /// Load docker daemon.json
  Future<ApiResponse<void>> getContainersDaemonjsonFile({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/containers/daemonjson/file', queryParameters: queryParameters);
  }

  /// Update docker daemon.json
  Future<ApiResponse<void>> postContainersDaemonjsonUpdate(SettingUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/daemonjson/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update docker daemon.json by upload file
  Future<ApiResponse<void>> postContainersDaemonjsonUpdateByfile(DaemonJsonUpdateByFile request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/daemonjson/update/byfile', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Operate docker
  Future<ApiResponse<void>> postContainersDockerOperate(DockerOperation request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/docker/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load docker status
  Future<ApiResponse<DockerStatus>> getContainersDockerStatus({Map<String, dynamic>? queryParameters}) async {
    return client.get<DockerStatus>('/containers/docker/status', queryParameters: queryParameters, fromData: (d) => DockerStatus.fromJson(d as Map<String, dynamic>));
  }

  /// Download container logs
  Future<ApiResponse<void>> postContainersDownloadLog(ContainerLog request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/download/log', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get container file content
  Future<ApiResponse<ContainerFileContent>> postContainersFilesContent(ContainerFileReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<ContainerFileContent>('/containers/files/content', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => ContainerFileContent.fromJson(d as Map<String, dynamic>));
  }

  /// Delete container file
  Future<ApiResponse<void>> postContainersFilesDel(ContainerFileBatchDeleteReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/files/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Download container file
  Future<ApiResponse<void>> postContainersFilesDownload(ContainerFileReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/files/download', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List container files
  Future<ApiResponse<void>> postContainersFilesSearch(ContainerFileReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/files/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get container file size
  Future<ApiResponse<void>> postContainersFilesSize(ContainerFileReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/files/size', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Upload container file
  Future<ApiResponse<void>> postContainersFilesUpload({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/files/upload', queryParameters: queryParameters);
  }

  /// load images options
  Future<ApiResponse<void>> getContainersImage({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/containers/image', queryParameters: queryParameters);
  }

  /// List all images
  Future<ApiResponse<void>> getContainersImageAll({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/containers/image/all', queryParameters: queryParameters);
  }

  /// Build image
  Future<ApiResponse<void>> postContainersImageBuild(ImageBuild request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/image/build', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load image
  Future<ApiResponse<void>> postContainersImageLoad(ImageLoad request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/image/load', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Pull image
  Future<ApiResponse<void>> postContainersImagePull(ImagePull request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/image/pull', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Push image
  Future<ApiResponse<void>> postContainersImagePush(ImagePush request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/image/push', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete image
  Future<ApiResponse<void>> postContainersImageRemove(BatchDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/image/remove', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Save image
  Future<ApiResponse<void>> postContainersImageSave(ImageSave request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/image/save', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page images
  Future<ApiResponse<PageResult>> postContainersImageSearch(PageImage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/containers/image/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Tag image
  Future<ApiResponse<void>> postContainersImageTag(ImageTag request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/image/tag', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load container info
  Future<ApiResponse<ContainerOperate>> postContainersInfo(OperationWithName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<ContainerOperate>('/containers/info', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => ContainerOperate.fromJson(d as Map<String, dynamic>));
  }

  /// Container inspect
  Future<ApiResponse<void>> postContainersInspect(InspectReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/inspect', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update docker daemon.json ipv6 option
  Future<ApiResponse<void>> postContainersIpv6optionUpdate(LogOption request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/ipv6option/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load container stats size
  Future<ApiResponse<ContainerItemStats>> postContainersItemStats(OperationWithName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<ContainerItemStats>('/containers/item/stats', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => ContainerItemStats.fromJson(d as Map<String, dynamic>));
  }

  /// Load container limits
  Future<ApiResponse<ResourceLimit>> getContainersLimit({Map<String, dynamic>? queryParameters}) async {
    return client.get<ResourceLimit>('/containers/limit', queryParameters: queryParameters, fromData: (d) => ResourceLimit.fromJson(d as Map<String, dynamic>));
  }

  /// List containers
  Future<ApiResponse<void>> postContainersList({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/list', queryParameters: queryParameters);
  }

  /// List containers by image
  Future<ApiResponse<void>> postContainersListByimage({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/list/byimage', queryParameters: queryParameters);
  }

  /// Load container stats
  Future<ApiResponse<void>> getContainersListStats({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/containers/list/stats', queryParameters: queryParameters);
  }

  /// Update docker daemon.json log option
  Future<ApiResponse<void>> postContainersLogoptionUpdate(LogOption request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/logoption/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List networks
  Future<ApiResponse<void>> getContainersNetwork({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/containers/network', queryParameters: queryParameters);
  }

  /// Create network
  Future<ApiResponse<void>> postContainersNetwork(NetworkCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/network', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete network
  Future<ApiResponse<void>> postContainersNetworkDel(BatchDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/network/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page networks
  Future<ApiResponse<PageResult>> postContainersNetworkSearch(SearchWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/containers/network/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Operate Container
  Future<ApiResponse<void>> postContainersOperate(ContainerOperation request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Clean container
  Future<ApiResponse<void>> postContainersPrune(ContainerPrune request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/prune', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Rename Container
  Future<ApiResponse<void>> postContainersRename(ContainerRename request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/rename', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List image repos
  Future<ApiResponse<void>> getContainersRepo({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/containers/repo', queryParameters: queryParameters);
  }

  /// Create image repo
  Future<ApiResponse<void>> postContainersRepo(ImageRepoDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/repo', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete image repo
  Future<ApiResponse<void>> postContainersRepoDel(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/repo/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page image repos
  Future<ApiResponse<PageResult>> postContainersRepoSearch(SearchWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/containers/repo/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Load repo status
  Future<ApiResponse<void>> postContainersRepoStatus(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/repo/status', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update image repo
  Future<ApiResponse<void>> postContainersRepoUpdate(ImageRepoUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/repo/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page containers
  Future<ApiResponse<PageResult>> postContainersSearch(PageContainer request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/containers/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Container logs
  Future<ApiResponse<void>> getContainersSearchLog({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/containers/search/log', queryParameters: queryParameters);
  }

  /// Container stats
  Future<ApiResponse<ContainerStats>> getContainersStatsId(String id, {Map<String, dynamic>? queryParameters}) async {
    return client.get<ContainerStats>('/containers/stats/$id', queryParameters: queryParameters, fromData: (d) => ContainerStats.fromJson(d as Map<String, dynamic>));
  }

  /// Load containers status
  Future<ApiResponse<ContainerStatus>> getContainersStatus({Map<String, dynamic>? queryParameters}) async {
    return client.get<ContainerStatus>('/containers/status', queryParameters: queryParameters, fromData: (d) => ContainerStatus.fromJson(d as Map<String, dynamic>));
  }

  /// List compose templates
  Future<ApiResponse<void>> getContainersTemplate({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/containers/template', queryParameters: queryParameters);
  }

  /// Create compose template
  Future<ApiResponse<void>> postContainersTemplate(ComposeTemplateCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/template', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Bacth compose template
  Future<ApiResponse<void>> postContainersTemplateBatch(ComposeTemplateBatch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/template/batch', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete compose template
  Future<ApiResponse<void>> postContainersTemplateDel(BatchDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/template/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page compose templates
  Future<ApiResponse<PageResult>> postContainersTemplateSearch(SearchWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/containers/template/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Update compose template
  Future<ApiResponse<void>> postContainersTemplateUpdate(ComposeTemplateUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/template/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update container
  Future<ApiResponse<void>> postContainersUpdate(ContainerOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Upgrade container
  Future<ApiResponse<void>> postContainersUpgrade(ContainerUpgrade request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/upgrade', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load container users
  Future<ApiResponse<void>> postContainersUsers(OperationWithName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/users', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List volumes
  Future<ApiResponse<void>> getContainersVolume({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/containers/volume', queryParameters: queryParameters);
  }

  /// Create volume
  Future<ApiResponse<void>> postContainersVolume(VolumeCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/volume', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete volume
  Future<ApiResponse<void>> postContainersVolumeDel(BatchDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/containers/volume/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page volumes
  Future<ApiResponse<PageResult>> postContainersVolumeSearch(SearchWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/containers/volume/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

}