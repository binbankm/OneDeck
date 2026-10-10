import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/adaptive_scaffold.dart';
import '../../../../core/widgets/deck_card.dart';
import '../../../server/domain/models/server_model.dart';
import '../../../server/presentation/providers/server_provider.dart';
import '../../../server/presentation/widgets/add_server_dialog.dart';
import '../../../../core/widgets/deck_status_dot.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/metric_sparkline.dart';
import '../widgets/nebula_trend_chart.dart';
import '../widgets/top_processes_card.dart';
import '../widgets/multi_disk_card.dart';
import '../widgets/system_load_and_cores_card.dart';
import '../widgets/memory_swap_card.dart';
import '../widgets/disk_io_card.dart';
import '../widgets/gpu_card.dart';
import '../widgets/server_os_avatar.dart';

/// The central cockpit overview dashboard for OneDeck with complete internationalization.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeServer = ref.watch(activeServerProvider);

    if (activeServer == null) {
      return _buildNoServerView(context);
    }

    return _buildServerDashboard(context, ref, activeServer);
  }

  Widget _buildNoServerView(BuildContext context) {
    final l10n = context.l10n;

    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 360;
          return SingleChildScrollView(
            padding: EdgeInsets.all(isNarrow ? 12 : 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: DeckCard(
                padding: EdgeInsets.all(isNarrow ? 16 : 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: isNarrow ? 48 : 64,
                      height: isNarrow ? 48 : 64,
                      decoration: BoxDecoration(
                        color: DeckColors.accentIndigo.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(LucideIcons.server, size: isNarrow ? 24 : 32, color: DeckColors.accentIndigo),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      l10n.server_no_servers,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isNarrow ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: DeckColors.textPrimary(context),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.appSlogan,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: DeckColors.textMuted(context),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: ElevatedButton.icon(
                        onPressed: () => showAddOrEditServerDialog(context),
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text(l10n.server_add_first),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServerDashboard(BuildContext context, WidgetRef ref, ServerModel server) {
    final l10n = context.l10n;
    final dashState = ref.watch(dashboardStateProvider);
    final notifier = ref.read(dashboardStateProvider.notifier);
    final base = dashState.base;
    final current = dashState.current;

    // Derived metric strings from real 1Panel responses
    final cpuPercent = (current?.cpuUsedPercent ?? 0.0);
    final cpuStr = '${cpuPercent.toStringAsFixed(1)}%';
    final cpuCores = base != null && base.cpuCores > 0 ? '${base.cpuCores} ${l10n.dashboard_cpu_cores}' : '4 ${l10n.dashboard_cpu_cores}';
    final cpuLoad = current != null ? '${l10n.dashboard_cpu_load}: ${current.load1.toStringAsFixed(2)}' : '';
    final cpuSub = [cpuCores, cpuLoad].where((s) => s.isNotEmpty).join(' · ');

    final memUsed = current?.memoryUsed ?? 0;
    final memTotal = current?.memoryTotal ?? 0;
    final memPercent = (current?.memoryUsedPercent ?? 0.0);
    final memStr = '${memPercent.toStringAsFixed(1)}%';
    final memSub = '${Formatters.formatBytes(memUsed)} / ${Formatters.formatBytes(memTotal)}';

    final firstDisk = current?.diskData.firstOrNull;
    final diskUsed = firstDisk?.used ?? 0;
    final diskTotal = firstDisk?.total ?? 0;
    final diskPercent = (firstDisk?.usedPercent ?? 0.0);
    final diskStr = '${diskPercent.toStringAsFixed(1)}%';
    final diskSub = '${Formatters.formatBytes(diskUsed)} / ${Formatters.formatBytes(diskTotal)}';

    final downRate = dashState.netDownHistory.lastOrNull ?? 0.0;
    final upRate = dashState.netUpHistory.lastOrNull ?? 0.0;
    final netStr = '↓ ${Formatters.formatNetworkRate(downRate)}';
    final netTotal = Formatters.formatBytes(current?.netBytesRecv ?? 0);
    final netSub = '↑ ${Formatters.formatNetworkRate(upRate)} · $netTotal';

    final isDesktopPlatform = !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
    final listView = ListView(
      physics: isDesktopPlatform ? const ClampingScrollPhysics() : const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(18, isDesktopPlatform ? 20 : 16, 18, 20),
      children: [
          // 1. Cockpit Hero Banner (Responsive: Mobile-First 2x2 Specs Grid & Desktop Cockpit)
          DeckCard(
            padding: const EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 620;
                final isOnline = dashState.errorMessage == null && (server.isOnline ?? true);

                final osTile = _buildSpecTile(
                  context,
                  icon: LucideIcons.terminal,
                  label: l10n.dashboard_hero_os,
                  value: base?.prettyDistro.isNotEmpty == true ? base!.prettyDistro : 'Linux',
                  accentColor: DeckColors.accentIndigo,
                );

                final host = base?.ipV4Addr.isNotEmpty == true ? base!.ipV4Addr : server.host;
                final addrTile = _buildSpecTile(
                  context,
                  icon: LucideIcons.globe,
                  label: l10n.dashboard_hero_address,
                  value: host,
                  accentColor: DeckColors.accentCyan,
                  isMonospace: true,
                  trailing: Icon(LucideIcons.copy, size: 11, color: DeckColors.textMuted(context)),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: host));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${l10n.dashboard_ip_copied}: $host'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                );

                final uptimeTile = _buildSpecTile(
                  context,
                  icon: LucideIcons.clock,
                  label: l10n.metric_uptime,
                  value: Formatters.formatUptime(current?.runningTime, current?.uptime, Localizations.localeOf(context).languageCode),
                  accentColor: DeckColors.statusOnline,
                  isMonospace: true,
                );

                final rawCpu = base?.cpuModelName.isNotEmpty == true
                    ? base!.cpuModelName
                    : (base != null && base.cpuCores > 0 ? '${base.cpuCores} ${l10n.dashboard_cpu_cores}' : '4 Cores');
                final cleanCpu = _cleanCpuModel(rawCpu);
                final cpuTile = _buildSpecTile(
                  context,
                  icon: LucideIcons.cpu,
                  label: l10n.dashboard_hero_cpu,
                  value: cleanCpu,
                  accentColor: DeckColors.accentPurple,
                );

                Widget specsWidget;
                if (constraints.maxWidth < 280) {
                  specsWidget = Column(
                    children: [
                      osTile,
                      const SizedBox(height: 6),
                      addrTile,
                      const SizedBox(height: 6),
                      uptimeTile,
                      const SizedBox(height: 6),
                      cpuTile,
                    ],
                  );
                } else if (!isWide) {
                  specsWidget = Column(
                    children: [
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: osTile),
                            const SizedBox(width: 8),
                            Expanded(child: addrTile),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(child: uptimeTile),
                            const SizedBox(width: 8),
                            Expanded(child: cpuTile),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  specsWidget = IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: osTile),
                        const SizedBox(width: 8),
                        Expanded(child: addrTile),
                        const SizedBox(width: 8),
                        Expanded(child: uptimeTile),
                        const SizedBox(width: 8),
                        Expanded(child: cpuTile),
                      ],
                    ),
                  );
                }

                final refreshBtn = Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => notifier.loadAllData(),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: DeckColors.canvas(context),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: DeckColors.subtleBorder(context),
                          width: 0.8,
                        ),
                      ),
                      child: dashState.isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              Icons.refresh_rounded,
                              size: 18,
                              color: DeckColors.textSecondary(context),
                            ),
                    ),
                  ),
                );

                final statusBadge = Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: (isOnline ? DeckColors.statusOnline : DeckColors.statusError).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (isOnline ? DeckColors.statusOnline : DeckColors.statusError).withValues(alpha: 0.35),
                      width: 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isOnline ? DeckColors.statusOnline : DeckColors.statusError).withValues(alpha: 0.15),
                        blurRadius: 8,
                        spreadRadius: -1,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DeckStatusDot(isOnline: isOnline),
                      const SizedBox(width: 4.5),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            isOnline ? l10n.server_status_online : l10n.dashboard_auth_failed,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isOnline ? DeckColors.statusOnline : DeckColors.statusError,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );

                final iconSize = isWide ? 44.0 : 38.0;
                final headerWidget = Row(
                  children: [
                    ServerOsAvatar(
                      distro: base?.prettyDistro ?? base?.platformFamily ?? base?.os,
                      size: iconSize,
                      borderRadius: isWide ? 12 : 10,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            server.name,
                            style: TextStyle(
                              fontSize: isWide ? 17 : 15.5,
                              fontWeight: FontWeight.bold,
                              color: DeckColors.textPrimary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          statusBadge,
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    refreshBtn,
                  ],
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    headerWidget,
                    const SizedBox(height: 14),
                    specsWidget,
                  ],
                );
              },
            ),
          ),
          if (dashState.errorMessage != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: DeckColors.statusError.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: DeckColors.statusError.withValues(alpha: 0.4), width: 0.8),
              ),
              child: LayoutBuilder(
                builder: (context, c) {
                  final isCompact = c.maxWidth < 440;
                  final content = Row(
                    children: [
                      const Icon(Icons.lock_person_rounded, color: DeckColors.statusError, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${l10n.common_error}: ${dashState.errorMessage}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: DeckColors.statusError,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              l10n.dashboard_error_api_key_prompt,
                              style: const TextStyle(fontSize: 11, color: DeckColors.statusError),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );

                  final actionBtn = TextButton.icon(
                    style: TextButton.styleFrom(
                      foregroundColor: DeckColors.statusError,
                    ),
                    onPressed: () => showAddOrEditServerDialog(context, initialServer: server),
                    icon: const Icon(Icons.key_rounded, size: 16),
                    label: Text(l10n.dashboard_configure_api_key),
                  );

                  if (isCompact) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        content,
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: actionBtn,
                        ),
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: content),
                      actionBtn,
                    ],
                  );
                },
              ),
            ),
          ],
          const SizedBox(height: 16),

          // 2. The 4 KPI Cards
          Text(
            l10n.group_overview,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: DeckColors.textMuted(context),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final cardWidth = isWide
                  ? (constraints.maxWidth - 36) / 4
                  : (constraints.maxWidth - 12) / 2;
              final kpiRatio = isWide
                  ? 1.28
                  : (cardWidth < 165 ? 1.10 : (cardWidth < 185 ? 1.16 : 1.22));

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: kpiRatio,
                children: [
                  _buildKpiCard(
                    context,
                    icon: LucideIcons.cpu,
                    title: l10n.metric_cpu,
                    value: cpuStr,
                    subtitle: cpuSub,
                    accentColor: DeckColors.accentIndigo,
                    sparkline: MetricSparkline(
                      values: dashState.cpuHistory,
                      color: DeckColors.accentIndigo,
                    ),
                  ),
                  _buildKpiCard(
                    context,
                    icon: LucideIcons.memoryStick,
                    title: l10n.metric_memory,
                    value: memStr,
                    subtitle: memSub,
                    accentColor: DeckColors.accentCyan,
                    sparkline: MetricSparkline(
                      values: dashState.memoryHistory,
                      color: DeckColors.accentCyan,
                    ),
                  ),
                  _buildKpiCard(
                    context,
                    icon: LucideIcons.hardDrive,
                    title: l10n.metric_disk,
                    value: diskStr,
                    subtitle: diskSub,
                    accentColor: DeckColors.statusWarning,
                    sparkline: Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: (diskPercent / 100.0).clamp(0.0, 1.0),
                          minHeight: 5,
                          backgroundColor: DeckColors.subtleBorder(context),
                          valueColor: const AlwaysStoppedAnimation<Color>(DeckColors.statusWarning),
                        ),
                      ),
                    ),
                  ),
                  _buildKpiCard(
                    context,
                    icon: LucideIcons.activity,
                    title: l10n.metric_network,
                    value: netStr,
                    subtitle: netSub,
                    accentColor: DeckColors.statusOnline,
                    sparkline: MetricSparkline(
                      values: dashState.netDownHistory,
                      color: DeckColors.statusOnline,
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // 3. fl_chart Nebula Trend Cockpit
          const NebulaTrendChart(),
          const SizedBox(height: 16),

          // 3.1. System Load Average & Per-Core CPU Matrix
          SystemLoadAndCoresCard(current: current, base: base),
          const SizedBox(height: 16),

          // 3.2. Deep Memory Hierarchy & Swap
          MemorySwapCard(current: current),
          const SizedBox(height: 16),

          // 3.3. Multi-Disk Partitions & Inodes
          MultiDiskCard(disks: current?.diskData ?? []),
          const SizedBox(height: 16),

          // 3.4. Disk I/O Performance
          DiskIoCard(current: current),
          const SizedBox(height: 16),

          // 3.5. Top Processes Resource Consumption
          TopProcessesCard(
            topCpu: dashState.topCpuProcesses.isNotEmpty
                ? dashState.topCpuProcesses
                : (current?.topCPUItems ?? []),
            topMem: dashState.topMemProcesses.isNotEmpty
                ? dashState.topMemProcesses
                : (current?.topMemItems ?? []),
            onRefresh: () => notifier.refreshProcesses(),
          ),
          const SizedBox(height: 16),

          // 3.6. GPU Accelerators (Conditional)
          if (current?.gpuData.isNotEmpty == true) ...[
            GpuCard(gpus: current!.gpuData),
            const SizedBox(height: 16),
          ],

          // 4. Quick Module Jump Cards
          Text(
            l10n.group_apps,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: DeckColors.textMuted(context),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final cardWidth = isWide
                  ? (constraints.maxWidth - 36) / 4
                  : (constraints.maxWidth - 12) / 2;
              final shortcutRatio = isWide
                  ? 2.3
                  : (cardWidth < 175 ? 1.70 : 1.95);

              return GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isWide ? 4 : 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: shortcutRatio,
                children: [
                  _buildShortcutCard(
                    context,
                    ref,
                    icon: LucideIcons.globe,
                    title: l10n.nav_website,
                    countText: '${base?.websiteNumber ?? 0} ${l10n.dashboard_unit_websites}',
                    navId: 'website',
                  ),
                  _buildShortcutCard(
                    context,
                    ref,
                    icon: LucideIcons.box,
                    title: l10n.nav_container,
                    countText: '${base?.appInstalledNumber ?? 0} ${l10n.dashboard_unit_containers}',
                    navId: 'container',
                  ),
                  _buildShortcutCard(
                    context,
                    ref,
                    icon: LucideIcons.database,
                    title: l10n.nav_database,
                    countText: '${base?.databaseNumber ?? 0} ${l10n.dashboard_unit_databases}',
                    navId: 'database',
                  ),
                  _buildShortcutCard(
                    context,
                    ref,
                    icon: LucideIcons.clock,
                    title: l10n.nav_cronjob,
                    countText: '${base?.cronjobNumber ?? 0} ${l10n.dashboard_unit_cronjobs}',
                    navId: 'cronjob',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),

          // 5. System Architecture Card
          if (base != null) ...[
            Text(
              l10n.dashboard_sys_specs,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: DeckColors.textMuted(context),
                letterSpacing: 0.6,
              ),
            ),
            const SizedBox(height: 10),
            DeckCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 1. Hostname
                  _buildSpecRow(
                    context,
                    icon: LucideIcons.server,
                    label: l10n.dashboard_spec_hostname,
                    value: base.hostname.isNotEmpty ? base.hostname : 'unknown',
                    copyValue: base.hostname,
                  ),
                  _buildSpecDivider(context),

                  // 2. OS
                  _buildSpecRow(
                    context,
                    icon: LucideIcons.monitor,
                    label: l10n.dashboard_spec_os,
                    value: base.prettyDistro.isNotEmpty ? base.prettyDistro : base.os,
                  ),
                  _buildSpecDivider(context),

                  // 3. Kernel & Arch
                  _buildSpecRow(
                    context,
                    icon: LucideIcons.binary,
                    label: l10n.dashboard_spec_kernel,
                    value: base.kernelArch.isNotEmpty ? base.kernelArch : 'x86_64',
                    subtitle: base.kernelVersion.isNotEmpty ? base.kernelVersion : null,
                    copyValue: '${base.kernelArch} ${base.kernelVersion}'.trim(),
                  ),
                  _buildSpecDivider(context),

                  // 4. CPU & Cores Badge
                  Builder(
                    builder: (context) {
                      final cleanCpu = _cleanCpuModel(base.cpuModelName.isNotEmpty ? base.cpuModelName : l10n.metric_cpu);
                      final coresBadge = Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: DeckColors.accentIndigo.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: DeckColors.accentIndigo.withValues(alpha: 0.25),
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          '${base.cpuCores} / ${base.cpuLogicalCores} ${l10n.dashboard_spec_cores_detail}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: DeckColors.accentIndigo,
                          ),
                        ),
                      );

                      return _buildSpecRow(
                        context,
                        icon: LucideIcons.cpu,
                        label: l10n.dashboard_spec_cpu,
                        value: cleanCpu,
                        customBadge: coresBadge,
                        copyValue: cleanCpu,
                      );
                    },
                  ),
                  _buildSpecDivider(context),

                  // 5. System Proxy
                  Builder(
                    builder: (context) {
                      final rawProxy = base.systemProxy.trim();
                      final hasProxy = rawProxy.isNotEmpty &&
                          rawProxy.toLowerCase() != 'noproxy' &&
                          rawProxy.toLowerCase() != 'none' &&
                          rawProxy.toLowerCase() != 'null';

                      if (!hasProxy) {
                        return _buildSpecRow(
                          context,
                          icon: LucideIcons.globe,
                          label: l10n.dashboard_spec_proxy,
                          value: '',
                          customBadge: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: DeckColors.canvas(context),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: DeckColors.subtleBorder(context), width: 0.6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: DeckColors.statusOnline,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  l10n.dashboard_spec_proxy_none,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: DeckColors.textMuted(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return _buildSpecRow(
                        context,
                        icon: LucideIcons.globe,
                        label: l10n.dashboard_spec_proxy,
                        value: rawProxy,
                        copyValue: rawProxy,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      );

    if (isDesktopPlatform) {
      return listView;
    }

    return RefreshIndicator(
      onRefresh: () => notifier.loadAllData(),
      child: listView,
    );
  }

  Widget _buildSpecRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    String? subtitle,
    Widget? customBadge,
    String? copyValue,
  }) {
    final copyTarget = copyValue ?? value;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: subtitle != null || customBadge != null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          // Left: Icon + Label
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: DeckColors.canvas(context),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: DeckColors.subtleBorder(context).withValues(alpha: 0.6),
                width: 0.6,
              ),
            ),
            child: Icon(icon, size: 14, color: DeckColors.textSecondary(context)),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: DeckColors.textSecondary(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          // Right: Value + optional Subtitle / Badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (value.isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          value,
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: DeckColors.textPrimary(context),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      if (copyValue != null && copyTarget.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        InkWell(
                          borderRadius: BorderRadius.circular(4),
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: copyTarget));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('已复制: $copyTarget'),
                                duration: const Duration(seconds: 1),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Icon(
                              LucideIcons.copy,
                              size: 12,
                              color: DeckColors.textMuted(context),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                if (customBadge != null) ...[
                  if (value.isNotEmpty) const SizedBox(height: 4),
                  customBadge,
                ] else if (subtitle != null && subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: DeckColors.textMuted(context),
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecDivider(BuildContext context) {
    return Container(
      height: 1.0,
      margin: const EdgeInsets.symmetric(vertical: 6),
      color: DeckColors.subtleBorder(context).withValues(alpha: 0.4),
    );
  }

  static String _cleanCpuModel(String raw) {
    if (raw.isEmpty) return raw;
    var clean = raw.replaceAll(RegExp(r'[\(\[](?:R|TM|r|tm)[\)\]]'), '');
    clean = clean.replaceAll(RegExp(r'\s+Processor\b', caseSensitive: false), '');
    clean = clean.replaceAll(RegExp(r'\s+CPU\s*@.*$', caseSensitive: false), '');
    clean = clean.replaceAll(RegExp(r'\s*@\s*[\d\.]+\s*[GgMm][Hh][Zz].*$'), '');
    clean = clean.replaceAll(RegExp(r'\s+'), ' ').trim();
    return clean.isEmpty ? raw : clean;
  }

  Widget _buildSpecTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? accentColor,
    VoidCallback? onTap,
    Widget? trailing,
    bool isMonospace = false,
    int maxLines = 2,
  }) {
    final effectiveAccent = accentColor ?? DeckColors.textSecondary(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tile = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Colors.white.withValues(alpha: 0.05),
                  Colors.white.withValues(alpha: 0.02),
                ]
              : [
                  Colors.black.withValues(alpha: 0.04),
                  Colors.black.withValues(alpha: 0.01),
                ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.10)
              : Colors.black.withValues(alpha: 0.06),
          width: 0.7,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(3.5),
                decoration: BoxDecoration(
                  color: effectiveAccent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  icon,
                  size: 12,
                  color: effectiveAccent,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: DeckColors.textMuted(context),
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 5),
          Text(
            value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: isMonospace ? 'monospace' : null,
              color: DeckColors.textPrimary(context),
              height: 1.25,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: tile,
        ),
      );
    }
    return tile;
  }

  Widget _buildKpiCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color accentColor,
    required Widget sparkline,
  }) {
    return DeckCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: DeckColors.textSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 14, color: accentColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: DeckColors.textPrimary(context),
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, color: DeckColors.textMuted(context)),
          ),
          const Spacer(),
          SizedBox(
            height: 26,
            child: sparkline,
          ),
        ],
      ),
    );
  }

  Widget _buildShortcutCard(
    BuildContext context,
    WidgetRef ref, {
    required IconData icon,
    required String title,
    required String countText,
    required String navId,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        ref.read(activeNavIdProvider.notifier).state = navId;
      },
      child: DeckCard(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: DeckColors.accentIndigo.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 17, color: DeckColors.accentIndigo),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: DeckColors.textPrimary(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    countText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      color: DeckColors.textMuted(context),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.chevron_right_rounded, size: 15, color: DeckColors.textMuted(context)),
          ],
        ),
      ),
    );
  }
}
