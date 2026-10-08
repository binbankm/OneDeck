import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/services/server_storage_service.dart';
import '../../domain/models/server_model.dart';

/// Global singleton [DioClient] instance shared across the entire app.
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

/// Provider for [ServerStorageService].
final serverStorageServiceProvider = Provider<ServerStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ServerStorageService(prefs: prefs);
});

/// Manages the list of all configured [ServerModel]s.
class ServersNotifier extends StateNotifier<List<ServerModel>> {
  final ServerStorageService _storage;

  ServersNotifier(this._storage) : super(_storage.getServers());

  Future<void> addOrUpdateServer(ServerModel server, String token) async {
    final existingIndex = state.indexWhere((s) => s.id == server.id);
    List<ServerModel> updated;
    if (existingIndex >= 0) {
      updated = [...state];
      updated[existingIndex] = server;
    } else {
      updated = [...state, server];
    }
    state = updated;
    await _storage.saveServers(updated);
    if (token.isNotEmpty) {
      await _storage.saveServerToken(server.id, token);
    }
  }

  Future<void> deleteServer(String serverId) async {
    state = state.where((s) => s.id != serverId).toList();
    await _storage.deleteServer(serverId);
  }

  Future<void> updateHealthStatus(String serverId, {required bool isOnline, required int latencyMs}) async {
    final updated = state.map((s) {
      if (s.id == serverId) {
        return s.copyWith(
          isOnline: isOnline,
          lastLatencyMs: latencyMs,
          lastConnectedAt: DateTime.now(),
        );
      }
      return s;
    }).toList();
    state = updated;
    await _storage.saveServers(updated);
  }
}

final serversProvider = StateNotifierProvider<ServersNotifier, List<ServerModel>>((ref) {
  final storage = ref.watch(serverStorageServiceProvider);
  return ServersNotifier(storage);
});

/// Manages the currently selected/active server ID.
class ActiveServerIdNotifier extends StateNotifier<String?> {
  final ServerStorageService _storage;
  final Ref _ref;

  ActiveServerIdNotifier(this._storage, this._ref) : super(_storage.getActiveServerId()) {
    // Initial validation
    final servers = _storage.getServers();
    if (state == null && servers.isNotEmpty) {
      state = servers.first.id;
      _storage.setActiveServerId(state);
    }
    _reconfigureDio();
  }

  Future<void> selectServer(String serverId) async {
    if (state == serverId) return;
    state = serverId;
    await _storage.setActiveServerId(serverId);
    await _reconfigureDio();
  }

  Future<void> _reconfigureDio() async {
    final activeId = state;
    if (activeId == null) return;
    final servers = _ref.read(serversProvider);
    final activeServer = servers.where((s) => s.id == activeId).firstOrNull;
    if (activeServer == null) return;

    final token = await _storage.getServerToken(activeId);
    final dioClient = _ref.read(dioClientProvider);

    dioClient.updateServer(
      host: activeServer.host,
      port: activeServer.port,
      isHttps: activeServer.isSsl,
      entryPath: activeServer.entry,
      allowSelfSigned: activeServer.allowSelfSigned,
    );
    dioClient.setToken(token);
  }
}

final activeServerIdProvider = StateNotifierProvider<ActiveServerIdNotifier, String?>((ref) {
  final storage = ref.watch(serverStorageServiceProvider);
  return ActiveServerIdNotifier(storage, ref);
});

/// Returns the currently active [ServerModel] (or null if none configured).
final activeServerProvider = Provider<ServerModel?>((ref) {
  final activeId = ref.watch(activeServerIdProvider);
  final servers = ref.watch(serversProvider);
  if (activeId == null) return servers.firstOrNull;
  return servers.where((s) => s.id == activeId).firstOrNull ?? servers.firstOrNull;
});

/// Test connection result helper
class ConnectionTestResult {
  final bool isSuccess;
  final int latencyMs;
  final String? errorMessage;

  const ConnectionTestResult({
    required this.isSuccess,
    required this.latencyMs,
    this.errorMessage,
  });
}

/// Provider for testing connection to any 1Panel instance with latency measurement
final testConnectionProvider = Provider<Future<ConnectionTestResult> Function(ServerModel server, String token)>((ref) {
  return (ServerModel server, String token) async {
    final testClient = DioClient(
      allowSelfSigned: server.allowSelfSigned,
      timeout: const Duration(seconds: 8),
    );

    testClient.updateServer(
      host: server.host,
      port: server.port,
      isHttps: server.isSsl,
      entryPath: server.entry,
      allowSelfSigned: server.allowSelfSigned,
    );
    testClient.setToken(token);

    final stopwatch = Stopwatch()..start();
    try {
      // 1Panel V2 endpoint for captcha (publicly available without auth, verifies network & entry path)
      await testClient.get('core/auth/captcha');
      stopwatch.stop();
      return ConnectionTestResult(
        isSuccess: true,
        latencyMs: stopwatch.elapsedMilliseconds,
      );
    } catch (e) {
      stopwatch.stop();
      return ConnectionTestResult(
        isSuccess: false,
        latencyMs: stopwatch.elapsedMilliseconds,
        errorMessage: e.toString(),
      );
    }
  };
});
