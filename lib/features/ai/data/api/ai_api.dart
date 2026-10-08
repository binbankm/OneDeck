// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/ai_models.dart';

class AiApi {
  final DioClient client;

  const AiApi(this.client);

  /// Create model account
  Future<ApiResponse<void>> postAccounts(AgentAccountCreateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/accounts', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Count model accounts by provider
  Future<ApiResponse<void>> postAccountsCounts(AgentAccountProviderCountReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/accounts/counts', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete model account
  Future<ApiResponse<void>> postAccountsDelete(AgentAccountDeleteReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/accounts/delete', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List model account models
  Future<ApiResponse<void>> postAccountsModels(AgentAccountModelReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/accounts/models', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create model account model
  Future<ApiResponse<void>> postAccountsModelsCreate(AgentAccountModelCreateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/accounts/models/create', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete model account model
  Future<ApiResponse<void>> postAccountsModelsDelete(AgentAccountModelDeleteReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/accounts/models/delete', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Discover custom provider models
  Future<ApiResponse<void>> postAccountsModelsDiscover(AgentAccountModelDiscoverReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/accounts/models/discover', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update model account model
  Future<ApiResponse<void>> postAccountsModelsUpdate(AgentAccountModelUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/accounts/models/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get model account providers
  Future<ApiResponse<void>> getAccountsProviders({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/ai/accounts/providers', queryParameters: queryParameters);
  }

  /// Page model accounts
  Future<ApiResponse<PageResult>> postAccountsSearch(AgentAccountSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/ai/accounts/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Update model account
  Future<ApiResponse<void>> postAccountsUpdate(AgentAccountUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/accounts/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Verify model account
  Future<ApiResponse<void>> postAccountsVerify(AgentAccountVerifyReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/accounts/verify', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create Agent
  Future<ApiResponse<AgentItem>> postAgents(AgentCreateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentItem>('/ai/agents', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentItem.fromJson(d as Map<String, dynamic>));
  }

  /// Bind Agent role channel
  Future<ApiResponse<void>> postAgentsAgentBind(AgentRoleBindReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/agent/bind', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Agent role channels from config file
  Future<ApiResponse<void>> postAgentsAgentChannels(AgentRoleChannelsReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/agent/channels', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create Agent role
  Future<ApiResponse<AgentRoleCreateResp>> postAgentsAgentCreate(AgentRoleCreateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentRoleCreateResp>('/ai/agents/agent/create', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentRoleCreateResp.fromJson(d as Map<String, dynamic>));
  }

  /// Delete Agent role
  Future<ApiResponse<void>> postAgentsAgentDelete(AgentRoleDeleteReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/agent/delete', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get configured Agent roles from config file
  Future<ApiResponse<void>> postAgentsAgentList(AgentConfiguredAgentsReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/agent/list', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Agent role markdown files
  Future<ApiResponse<void>> postAgentsAgentMdList(AgentRoleMarkdownFilesReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/agent/md/list', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update Agent role markdown file
  Future<ApiResponse<void>> postAgentsAgentMdUpdate(AgentRoleMarkdownFilesUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/agent/md/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Unbind Agent role channel
  Future<ApiResponse<void>> postAgentsAgentUnbind(AgentRoleBindReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/agent/unbind', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Batch install Agent
  Future<ApiResponse<AgentItem>> postAgentsBatchInstall(AgentBatchInstallReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentItem>('/ai/agents/batch/install', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentItem.fromJson(d as Map<String, dynamic>));
  }

  /// Batch operate Agent
  Future<ApiResponse<void>> postAgentsBatchOperate(AgentBatchOperateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/batch/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Batch install Agent Skill
  Future<ApiResponse<void>> postAgentsBatchSkillInstall(AgentBatchSkillInstallReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/batch/skill/install', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Batch upgrade Agent
  Future<ApiResponse<void>> postAgentsBatchUpgrade(AgentBatchUpgradeReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/batch/upgrade', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete Agent channel config
  Future<ApiResponse<void>> postAgentsChannelDelete(AgentChannelDeleteReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/channel/delete', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Agent DingTalk channel config
  Future<ApiResponse<AgentDingTalkConfig>> postAgentsChannelDingtalkGet(AgentIDReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentDingTalkConfig>('/ai/agents/channel/dingtalk/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentDingTalkConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update Agent DingTalk channel config
  Future<ApiResponse<void>> postAgentsChannelDingtalkUpdate(AgentDingTalkConfigUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/channel/dingtalk/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Agent Discord channel config
  Future<ApiResponse<AgentDiscordConfig>> postAgentsChannelDiscordGet(AgentIDReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentDiscordConfig>('/ai/agents/channel/discord/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentDiscordConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update Agent Discord channel config
  Future<ApiResponse<void>> postAgentsChannelDiscordUpdate(AgentDiscordConfigUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/channel/discord/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Agent Feishu channel config
  Future<ApiResponse<AgentFeishuConfig>> postAgentsChannelFeishuGet(AgentFeishuConfigReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentFeishuConfig>('/ai/agents/channel/feishu/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentFeishuConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update Agent Feishu channel config
  Future<ApiResponse<void>> postAgentsChannelFeishuUpdate(AgentFeishuConfigUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/channel/feishu/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Approve Agent channel pairing code
  Future<ApiResponse<void>> postAgentsChannelPairingApprove(AgentChannelPairingApproveReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/channel/pairing/approve', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Agent QQ Bot channel config
  Future<ApiResponse<AgentQQBotConfig>> postAgentsChannelQqbotGet(AgentIDReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentQQBotConfig>('/ai/agents/channel/qqbot/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentQQBotConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update Agent QQ Bot channel config
  Future<ApiResponse<void>> postAgentsChannelQqbotUpdate(AgentQQBotConfigUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/channel/qqbot/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Agent Telegram channel config
  Future<ApiResponse<AgentTelegramConfig>> postAgentsChannelTelegramGet(AgentTelegramConfigReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentTelegramConfig>('/ai/agents/channel/telegram/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentTelegramConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update Agent Telegram channel config
  Future<ApiResponse<void>> postAgentsChannelTelegramUpdate(AgentTelegramConfigUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/channel/telegram/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Agent QQ Bot channel config
  Future<ApiResponse<AgentWecomConfig>> postAgentsChannelWecomGet(AgentIDReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentWecomConfig>('/ai/agents/channel/wecom/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentWecomConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update Agent WeCom channel config
  Future<ApiResponse<void>> postAgentsChannelWecomUpdate(AgentWecomConfigUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/channel/wecom/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Agent Weixin channel config
  Future<ApiResponse<AgentWeixinConfig>> postAgentsChannelWeixinGet(AgentIDReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentWeixinConfig>('/ai/agents/channel/weixin/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentWeixinConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Login Agent Weixin channel
  Future<ApiResponse<void>> postAgentsChannelWeixinLogin(AgentWeixinLoginReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/channel/weixin/login', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Agent config file
  Future<ApiResponse<AgentConfigFile>> postagentsconfigFileget(AgentConfigFileReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentConfigFile>('/ai/agents/config-file/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentConfigFile.fromJson(d as Map<String, dynamic>));
  }

  /// Update Agent config file
  Future<ApiResponse<void>> postagentsconfigFileupdate(AgentConfigFileUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/config-file/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete Agent
  Future<ApiResponse<void>> postAgentsDelete(AgentDeleteReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/delete', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete check Agent
  Future<ApiResponse<void>> postAgentsDeleteCheck(AgentIDReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/delete/check', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Hermes chat sessions
  Future<ApiResponse<void>> postAgentsHermesChatSessions(AgentIDReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/hermes/chat/sessions', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete Hermes chat session
  Future<ApiResponse<void>> postAgentsHermesChatSessionsDelete(AgentHermesChatSessionDeleteReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/hermes/chat/sessions/delete', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Rename Hermes chat session
  Future<ApiResponse<void>> postAgentsHermesChatSessionsRename(AgentHermesChatSessionRenameReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/hermes/chat/sessions/rename', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Agent model config
  Future<ApiResponse<AgentModelConfig>> postAgentsModelGet(AgentIDReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentModelConfig>('/ai/agents/model/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentModelConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update Agent model config
  Future<ApiResponse<void>> postAgentsModelUpdate(AgentModelConfigUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/model/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Agent Other config
  Future<ApiResponse<AgentOtherConfig>> postAgentsOtherGet(AgentIDReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentOtherConfig>('/ai/agents/other/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentOtherConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update Agent Other config
  Future<ApiResponse<void>> postAgentsOtherUpdate(AgentOtherConfigUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/other/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get Agent overview
  Future<ApiResponse<AgentOverview>> postAgentsOverview(AgentOverviewReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentOverview>('/ai/agents/overview', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentOverview.fromJson(d as Map<String, dynamic>));
  }

  /// Check Agent plugin installation status
  Future<ApiResponse<AgentPluginStatus>> postAgentsPluginCheck(AgentPluginCheckReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentPluginStatus>('/ai/agents/plugin/check', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentPluginStatus.fromJson(d as Map<String, dynamic>));
  }

  /// Install Agent plugin
  Future<ApiResponse<void>> postAgentsPluginInstall(AgentPluginInstallReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/plugin/install', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Uninstall Agent plugin
  Future<ApiResponse<void>> postAgentsPluginUninstall(AgentPluginUninstallReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/plugin/uninstall', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Upgrade Agent plugin
  Future<ApiResponse<void>> postAgentsPluginUpgrade(AgentPluginUpgradeReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/plugin/upgrade', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Install an OpenClaw marketplace plugin
  Future<ApiResponse<void>> postAgentsPluginsInstall(AgentPluginMarketInstallReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/plugins/install', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List OpenClaw plugins
  Future<ApiResponse<void>> postAgentsPluginsList(AgentPluginsReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/plugins/list', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Operate an OpenClaw plugin
  Future<ApiResponse<void>> postAgentsPluginsOperate(AgentPluginOperateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/plugins/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Search OpenClaw plugins
  Future<ApiResponse<void>> postAgentsPluginsSearch(AgentPluginSearchReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/plugins/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update Agent remark
  Future<ApiResponse<void>> postAgentsRemark(AgentRemarkUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/remark', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page Agents
  Future<ApiResponse<PageResult>> postAgentsSearch(SearchWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/ai/agents/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Get Agent Security config
  Future<ApiResponse<AgentSecurityConfig>> postAgentsSecurityGet(AgentIDReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<AgentSecurityConfig>('/ai/agents/security/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => AgentSecurityConfig.fromJson(d as Map<String, dynamic>));
  }

  /// Update Agent Security config
  Future<ApiResponse<void>> postAgentsSecurityUpdate(AgentSecurityConfigUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/security/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Install Agent skill
  Future<ApiResponse<void>> postAgentsSkillsInstall(AgentSkillInstallReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/skills/install', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List Agent skills
  Future<ApiResponse<void>> postAgentsSkillsList(AgentIDReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/skills/list', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Search Agent skills
  Future<ApiResponse<void>> postAgentsSkillsSearch(AgentSkillSearchReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/skills/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Uninstall Agent skill
  Future<ApiResponse<void>> postAgentsSkillsUninstall(AgentSkillUninstallReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/skills/uninstall', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update Agent skill status
  Future<ApiResponse<void>> postAgentsSkillsUpdate(AgentSkillUpdateReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/skills/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Reset Agent token
  Future<ApiResponse<void>> postAgentsTokenReset(AgentTokenResetReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/token/reset', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Bind Agent website
  Future<ApiResponse<void>> postAgentsWebsiteBind(AgentWebsiteBindReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/website/bind', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Unbind Agent website
  Future<ApiResponse<void>> postAgentsWebsiteUnbind(AgentIDReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/agents/website/unbind', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Bind domain
  Future<ApiResponse<void>> postDomainBind(OllamaBindDomain request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/domain/bind', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get bind domain
  Future<ApiResponse<OllamaBindDomainRes>> postDomainGet(OllamaBindDomainReq request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<OllamaBindDomainRes>('/ai/domain/get', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => OllamaBindDomainRes.fromJson(d as Map<String, dynamic>));
  }

  /// Update bind domain
  Future<ApiResponse<void>> postDomainUpdate(OllamaBindDomain request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/domain/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load gpu / xpu info
  Future<ApiResponse<void>> getGpuLoad({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/ai/gpu/load', queryParameters: queryParameters);
  }

  /// Get CPU options
  Future<ApiResponse<void>> getGpuOptions({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/ai/gpu/options', queryParameters: queryParameters);
  }

  /// Bind Domain for mcp server
  Future<ApiResponse<void>> postMcpDomainBind(McpBindDomain request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/mcp/domain/bind', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Get bin Domain for mcp server
  Future<ApiResponse<McpBindDomainRes>> getMcpDomainGet({Map<String, dynamic>? queryParameters}) async {
    return client.get<McpBindDomainRes>('/ai/mcp/domain/get', queryParameters: queryParameters, fromData: (d) => McpBindDomainRes.fromJson(d as Map<String, dynamic>));
  }

  /// Update bind Domain for mcp server
  Future<ApiResponse<void>> postMcpDomainUpdate(McpBindDomainUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/mcp/domain/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// List mcp servers
  Future<ApiResponse<McpServersRes>> postMcpSearch(McpServerSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<McpServersRes>('/ai/mcp/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => McpServersRes.fromJson(d as Map<String, dynamic>));
  }

  /// Create mcp server
  Future<ApiResponse<void>> postMcpServer(McpServerCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/mcp/server', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Test mcp server connection
  Future<ApiResponse<McpServerConnectionTestRes>> postMcpServerConnectionTest(McpServerConnectionTest request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<McpServerConnectionTestRes>('/ai/mcp/server/connection/test', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => McpServerConnectionTestRes.fromJson(d as Map<String, dynamic>));
  }

  /// Delete mcp server
  Future<ApiResponse<void>> postMcpServerDel(McpServerDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/mcp/server/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Load mcp server detail
  Future<ApiResponse<McpServerDTO>> postMcpServerDetail(McpServerDetail request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<McpServerDTO>('/ai/mcp/server/detail', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => McpServerDTO.fromJson(d as Map<String, dynamic>));
  }

  /// Operate mcp server
  Future<ApiResponse<void>> postMcpServerOp(McpServerOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/mcp/server/op', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Sync mcp server status
  Future<ApiResponse<void>> postMcpServerStatusSync(McpServerStatusSync request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/mcp/server/status/sync', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update mcp server
  Future<ApiResponse<void>> postMcpServerUpdate(McpServerUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/mcp/server/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Close Ollama model conn
  Future<ApiResponse<void>> postOllamaClose(OllamaModelName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/ollama/close', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Create Ollama model
  Future<ApiResponse<void>> postOllamaModel(OllamaModelName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/ollama/model', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete Ollama model
  Future<ApiResponse<void>> postOllamaModelDel(ForceDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/ollama/model/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page Ollama models
  Future<ApiResponse<void>> postOllamaModelLoad(OllamaModelName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/ollama/model/load', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Rereate Ollama model
  Future<ApiResponse<void>> postOllamaModelRecreate(OllamaModelName request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/ollama/model/recreate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page Ollama models
  Future<ApiResponse<PageResult>> postOllamaModelSearch(SearchWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/ai/ollama/model/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Sync Ollama model list
  Future<ApiResponse<void>> postOllamaModelSync({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/ollama/model/sync', queryParameters: queryParameters);
  }

  /// Create TensorRT LLM
  Future<ApiResponse<void>> postTensorrtCreate(TensorRTLLMCreate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/tensorrt/create', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete TensorRT LLM
  Future<ApiResponse<void>> postTensorrtDelete(TensorRTLLMDelete request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/tensorrt/delete', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Operate TensorRT LLM
  Future<ApiResponse<void>> postTensorrtOperate(TensorRTLLMOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/tensorrt/operate', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Page TensorRT LLMs
  Future<ApiResponse<void>> postTensorrtSearch(TensorRTLLMSearch request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/tensorrt/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update TensorRT LLM
  Future<ApiResponse<void>> postTensorrtUpdate(TensorRTLLMUpdate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/ai/tensorrt/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

}