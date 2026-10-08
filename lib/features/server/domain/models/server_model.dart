import 'dart:convert';

/// Represents a configured 1Panel V2 server instance.
class ServerModel {
  final String id;
  final String name;
  final String host;
  final int port;
  final bool isSsl;
  final String entry;
  final bool allowSelfSigned;
  final DateTime createdAt;
  final DateTime? lastConnectedAt;
  final int? lastLatencyMs;
  final bool? isOnline;

  const ServerModel({
    required this.id,
    required this.name,
    required this.host,
    this.port = 9999,
    this.isSsl = false,
    this.entry = '',
    this.allowSelfSigned = true,
    required this.createdAt,
    this.lastConnectedAt,
    this.lastLatencyMs,
    this.isOnline,
  });

  /// Human-readable display URL (e.g., `https://192.168.1.100:9999` or `https://demo.1panel.pro`)
  String get displayUrl {
    final scheme = isSsl ? 'https' : 'http';
    final isDefaultPort = (isSsl && port == 443) || (!isSsl && port == 80) || port <= 0;
    final portSuffix = isDefaultPort ? '' : ':$port';
    final cleanEntry = entry.trim().replaceAll(RegExp(r'^/+|/+$'), '');
    final entrySuffix = cleanEntry.isNotEmpty ? '/$cleanEntry' : '';
    return '$scheme://$host$portSuffix$entrySuffix';
  }

  ServerModel copyWith({
    String? id,
    String? name,
    String? host,
    int? port,
    bool? isSsl,
    String? entry,
    bool? allowSelfSigned,
    DateTime? createdAt,
    DateTime? lastConnectedAt,
    int? lastLatencyMs,
    bool? isOnline,
  }) {
    return ServerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      port: port ?? this.port,
      isSsl: isSsl ?? this.isSsl,
      entry: entry ?? this.entry,
      allowSelfSigned: allowSelfSigned ?? this.allowSelfSigned,
      createdAt: createdAt ?? this.createdAt,
      lastConnectedAt: lastConnectedAt ?? this.lastConnectedAt,
      lastLatencyMs: lastLatencyMs ?? this.lastLatencyMs,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
      'isSsl': isSsl,
      'entry': entry,
      'allowSelfSigned': allowSelfSigned,
      'createdAt': createdAt.toIso8601String(),
      'lastConnectedAt': lastConnectedAt?.toIso8601String(),
      'lastLatencyMs': lastLatencyMs,
      'isOnline': isOnline,
    };
  }

  factory ServerModel.fromJson(Map<String, dynamic> json) {
    return ServerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      host: json['host'] as String,
      port: json['port'] as int? ?? 9999,
      isSsl: json['isSsl'] as bool? ?? false,
      entry: json['entry'] as String? ?? '',
      allowSelfSigned: json['allowSelfSigned'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastConnectedAt: json['lastConnectedAt'] != null
          ? DateTime.parse(json['lastConnectedAt'] as String)
          : null,
      lastLatencyMs: json['lastLatencyMs'] as int?,
      isOnline: json['isOnline'] as bool?,
    );
  }

  static List<ServerModel> decodeList(String rawJson) {
    final list = jsonDecode(rawJson) as List<dynamic>;
    return list.map((e) => ServerModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String encodeList(List<ServerModel> servers) {
    return jsonEncode(servers.map((e) => e.toJson()).toList());
  }
}
