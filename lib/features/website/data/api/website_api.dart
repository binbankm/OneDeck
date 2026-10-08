// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/website_models.dart';

class WebsiteApi {
  final DioClient client;

  const WebsiteApi(this.client);

  /// Load OpenResty conf
  Future<ApiResponse<NginxFile>> getOpenresty({Map<String, dynamic>? queryParameters}) async {
    return client.get<NginxFile>('/openresty', queryParameters: queryParameters, fromData: (d) => NginxFile.fromJson(d as Map<String, dynamic>));
  }

  /// Build OpenResty
  Future<ApiResponse<void>> postOpenrestyBuild(NginxBuildReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/openresty/build', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update OpenResty conf by upload file
  Future<ApiResponse<void>> postOpenrestyFile(NginxConfigFileUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/openresty/file', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get default HTTPs status
  Future<ApiResponse<NginxConfigRes>> getOpenrestyHttps({Map<String, dynamic>? queryParameters}) async {
    return client.get<NginxConfigRes>('/openresty/https', queryParameters: queryParameters, fromData: (d) => NginxConfigRes.fromJson(d as Map<String, dynamic>));
  }

  /// Operate default HTTPs
  Future<ApiResponse<void>> postOpenrestyHttps(NginxDefaultHTTPSUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/openresty/https', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get OpenResty modules
  Future<ApiResponse<NginxBuildConfig>> getOpenrestyModules({Map<String, dynamic>? queryParameters}) async {
    return client.get<NginxBuildConfig>('/openresty/modules', queryParameters: queryParameters, fromData: (d) => NginxBuildConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update OpenResty module
  Future<ApiResponse<void>> postOpenrestyModulesUpdate(NginxModuleUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/openresty/modules/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load partial OpenResty conf
  Future<ApiResponse<void>> postOpenrestyScope(NginxScopeReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/openresty/scope', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load OpenResty status info
  Future<ApiResponse<NginxStatus>> getOpenrestyStatus({Map<String, dynamic>? queryParameters}) async {
    return client.get<NginxStatus>('/openresty/status', queryParameters: queryParameters, fromData: (d) => NginxStatus.fromJson(d as Map<String, dynamic>));
  }

  /// Update OpenResty conf
  Future<ApiResponse<void>> postOpenrestyUpdate(NginxConfigUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/openresty/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete runtime
  Future<ApiResponse<void>> postRuntimesDel(RuntimeDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete runtime
  Future<ApiResponse<void>> getRuntimesInstalledDeleteCheckId(String id, {Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/runtimes/installed/delete/check/$id', queryParameters: queryParameters);
  }

  /// Create Extensions
  Future<ApiResponse<void>> postRuntimesPhpExtensions(PHPExtensionsCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/php/extensions', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete Extensions
  Future<ApiResponse<void>> postRuntimesPhpExtensionsDel(PHPExtensionsDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/php/extensions/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page Extensions
  Future<ApiResponse<PageResult>> postRuntimesPhpExtensionsSearch(PHPExtensionsSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/runtimes/php/extensions/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Update Extensions
  Future<ApiResponse<void>> postRuntimesPhpExtensionsUpdate(PHPExtensionsUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/runtimes/php/extensions/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create website
  Future<ApiResponse<void>> postWebsites(WebsiteCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Search website by id
  Future<ApiResponse<WebsiteDTO>> getWebsitesId(String id, {Map<String, dynamic>? queryParameters}) async {
    return client.get<WebsiteDTO>('/websites/$id', queryParameters: queryParameters, fromData: (d) => WebsiteDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Search website nginx by id
  Future<ApiResponse<FileInfo>> getWebsitesIdConfigType(String id, String type, {Map<String, dynamic>? queryParameters}) async {
    return client.get<FileInfo>('/websites/$id/config/$type', queryParameters: queryParameters, fromData: (d) => FileInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Load https conf
  Future<ApiResponse<WebsiteHTTPS>> getWebsitesIdHttps(String id, {Map<String, dynamic>? queryParameters}) async {
    return client.get<WebsiteHTTPS>('/websites/$id/https', queryParameters: queryParameters, fromData: (d) => WebsiteHTTPS.fromJson(d as Map<String, dynamic>));
  }

  /// Update https conf
  Future<ApiResponse<WebsiteHTTPS>> postWebsitesIdHttps(String id, WebsiteHTTPSOp request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<WebsiteHTTPS>('/websites/$id/https', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => WebsiteHTTPS.fromJson(d as Map<String, dynamic>));
  }

  /// Create website acme account
  Future<ApiResponse<WebsiteAcmeAccountDTO>> postWebsitesAcme(WebsiteAcmeAccountCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<WebsiteAcmeAccountDTO>('/websites/acme', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => WebsiteAcmeAccountDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Delete website acme account
  Future<ApiResponse<void>> postWebsitesAcmeDel(WebsiteResourceReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/acme/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page website acme accounts
  Future<ApiResponse<PageResult>> postWebsitesAcmeSearch(PageInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/websites/acme/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Update website acme account
  Future<ApiResponse<WebsiteAcmeAccountDTO>> postWebsitesAcmeUpdate(WebsiteAcmeAccountUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<WebsiteAcmeAccountDTO>('/websites/acme/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => WebsiteAcmeAccountDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Get AuthBasic conf
  Future<ApiResponse<NginxAuthRes>> postWebsitesAuths(NginxAuthReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<NginxAuthRes>('/websites/auths', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => NginxAuthRes.fromJson(d as Map<String, dynamic>));
  }

  /// Get AuthBasic conf
  Future<ApiResponse<NginxPathAuthRes>> postWebsitesAuthsPath(NginxAuthReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<NginxPathAuthRes>('/websites/auths/path', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => NginxPathAuthRes.fromJson(d as Map<String, dynamic>));
  }

  /// Get AuthBasic conf
  Future<ApiResponse<void>> postWebsitesAuthsPathUpdate(NginxPathAuthUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/auths/path/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get AuthBasic conf
  Future<ApiResponse<void>> postWebsitesAuthsUpdate(NginxAuthUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/auths/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Batch set website group
  Future<ApiResponse<void>> postWebsitesBatchGroup(BatchWebsiteGroup request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/batch/group', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Batch operate websites
  Future<ApiResponse<void>> postWebsitesBatchOperate(BatchWebsiteOp request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/batch/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Batch set HTTPS for websites
  Future<ApiResponse<void>> postWebsitesBatchSsl(BatchWebsiteHttps request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/batch/ssl', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create website ca
  Future<ApiResponse<WebsiteCACreate>> postWebsitesCa(WebsiteCACreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<WebsiteCACreate>('/websites/ca', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => WebsiteCACreate.fromJson(d as Map<String, dynamic>));
  }

  /// Delete website ca
  Future<ApiResponse<void>> postWebsitesCaDel(WebsiteCommonReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ca/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Download CA file
  Future<ApiResponse<void>> postWebsitesCaDownload(WebsiteResourceReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ca/download', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Obtain SSL
  Future<ApiResponse<void>> postWebsitesCaObtain(WebsiteCAObtain request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ca/obtain', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Obtain SSL
  Future<ApiResponse<void>> postWebsitesCaRenew(WebsiteCAObtain request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ca/renew', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page website ca
  Future<ApiResponse<PageResult>> postWebsitesCaSearch(WebsiteCASearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/websites/ca/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Get website ca
  Future<ApiResponse<WebsiteCADTO>> getWebsitesCaId({Map<String, dynamic>? queryParameters}) async {
    return client.get<WebsiteCADTO>('/websites/ca/{id}', queryParameters: queryParameters, fromData: (d) => WebsiteCADTO.fromJson(d as Map<String, dynamic>));
  }

  /// Check before create website
  Future<ApiResponse<void>> postWebsitesCheck(WebsiteInstallCheckReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/check', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load nginx conf
  Future<ApiResponse<WebsiteNginxConfig>> postWebsitesConfig(NginxScopeReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<WebsiteNginxConfig>('/websites/config', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => WebsiteNginxConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update nginx conf
  Future<ApiResponse<void>> postWebsitesConfigUpdate(NginxConfigUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/config/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update CORS Config
  Future<ApiResponse<void>> postWebsitesCorsUpdate(CorsConfigReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/cors/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get CORS Config
  Future<ApiResponse<CorsConfig>> getWebsitesCorsId({Map<String, dynamic>? queryParameters}) async {
    return client.get<CorsConfig>('/websites/cors/{id}', queryParameters: queryParameters, fromData: (d) => CorsConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Operate Cross Site Access
  Future<ApiResponse<void>> postWebsitesCrosssite(CrossSiteAccessOp request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/crosssite', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get databases
  Future<ApiResponse<Database>> getWebsitesDatabases({Map<String, dynamic>? queryParameters}) async {
    return client.get<Database>('/websites/databases', queryParameters: queryParameters, fromData: (d) => Database.fromJson(d as Map<String, dynamic>));
  }

  /// Change website database
  Future<ApiResponse<void>> postWebsitesDatabases(ChangeDatabase request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/databases', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get default html
  Future<ApiResponse<WebsiteHtmlRes>> getWebsitesDefaultHtmlType(String type, {Map<String, dynamic>? queryParameters}) async {
    return client.get<WebsiteHtmlRes>('/websites/default/html/$type', queryParameters: queryParameters, fromData: (d) => WebsiteHtmlRes.fromJson(d as Map<String, dynamic>));
  }

  /// Update default html
  Future<ApiResponse<void>> postWebsitesDefaultHtmlUpdate(WebsiteHtmlUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/default/html/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Change default server
  Future<ApiResponse<void>> postWebsitesDefaultServer(WebsiteDefaultUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/default/server', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete website
  Future<ApiResponse<void>> postWebsitesDel(WebsiteDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get website dir
  Future<ApiResponse<WebsiteDirConfig>> postWebsitesDir(WebsiteCommonReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<WebsiteDirConfig>('/websites/dir', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => WebsiteDirConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update Site Dir permission
  Future<ApiResponse<void>> postWebsitesDirPermission(WebsiteUpdateDirPermission request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/dir/permission', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update Site Dir
  Future<ApiResponse<void>> postWebsitesDirUpdate(WebsiteUpdateDir request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/dir/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create website dns account
  Future<ApiResponse<void>> postWebsitesDns(WebsiteDnsAccountCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/dns', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete website dns account
  Future<ApiResponse<void>> postWebsitesDnsDel(WebsiteResourceReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/dns/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page website dns accounts
  Future<ApiResponse<PageResult>> postWebsitesDnsSearch(PageInfo request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/websites/dns/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Update website dns account
  Future<ApiResponse<void>> postWebsitesDnsUpdate(WebsiteDnsAccountUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/dns/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create website domain
  Future<ApiResponse<WebsiteDomain>> postWebsitesDomains(WebsiteDomainCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<WebsiteDomain>('/websites/domains', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => WebsiteDomain.fromJson(d as Map<String, dynamic>));
  }

  /// Search website domains by websiteId
  Future<ApiResponse<void>> getWebsitesDomainsWebsiteid(String websiteId, {Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/websites/domains/$websiteId', queryParameters: queryParameters);
  }

  /// Delete website domain
  Future<ApiResponse<void>> postWebsitesDomainsDel(WebsiteDomainDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/domains/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update website domain
  Future<ApiResponse<void>> postWebsitesDomainsUpdate(WebsiteDomainUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/domains/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Exec Composer
  Future<ApiResponse<void>> postWebsitesExecComposer(ExecComposerReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/exec/composer', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Change website group
  Future<ApiResponse<void>> postWebsitesGroupChange(UpdateGroup request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/group/change', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create website upstream
  Future<ApiResponse<void>> postWebsitesLbsCreate(WebsiteLBCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/lbs/create', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete website upstream
  Future<ApiResponse<void>> postWebsitesLbsDel(WebsiteLBDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/lbs/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update website upstream file
  Future<ApiResponse<void>> postWebsitesLbsFile(WebsiteLBUpdateFile request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/lbs/file', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update website upstream
  Future<ApiResponse<void>> postWebsitesLbsUpdate(WebsiteLBUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/lbs/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get AntiLeech conf
  Future<ApiResponse<NginxAntiLeechRes>> postWebsitesLeech(NginxCommonReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<NginxAntiLeechRes>('/websites/leech', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => NginxAntiLeechRes.fromJson(d as Map<String, dynamic>));
  }

  /// Update AntiLeech
  Future<ApiResponse<void>> postWebsitesLeechUpdate(NginxAntiLeechUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/leech/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List websites
  Future<ApiResponse<void>> getWebsitesList({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/websites/list', queryParameters: queryParameters);
  }

  /// Operate website log
  Future<ApiResponse<void>> postWebsitesLogOperate(WebsiteLogReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/log/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get website log
  Future<ApiResponse<WebsiteLog>> postWebsitesLogSearch(WebsiteLogSearchReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<WebsiteLog>('/websites/log/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => WebsiteLog.fromJson(d as Map<String, dynamic>));
  }

  /// Update website nginx conf
  Future<ApiResponse<void>> postWebsitesNginxUpdate(WebsiteNginxUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/nginx/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Operate website
  Future<ApiResponse<void>> postWebsitesOperate(WebsiteOp request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List website names
  Future<ApiResponse<void>> postWebsitesOptions({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/options', queryParameters: queryParameters);
  }

  /// Update php version
  Future<ApiResponse<void>> postWebsitesPhpVersion(WebsitePHPVersionReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/php/version', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get proxy conf
  Future<ApiResponse<void>> postWebsitesProxies(WebsiteProxyReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/proxies', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete proxy config
  Future<ApiResponse<void>> postWebsitesProxiesDelete(WebsiteProxyDel request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/proxies/delete', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update proxy file
  Future<ApiResponse<void>> postWebsitesProxiesFile(NginxProxyUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/proxies/file', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update proxy config status
  Future<ApiResponse<void>> postWebsitesProxiesStatus(WebsiteProxyStatusUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/proxies/status', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update proxy conf
  Future<ApiResponse<void>> postWebsitesProxiesUpdate(WebsiteProxyConfig request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/proxies/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Clear Website proxy cache
  Future<ApiResponse<void>> postWebsitesProxyClear({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/proxy/clear', queryParameters: queryParameters);
  }

  /// update website proxy cache config
  Future<ApiResponse<void>> postWebsitesProxyConfig(NginxProxyCacheUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/proxy/config', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get website proxy cache config
  Future<ApiResponse<NginxProxyCache>> getWebsitesProxyConfigId({Map<String, dynamic>? queryParameters}) async {
    return client.get<NginxProxyCache>('/websites/proxy/config/{id}', queryParameters: queryParameters, fromData: (d) => NginxProxyCache.fromJson(d as Map<String, dynamic>));
  }

  /// Set Real IP
  Future<ApiResponse<void>> postWebsitesRealipConfig(WebsiteRealIP request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/realip/config', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Real IP Config
  Future<ApiResponse<WebsiteRealIP>> getWebsitesRealipConfigId({Map<String, dynamic>? queryParameters}) async {
    return client.get<WebsiteRealIP>('/websites/realip/config/{id}', queryParameters: queryParameters, fromData: (d) => WebsiteRealIP.fromJson(d as Map<String, dynamic>));
  }

  /// Get redirect conf
  Future<ApiResponse<void>> postWebsitesRedirect(WebsiteProxyReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/redirect', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update redirect file
  Future<ApiResponse<void>> postWebsitesRedirectFile(NginxRedirectUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/redirect/file', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update redirect conf
  Future<ApiResponse<void>> postWebsitesRedirectUpdate(NginxRedirectReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/redirect/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get website resource
  Future<ApiResponse<Resource>> getWebsitesResourceId({Map<String, dynamic>? queryParameters}) async {
    return client.get<Resource>('/websites/resource/{id}', queryParameters: queryParameters, fromData: (d) => Resource.fromJson(d as Map<String, dynamic>));
  }

  /// Get rewrite conf
  Future<ApiResponse<NginxRewriteRes>> postWebsitesRewrite(NginxRewriteReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<NginxRewriteRes>('/websites/rewrite', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => NginxRewriteRes.fromJson(d as Map<String, dynamic>));
  }

  /// List custom rewrite
  Future<ApiResponse<void>> getWebsitesRewriteCustom({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/websites/rewrite/custom', queryParameters: queryParameters);
  }

  /// Operate custom rewrite
  Future<ApiResponse<void>> postWebsitesRewriteCustom(CustomRewriteOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/rewrite/custom', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update rewrite conf
  Future<ApiResponse<void>> postWebsitesRewriteUpdate(NginxRewriteUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/rewrite/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page websites
  Future<ApiResponse<PageResult>> postWebsitesSearch(WebsiteSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/websites/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Create website ssl
  Future<ApiResponse<WebsiteSSLCreate>> postWebsitesSsl(WebsiteSSLCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<WebsiteSSLCreate>('/websites/ssl', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => WebsiteSSLCreate.fromJson(d as Map<String, dynamic>));
  }

  /// Search website ssl by id
  Future<ApiResponse<WebsiteSSLDTO>> getWebsitesSslId(String id, {Map<String, dynamic>? queryParameters}) async {
    return client.get<WebsiteSSLDTO>('/websites/ssl/$id', queryParameters: queryParameters, fromData: (d) => WebsiteSSLDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Delete website ssl
  Future<ApiResponse<void>> postWebsitesSslDel(WebsiteBatchDelReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ssl/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Download SSL  file
  Future<ApiResponse<void>> postWebsitesSslDownload(WebsiteResourceReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ssl/download', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Import master SSL
  Future<ApiResponse<void>> postWebsitesSslImport(WebsiteSSL request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ssl/import', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List website ssl
  Future<ApiResponse<void>> postWebsitesSslList(WebsiteSSLListReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ssl/list', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Apply  ssl
  Future<ApiResponse<void>> postWebsitesSslObtain(WebsiteSSLApply request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ssl/obtain', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Push ssl to nodes
  Future<ApiResponse<void>> postWebsitesSslPush(WebsiteSSLPush request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ssl/push', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Resolve website ssl
  Future<ApiResponse<void>> postWebsitesSslResolve(WebsiteDNSReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ssl/resolve', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page website ssl
  Future<ApiResponse<void>> postWebsitesSslSearch(WebsiteSSLSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ssl/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update ssl
  Future<ApiResponse<void>> postWebsitesSslUpdate(WebsiteSSLUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ssl/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Upload ssl
  Future<ApiResponse<void>> postWebsitesSslUpload(WebsiteSSLUpload request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ssl/upload', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Upload SSL file
  Future<ApiResponse<void>> postWebsitesSslUploadFile({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/ssl/upload/file', queryParameters: queryParameters);
  }

  /// Search website ssl by website id
  Future<ApiResponse<WebsiteSSLDTO>> getWebsitesSslWebsiteid(String websiteId, {Map<String, dynamic>? queryParameters}) async {
    return client.get<WebsiteSSLDTO>('/websites/ssl/website/$websiteId', queryParameters: queryParameters, fromData: (d) => WebsiteSSLDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Update Stream Config
  Future<ApiResponse<void>> postWebsitesStreamUpdate(StreamUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/stream/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create website template
  Future<ApiResponse<void>> postWebsitesTemplates(WebsiteTemplateCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/templates', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete website template
  Future<ApiResponse<void>> postWebsitesTemplatesDel(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/templates/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get website template
  Future<ApiResponse<WebsiteTemplateDTO>> postWebsitesTemplatesGet(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<WebsiteTemplateDTO>('/websites/templates/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => WebsiteTemplateDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Create website template output
  Future<ApiResponse<void>> postWebsitesTemplatesOutputs(WebsiteTemplateOutputCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/templates/outputs', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete website template output
  Future<ApiResponse<void>> postWebsitesTemplatesOutputsDel(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/templates/outputs/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get website template output
  Future<ApiResponse<WebsiteTemplateOutputDTO>> postWebsitesTemplatesOutputsGet(OperateByID request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<WebsiteTemplateOutputDTO>('/websites/templates/outputs/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => WebsiteTemplateOutputDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Page website template outputs
  Future<ApiResponse<PageResult>> postWebsitesTemplatesOutputsSearch(WebsiteTemplateOutputSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/websites/templates/outputs/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Preview website template
  Future<ApiResponse<WebsitePreviewDTO>> postWebsitesTemplatesPreview(WebsitePreviewReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<WebsitePreviewDTO>('/websites/templates/preview', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => WebsitePreviewDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Page website templates
  Future<ApiResponse<PageResult>> postWebsitesTemplatesSearch(WebsiteTemplateSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/websites/templates/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Update website template
  Future<ApiResponse<void>> postWebsitesTemplatesUpdate(WebsiteTemplateUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/templates/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Upload website template zip
  Future<ApiResponse<void>> postWebsitesTemplatesUpload({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/templates/upload', queryParameters: queryParameters);
  }

  /// Update website
  Future<ApiResponse<void>> postWebsitesUpdate(WebsiteUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/websites/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get website upstreams
  Future<ApiResponse<void>> getWebsitesIdLbs({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/websites/{id}/lbs', queryParameters: queryParameters);
  }

}