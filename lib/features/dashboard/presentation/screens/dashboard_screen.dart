import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
import '../../../../core/widgets/adaptive_scaffold.dart';
import '../../../../core/widgets/deck_card.dart';
import '../../../../core/widgets/deck_status_dot.dart';
import '../../../server/domain/models/server_model.dart';
import '../../../server/presentation/providers/server_provider.dart';
import '../../../server/presentation/widgets/add_server_dialog.dart';

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
                      '连接到您的 1Panel V2 服务器以实时监控和管理容器、网站与数据库。',
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

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        // Server Overview Banner
        DeckCard(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [DeckColors.accentIndigo, DeckColors.accentCyan],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.server, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          server.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: DeckColors.textPrimary(context),
                          ),
                        ),
                        const SizedBox(width: 10),
                        DeckStatusDot(isOnline: server.isOnline ?? true),
                        const SizedBox(width: 6),
                        Text(
                          (server.isOnline ?? true) ? l10n.server_status_online : l10n.server_status_offline,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: (server.isOnline ?? true) ? DeckColors.statusOnline : DeckColors.statusError,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      server.displayUrl,
                      style: TextStyle(
                        fontSize: 12,
                        color: DeckColors.textMuted(context),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Section Title: System Metrics
        Text(
          l10n.group_overview.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: DeckColors.textMuted(context),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 12),

        // 4 KPI Cards Grid
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 680;
            return GridView.count(
              crossAxisCount: isWide ? 4 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildKpiCard(context, icon: LucideIcons.cpu, title: l10n.metric_cpu, value: '18%', subtitle: '4 Cores (Load: 0.42)'),
                _buildKpiCard(context, icon: LucideIcons.memoryStick, title: l10n.metric_memory, value: '2.4 GB', subtitle: 'Total: 8.0 GB (30%)'),
                _buildKpiCard(context, icon: LucideIcons.hardDrive, title: l10n.metric_disk, value: '42 GB', subtitle: 'Total: 120 GB (35%)'),
                _buildKpiCard(context, icon: LucideIcons.activity, title: l10n.metric_network, value: '1.2 MB/s', subtitle: '↑ 320 KB/s  ↓ 900 KB/s'),
              ],
            );
          },
        ),
        const SizedBox(height: 24),

        // Quick Operations Shortcuts
        Text(
          l10n.group_apps.toUpperCase(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: DeckColors.textMuted(context),
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildShortcutCard(
                context,
                ref,
                icon: LucideIcons.box,
                title: l10n.nav_container,
                subtitle: 'Docker 容器与镜像管理',
                navId: 'container',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildShortcutCard(
                context,
                ref,
                icon: LucideIcons.globe,
                title: l10n.nav_website,
                subtitle: '网站与反向代理域名',
                navId: 'website',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return DeckCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 12, color: DeckColors.textSecondary(context), fontWeight: FontWeight.w600)),
              Icon(icon, size: 16, color: DeckColors.accentIndigo),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: DeckColors.textPrimary(context),
              fontFamily: 'monospace',
            ),
          ),
          Text(subtitle, style: TextStyle(fontSize: 10, color: DeckColors.textMuted(context))),
        ],
      ),
    );
  }

  Widget _buildShortcutCard(BuildContext context, WidgetRef ref, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String navId,
  }) {
    return DeckCard(
      onTap: () => ref.read(activeNavIdProvider.notifier).state = navId,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: DeckColors.accentIndigo.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: DeckColors.accentIndigo),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: DeckColors.textPrimary(context))),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 11, color: DeckColors.textMuted(context))),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: DeckColors.textMuted(context), size: 18),
        ],
      ),
    );
  }
}
