import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/server_model.dart';

const _kServersListKey = 'onedeck_servers_metadata_list';
const _kActiveServerIdKey = 'onedeck_active_server_id';

class ServerStorageService {
  final SharedPreferences? prefs;
  final FlutterSecureStorage secureStorage;

  const ServerStorageService({
    required this.prefs,
    this.secureStorage = const FlutterSecureStorage(),
  });

  /// Retrieve all stored servers metadata
  List<ServerModel> getServers() {
    final raw = prefs?.getString(_kServersListKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    try {
      return ServerModel.decodeList(raw);
    } catch (_) {
      return [];
    }
  }

  /// Save or update full list of servers
  Future<void> saveServers(List<ServerModel> servers) async {
    final encoded = ServerModel.encodeList(servers);
    await prefs?.setString(_kServersListKey, encoded);
  }

  /// Get the active server ID
  String? getActiveServerId() {
    return prefs?.getString(_kActiveServerIdKey);
  }

  /// Set the active server ID
  Future<void> setActiveServerId(String? id) async {
    if (id == null) {
      await prefs?.remove(_kActiveServerIdKey);
    } else {
      await prefs?.setString(_kActiveServerIdKey, id);
    }
  }

  /// Securely retrieve API Token for a specific server
  Future<String?> getServerToken(String serverId) async {
    return await secureStorage.read(key: 'onedeck_token_$serverId');
  }

  /// Securely save API Token for a specific server
  Future<void> saveServerToken(String serverId, String token) async {
    await secureStorage.write(key: 'onedeck_token_$serverId', value: token);
  }

  /// Remove API Token when deleting server
  Future<void> deleteServerToken(String serverId) async {
    await secureStorage.delete(key: 'onedeck_token_$serverId');
  }

  /// Delete server and its token
  Future<void> deleteServer(String serverId) async {
    final current = getServers();
    final updated = current.where((s) => s.id != serverId).toList();
    await saveServers(updated);
    await deleteServerToken(serverId);

    if (getActiveServerId() == serverId) {
      final nextId = updated.isNotEmpty ? updated.first.id : null;
      await setActiveServerId(nextId);
    }
  }
}
