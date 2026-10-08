import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../server/presentation/providers/server_provider.dart';
import '../../data/api/dashboard_api.dart';
import '../../data/models/dashboard_models.dart';

final dashboardApiProvider = Provider<DashboardApi>((ref) {
  final client = ref.watch(dioClientProvider);
  return DashboardApi(client);
});

class DashboardState {
  final DashboardBase? base;
  final DashboardCurrent? current;
  final List<double> cpuHistory;
  final List<double> memoryHistory;
  final List<double> netDownHistory;
  final List<double> netUpHistory;
  final List<double> loadHistory;
  final List<Process> topCpuProcesses;
  final List<Process> topMemProcesses;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? lastUpdated;
  final int selectedChartTab; // 0: CPU, 1: Memory, 2: Network, 3: Load

  const DashboardState({
    this.base,
    this.current,
    this.cpuHistory = const [],
    this.memoryHistory = const [],
    this.netDownHistory = const [],
    this.netUpHistory = const [],
    this.loadHistory = const [],
    this.topCpuProcesses = const [],
    this.topMemProcesses = const [],
    this.isLoading = false,
    this.errorMessage,
    this.lastUpdated,
    this.selectedChartTab = 0,
  });

  DashboardState copyWith({
    DashboardBase? base,
    DashboardCurrent? current,
    List<double>? cpuHistory,
    List<double>? memoryHistory,
    List<double>? netDownHistory,
    List<double>? netUpHistory,
    List<double>? loadHistory,
    List<Process>? topCpuProcesses,
    List<Process>? topMemProcesses,
    bool? isLoading,
    String? errorMessage,
    DateTime? lastUpdated,
    int? selectedChartTab,
  }) {
    return DashboardState(
      base: base ?? this.base,
      current: current ?? this.current,
      cpuHistory: cpuHistory ?? this.cpuHistory,
      memoryHistory: memoryHistory ?? this.memoryHistory,
      netDownHistory: netDownHistory ?? this.netDownHistory,
      netUpHistory: netUpHistory ?? this.netUpHistory,
      loadHistory: loadHistory ?? this.loadHistory,
      topCpuProcesses: topCpuProcesses ?? this.topCpuProcesses,
      topMemProcesses: topMemProcesses ?? this.topMemProcesses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      selectedChartTab: selectedChartTab ?? this.selectedChartTab,
    );
  }
}

class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardApi _api;
  final Ref _ref;
  Timer? _pollingTimer;
  int _lastNetRecv = 0;
  int _lastNetSent = 0;
  DateTime? _lastPollTime;
  int _pollCount = 0;

  DashboardNotifier(this._api, this._ref) : super(const DashboardState()) {
    init();
  }

  void init() {
    loadAllData();
    _startPolling();
  }

  void _startPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      final activeServer = _ref.read(activeServerProvider);
      if (activeServer != null) {
        pollCurrentMetrics();
      }
    });
  }

  Future<void> _ensureClientConfigured() async {
    final activeServer = _ref.read(activeServerProvider);
    if (activeServer == null) return;
    final storage = _ref.read(serverStorageServiceProvider);
    final token = await storage.getServerToken(activeServer.id);
    final client = _ref.read(dioClientProvider);
    client.updateServer(
      host: activeServer.host,
      port: activeServer.port,
      isHttps: activeServer.isSsl,
      entryPath: activeServer.entry,
      allowSelfSigned: activeServer.allowSelfSigned,
    );
    client.setToken(token);
  }

  Future<void> loadAllData() async {
    final activeServer = _ref.read(activeServerProvider);
    if (activeServer == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    state = state.copyWith(isLoading: state.base == null, errorMessage: null);

    final sw = Stopwatch()..start();
    try {
      await _ensureClientConfigured();
      final baseRes = await _api.getBaseIooptionNetoption('all', 'all');
      final currentRes = await _api.getCurrentIooptionNetoption('all', 'all');
      sw.stop();

      // Realtime latency update
      final latency = sw.elapsedMilliseconds;
      _ref.read(serversProvider.notifier).updateHealthStatus(
        activeServer.id,
        isOnline: true,
        latencyMs: latency,
      );

      final base = baseRes.data;
      final current = currentRes.data;

      List<Process> topCpu = [];
      List<Process> topMem = [];
      try {
        final cpuRes = await _api.getCurrentTopCpu();
        final memRes = await _api.getCurrentTopMem();
        topCpu = cpuRes.data ?? [];
        topMem = memRes.data ?? [];
      } catch (_) {}

      final now = DateTime.now();
      final cpuVal = current?.cpuUsedPercent ?? 0.0;
      final memVal = current?.memoryUsedPercent ?? 0.0;
      final loadVal = current?.load1 ?? 0.0;

      // Rate calculation
      double downRate = 0.0;
      double upRate = 0.0;
      if (current != null && _lastPollTime != null && _lastNetRecv > 0) {
        final sec = now.difference(_lastPollTime!).inMilliseconds / 1000.0;
        if (sec > 0.5) {
          downRate = ((current.netBytesRecv - _lastNetRecv) / sec).clamp(0, double.infinity);
          upRate = ((current.netBytesSent - _lastNetSent) / sec).clamp(0, double.infinity);
        }
      }
      if (current != null) {
        _lastNetRecv = current.netBytesRecv;
        _lastNetSent = current.netBytesSent;
        _lastPollTime = now;
      }

      state = state.copyWith(
        base: base,
        current: current,
        cpuHistory: _appendHistory(state.cpuHistory, cpuVal),
        memoryHistory: _appendHistory(state.memoryHistory, memVal),
        netDownHistory: _appendHistory(state.netDownHistory, downRate),
        netUpHistory: _appendHistory(state.netUpHistory, upRate),
        loadHistory: _appendHistory(state.loadHistory, loadVal),
        topCpuProcesses: topCpu.isNotEmpty ? topCpu : state.topCpuProcesses,
        topMemProcesses: topMem.isNotEmpty ? topMem : state.topMemProcesses,
        isLoading: false,
        errorMessage: null,
        lastUpdated: now,
      );
    } catch (e) {
      sw.stop();
      _ref.read(serversProvider.notifier).updateHealthStatus(
        activeServer.id,
        isOnline: false,
        latencyMs: 0,
      );
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> pollCurrentMetrics() async {
    final activeServer = _ref.read(activeServerProvider);
    if (activeServer == null) return;

    final sw = Stopwatch()..start();
    try {
      await _ensureClientConfigured();
      final currentRes = await _api.getCurrentIooptionNetoption('all', 'all');
      sw.stop();

      // Realtime latency update
      final latency = sw.elapsedMilliseconds;
      _ref.read(serversProvider.notifier).updateHealthStatus(
        activeServer.id,
        isOnline: true,
        latencyMs: latency,
      );

      final current = currentRes.data;
      if (current == null) return;

      final now = DateTime.now();
      final cpuVal = current.cpuUsedPercent;
      final memVal = current.memoryUsedPercent;
      final loadVal = current.load1;

      // Calculate instantaneous network speed
      double downRate = 0.0;
      double upRate = 0.0;
      if (_lastPollTime != null && _lastNetRecv > 0) {
        final sec = now.difference(_lastPollTime!).inMilliseconds / 1000.0;
        if (sec > 0.5) {
          downRate = ((current.netBytesRecv - _lastNetRecv) / sec).clamp(0, double.infinity);
          upRate = ((current.netBytesSent - _lastNetSent) / sec).clamp(0, double.infinity);
        }
      }
      _lastNetRecv = current.netBytesRecv;
      _lastNetSent = current.netBytesSent;
      _lastPollTime = now;

      _pollCount++;
      List<Process>? newTopCpu;
      List<Process>? newTopMem;
      if (_pollCount % 2 == 0 || state.topCpuProcesses.isEmpty) {
        try {
          final cpuRes = await _api.getCurrentTopCpu();
          final memRes = await _api.getCurrentTopMem();
          newTopCpu = cpuRes.data;
          newTopMem = memRes.data;
        } catch (_) {}
      }

      // If base is missing, fetch it
      DashboardBase? base = state.base;
      if (base == null) {
        try {
          final bRes = await _api.getBaseIooptionNetoption('all', 'all');
          base = bRes.data;
        } catch (_) {}
      }

      state = state.copyWith(
        base: base ?? state.base,
        current: current,
        cpuHistory: _appendHistory(state.cpuHistory, cpuVal),
        memoryHistory: _appendHistory(state.memoryHistory, memVal),
        netDownHistory: _appendHistory(state.netDownHistory, downRate),
        netUpHistory: _appendHistory(state.netUpHistory, upRate),
        loadHistory: _appendHistory(state.loadHistory, loadVal),
        topCpuProcesses: newTopCpu ?? state.topCpuProcesses,
        topMemProcesses: newTopMem ?? state.topMemProcesses,
        lastUpdated: now,
        errorMessage: null,
      );
    } catch (e) {
      sw.stop();
      _ref.read(serversProvider.notifier).updateHealthStatus(
        activeServer.id,
        isOnline: false,
        latencyMs: 0,
      );
      if (state.base == null) {
        state = state.copyWith(errorMessage: e.toString());
      }
    }
  }

  List<double> _appendHistory(List<double> list, double value) {
    const maxLen = 20;
    final updated = [...list, value];
    if (updated.length > maxLen) {
      return updated.sublist(updated.length - maxLen);
    }
    // Pad initial history so chart curves looks complete
    if (updated.length < 5) {
      return [
        ...List.filled(5 - updated.length, value),
        ...updated,
      ];
    }
    return updated;
  }

  void selectChartTab(int index) {
    state = state.copyWith(selectedChartTab: index);
  }

  Future<void> refreshProcesses() async {
    try {
      await _ensureClientConfigured();
      final cpuRes = await _api.getCurrentTopCpu();
      final memRes = await _api.getCurrentTopMem();
      state = state.copyWith(
        topCpuProcesses: cpuRes.data ?? state.topCpuProcesses,
        topMemProcesses: memRes.data ?? state.topMemProcesses,
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}

final dashboardStateProvider = StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  // Automatically trigger new instance when active server switches
  ref.watch(activeServerIdProvider);
  final api = ref.watch(dashboardApiProvider);
  return DashboardNotifier(api, ref);
});
