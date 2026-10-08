// GENERATED CODE - DO NOT MODIFY BY HAND
// 1Panel V2 OpenAPI Generated API Client

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_response.dart';
import '../models/terminal_models.dart';

class TerminalApi {
  final DioClient client;

  const TerminalApi(this.client);

  /// Create command
  Future<ApiResponse<void>> postCommands(CommandOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/commands', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Delete command
  Future<ApiResponse<void>> postCommandsDel(OperateByIDs request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/commands/del', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Export command
  Future<ApiResponse<void>> postCommandsExport({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/commands/export', queryParameters: queryParameters);
  }

  /// Import command
  Future<ApiResponse<void>> postCommandsImport({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/commands/import', queryParameters: queryParameters);
  }

  /// List commands
  Future<ApiResponse<CommandInfo>> postCommandsList(OperateByType request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<CommandInfo>('/core/commands/list', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => CommandInfo.fromJson(d as Map<String, dynamic>));
  }

  /// Page commands
  Future<ApiResponse<PageResult>> postCommandsSearch(SearchWithPage request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<PageResult>('/core/commands/search', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters, fromData: (d) => PageResult.fromJson(d as Map<String, dynamic>));
  }

  /// Tree commands
  Future<ApiResponse<void>> postCommandsTree(OperateByType request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/commands/tree', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Update command
  Future<ApiResponse<void>> postCommandsUpdate(CommandOperate request, {Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/commands/update', data: request is Map ? request : (request as dynamic).toJson(), queryParameters: queryParameters);
  }

  /// Upload command csv for list
  Future<ApiResponse<void>> postCommandsUpload({Map<String, dynamic>? queryParameters}) async {
    return client.post<void>('/core/commands/upload', queryParameters: queryParameters);
  }

  /// Ws container terminal
  Future<ApiResponse<void>> getHostsContainer({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/hosts/terminal/container', queryParameters: queryParameters);
  }

  /// Ws local terminal
  Future<ApiResponse<void>> getHostsLocal({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/hosts/terminal/local', queryParameters: queryParameters);
  }

  /// Ws host SSH
  Future<ApiResponse<void>> getHostsSsh({Map<String, dynamic>? queryParameters}) async {
    return client.get<void>('/hosts/terminal/ssh', queryParameters: queryParameters);
  }

}