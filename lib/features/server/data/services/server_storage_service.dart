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
  /// Securely retrieve API Token for a specific server (with fallback if OS keychain unavailable)
  Future<String?> getServerToken(String serverId) async {
    try {
      final token = await secureStorage.read(key: 'onedeck_token_$serverId');
      if (token != null && token.isNotEmpty) {
        return token;
      }
    } catch (_) {
      // Keychain read failed (e.g. -34018 entitlement error on macOS debug)
    }
    return prefs?.getString('onedeck_fallback_token_$serverId');
  }

  /// Securely save API Token for a specific server (with automatic fallback to prefs)
  Future<void> saveServerToken(String serverId, String token) async {
    try {
      await secureStorage.write(key: 'onedeck_token_$serverId', value: token);
    } catch (e) {
      // In macOS unsigned debug builds or environments without hardware keychain access,
      // fall back to app preferences to ensure seamless execution.
      await prefs?.setString('onedeck_fallback_token_$serverId', token);
    }
  }

  /// Remove API Token when deleting server
  Future<void> deleteServerToken(String serverId) async {
    try {
      await secureStorage.delete(key: 'onedeck_token_$serverId');
    } catch (_) {}
    await prefs?.remove('onedeck_fallback_token_$serverId');
  }
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
