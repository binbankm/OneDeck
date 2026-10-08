// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/toolbox_models.dart';

class ToolboxApi {
  final DioClient client;

  const ToolboxApi(this.client);

  /// Load Core grouped goroutine snapshot
  Future<ApiResponse<RuntimeGoroutineSnapshot>> getHostsDiagnosticsGoroutines({Map<String, dynamic>? queryParameters}) async {
    return client.get<RuntimeGoroutineSnapshot>('/core/hosts/diagnostics/goroutines', queryParameters: queryParameters, fromData: (d) => RuntimeGoroutineSnapshot.fromJson(d as Map<String, dynamic>));
  }

  /// Capture Core runtime profile
  Future<ApiResponse<void>> postHostsDiagnosticsProfiles(RuntimeProfileCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/hosts/diagnostics/profiles', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load Core runtime diagnostics summary
  Future<ApiResponse<RuntimeDiagnosticsSummary>> getHostsDiagnosticsSummary({Map<String, dynamic>? queryParameters}) async {
    return client.get<RuntimeDiagnosticsSummary>('/core/hosts/diagnostics/summary', queryParameters: queryParameters, fromData: (d) => RuntimeDiagnosticsSummary.fromJson(d as Map<String, dynamic>));
  }

  /// Load grouped goroutine snapshot
  Future<ApiResponse<RuntimeGoroutineSnapshot>> getHostsDiagnosticsGoroutines2({Map<String, dynamic>? queryParameters}) async {
    return client.get<RuntimeGoroutineSnapshot>('/hosts/diagnostics/goroutines', queryParameters: queryParameters, fromData: (d) => RuntimeGoroutineSnapshot.fromJson(d as Map<String, dynamic>));
  }

  /// Capture runtime profile
  Future<ApiResponse<void>> postHostsDiagnosticsProfiles2(RuntimeProfileCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/hosts/diagnostics/profiles', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load runtime diagnostics summary
  Future<ApiResponse<RuntimeDiagnosticsSummary>> getHostsDiagnosticsSummary2({Map<String, dynamic>? queryParameters}) async {
    return client.get<RuntimeDiagnosticsSummary>('/hosts/diagnostics/summary', queryParameters: queryParameters, fromData: (d) => RuntimeDiagnosticsSummary.fromJson(d as Map<String, dynamic>));
  }

  /// Create runtime
  Future<ApiResponse<Runtime>> postRuntimes(RuntimeCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<Runtime>('/runtimes', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => Runtime.fromJson(d as Map<String, dynamic>));
  }

  /// Get runtime
  Future<ApiResponse<RuntimeDTO>> getRuntimesId(String id, {Map<String, dynamic>? queryParameters}) async {
    return client.get<RuntimeDTO>('/runtimes/$id', queryParameters: queryParameters, fromData: (d) => RuntimeDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Get Node modules
  Future<ApiResponse<void>> postRuntimesNodeModules(NodeModuleReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/node/modules', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Operate Node modules
  Future<ApiResponse<void>> postRuntimesNodeModulesOperate(NodeModuleReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/node/modules/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Node package scripts
  Future<ApiResponse<void>> postRuntimesNodePackage(NodePackageReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/node/package', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Operate runtime
  Future<ApiResponse<void>> postRuntimesOperate(RuntimeOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get php runtime extension
  Future<ApiResponse<PHPExtensionRes>> getRuntimesPhpIdExtensions(String id, {Map<String, dynamic>? queryParameters}) async {
    return client.get<PHPExtensionRes>('/runtimes/php/$id/extensions', queryParameters: queryParameters, fromData: (d) => PHPExtensionRes.fromJson(d as Map<String, dynamic>));
  }

  /// Update runtime php conf
  Future<ApiResponse<void>> postRuntimesPhpConfig(PHPConfigUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/php/config', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load php runtime conf
  Future<ApiResponse<PHPConfig>> getRuntimesPhpConfigId(String id, {Map<String, dynamic>? queryParameters}) async {
    return client.get<PHPConfig>('/runtimes/php/config/$id', queryParameters: queryParameters, fromData: (d) => PHPConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Get PHP container config
  Future<ApiResponse<PHPContainerConfig>> getRuntimesPhpContainerId(String id, {Map<String, dynamic>? queryParameters}) async {
    return client.get<PHPContainerConfig>('/runtimes/php/container/$id', queryParameters: queryParameters, fromData: (d) => PHPContainerConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update PHP container config
  Future<ApiResponse<void>> postRuntimesPhpContainerUpdate(PHPContainerConfig request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/php/container/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Install php extension
  Future<ApiResponse<void>> postRuntimesPhpExtensionsInstall(PHPExtensionInstallReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/php/extensions/install', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// UnInstall php extension
  Future<ApiResponse<void>> postRuntimesPhpExtensionsUninstall(PHPExtensionInstallReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/php/extensions/uninstall', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get php conf file
  Future<ApiResponse<FileInfo>> postRuntimesPhpFile(PHPFileReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<FileInfo>('/runtimes/php/file', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => FileInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Update fpm config
  Future<ApiResponse<void>> postRuntimesPhpFpmConfig(FPMConfig request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/php/fpm/config', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get fpm config
  Future<ApiResponse<FPMConfig>> getRuntimesPhpFpmConfigId(String id, {Map<String, dynamic>? queryParameters}) async {
    return client.get<FPMConfig>('/runtimes/php/fpm/config/$id', queryParameters: queryParameters, fromData: (d) => FPMConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Get PHP runtime status
  Future<ApiResponse<void>> getRuntimesPhpFpmStatusId(String id, {Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/runtimes/php/fpm/status/$id', queryParameters: queryParameters);
  }

  /// Update php conf file
  Future<ApiResponse<void>> postRuntimesPhpUpdate(PHPFileUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/php/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update runtime remark
  Future<ApiResponse<void>> postRuntimesRemark(RuntimeRemark request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/remark', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List runtimes
  Future<ApiResponse<PageResult>> postRuntimesSearch(RuntimeSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/runtimes/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Operate supervisor process
  Future<ApiResponse<void>> postRuntimesSupervisorProcess(PHPSupervisorProcessConfig request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/supervisor/process', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get supervisor process
  Future<ApiResponse<void>> getRuntimesSupervisorProcessId(String id, {Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/runtimes/supervisor/process/$id', queryParameters: queryParameters);
  }

  /// Operate supervisor process file
  Future<ApiResponse<void>> postRuntimesSupervisorProcessFile(PHPSupervisorProcessFileReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/supervisor/process/file', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Sync runtime status
  Future<ApiResponse<void>> postRuntimesSync({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/sync', queryParameters: queryParameters);
  }

  /// Update runtime
  Future<ApiResponse<void>> postRuntimesUpdate(RuntimeUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create clam
  Future<ApiResponse<void>> postClam(ClamCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/clam', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load clam base info
  Future<ApiResponse<ClamBaseInfo>> postClamBase({Map<String, dynamic>? queryParameters}) async {
    return client.post<ClamBaseInfo>('/toolbox/clam/base', queryParameters: queryParameters, fromData: (d) => ClamBaseInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Delete clam
  Future<ApiResponse<void>> postClamDel(ClamDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/clam/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load clam file
  Future<ApiResponse<void>> postClamFileSearch(ClamFileReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/clam/file/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update clam file
  Future<ApiResponse<void>> postClamFileUpdate(UpdateByNameAndFile request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/clam/file/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Handle clam scan
  Future<ApiResponse<void>> postClamHandle(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/clam/handle', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Operate Clam
  Future<ApiResponse<void>> postClamOperate(Operate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/clam/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Clean clam record
  Future<ApiResponse<void>> postClamRecordClean(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/clam/record/clean', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page clam record
  Future<ApiResponse<PageResult>> postClamRecordSearch(ClamLogSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/toolbox/clam/record/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Page clam
  Future<ApiResponse<PageResult>> postClamSearch(SearchClamWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/toolbox/clam/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Update clam status
  Future<ApiResponse<void>> postClamStatusUpdate(ClamUpdateStatus request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/clam/status/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update clam
  Future<ApiResponse<void>> postClamUpdate(ClamUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/clam/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load fail2ban base info
  Future<ApiResponse<Fail2BanBaseInfo>> getFail2banBase({Map<String, dynamic>? queryParameters}) async {
    return client.get<Fail2BanBaseInfo>('/toolbox/fail2ban/base', queryParameters: queryParameters, fromData: (d) => Fail2BanBaseInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Load fail2ban conf
  Future<ApiResponse<void>> getFail2banLoadConf({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/toolbox/fail2ban/load/conf', queryParameters: queryParameters);
  }

  /// Operate fail2ban
  Future<ApiResponse<void>> postFail2banOperate(Operate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/fail2ban/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Operate sshd of fail2ban
  Future<ApiResponse<void>> postFail2banOperateSshd(Fail2BanSet request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/fail2ban/operate/sshd', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page fail2ban ip list
  Future<ApiResponse<void>> postFail2banSearch(Fail2BanSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/fail2ban/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update fail2ban conf
  Future<ApiResponse<void>> postFail2banUpdate(Fail2BanUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/fail2ban/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update fail2ban conf by file
  Future<ApiResponse<void>> postFail2banUpdateByconf(UpdateByFile request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/fail2ban/update/byconf', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create FTP user
  Future<ApiResponse<void>> postFtp(FtpCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/ftp', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load FTP base info
  Future<ApiResponse<FtpBaseInfo>> getFtpBase({Map<String, dynamic>? queryParameters}) async {
    return client.get<FtpBaseInfo>('/toolbox/ftp/base', queryParameters: queryParameters, fromData: (d) => FtpBaseInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Delete FTP user
  Future<ApiResponse<void>> postFtpDel(BatchDeleteReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/ftp/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load FTP operation log
  Future<ApiResponse<PageResult>> postFtpLogSearch(FtpLogSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/toolbox/ftp/log/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Operate FTP
  Future<ApiResponse<void>> postFtpOperate(Operate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/ftp/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page FTP user
  Future<ApiResponse<PageResult>> postFtpSearch(SearchWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/toolbox/ftp/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Sync FTP user
  Future<ApiResponse<void>> postFtpSync(BatchDeleteReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/ftp/sync', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update FTP user
  Future<ApiResponse<void>> postFtpUpdate(FtpUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/toolbox/ftp/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

}