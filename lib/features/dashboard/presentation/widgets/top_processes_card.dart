import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/deck_card.dart';
import '../../data/models/dashboard_models.dart';

/// Top processes resource consumption card (CPU vs Memory tabs).
class TopProcessesCard extends StatefulWidget {
  final List<Process> topCpu;
  final List<Process> topMem;
  final VoidCallback? onRefresh;

  const TopProcessesCard({
    super.key,
    required this.topCpu,
    required this.topMem,
    this.onRefresh,
  });

  @override
  State<TopProcessesCard> createState() => _TopProcessesCardState();
}

class _TopProcessesCardState extends State<TopProcessesCard> {
  bool _sortByCpu = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = _sortByCpu ? widget.topCpu : widget.topMem;
    final displayItems = items.take(5).toList();

    return DeckCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Responsive Card Header with Tab Switcher & Refresh
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrowHeader = constraints.maxWidth < 420;

              if (isNarrowHeader) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: DeckColors.accentIndigo.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(LucideIcons.activity, size: 16, color: DeckColors.accentIndigo),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  l10n.dashboard_top_processes,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: DeckColors.textPrimary(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (widget.onRefresh != null)
                          IconButton(
                            icon: const Icon(LucideIcons.refreshCw, size: 13),
                            visualDensity: VisualDensity.compact,
                            tooltip: l10n.dashboard_refresh_processes,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                            onPressed: widget.onRefresh,
                          ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: DeckColors.canvas(context),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildToggleBtn(
                              title: l10n.dashboard_top_cpu,
                              isSelected: _sortByCpu,
                              onTap: () => setState(() => _sortByCpu = true),
                            ),
                          ),
                          Expanded(
                            child: _buildToggleBtn(
                              title: l10n.dashboard_top_mem,
                              isSelected: !_sortByCpu,
                              onTap: () => setState(() => _sortByCpu = false),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: DeckColors.accentIndigo.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(LucideIcons.activity, size: 16, color: DeckColors.accentIndigo),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            l10n.dashboard_top_processes,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: DeckColors.textPrimary(context),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: DeckColors.canvas(context),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
                        ),
                        child: Row(
                          children: [
                            _buildToggleBtn(
                              title: l10n.dashboard_top_cpu,
                              isSelected: _sortByCpu,
                              onTap: () => setState(() => _sortByCpu = true),
                            ),
                            _buildToggleBtn(
                              title: l10n.dashboard_top_mem,
                              isSelected: !_sortByCpu,
                              onTap: () => setState(() => _sortByCpu = false),
                            ),
                          ],
                        ),
                      ),
                      if (widget.onRefresh != null) ...[
                        const SizedBox(width: 6),
                        IconButton(
                          icon: const Icon(LucideIcons.refreshCw, size: 13),
                          visualDensity: VisualDensity.compact,
                          tooltip: l10n.dashboard_refresh_processes,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                          onPressed: widget.onRefresh,
                        ),
                      ],
                    ],
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),

          // Processes List / Table
          if (displayItems.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Column(
                  children: [
                    Icon(LucideIcons.cpu, size: 22, color: DeckColors.textMuted(context).withValues(alpha: 0.5)),
                    const SizedBox(height: 6),
                    Text(
                      l10n.dashboard_processes_empty,
                      style: TextStyle(fontSize: 12, color: DeckColors.textMuted(context)),
                    ),
                  ],
                ),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 480;

                if (isNarrow) {
                  // Mobile vertical list
                  return Column(
                    children: displayItems.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final p = entry.value;
                      final rank = idx + 1;
                      final isTop = rank == 1;

                      final valueStr = _sortByCpu
                          ? '${p.percent.toStringAsFixed(1)}%'
                          : Formatters.formatBytes(p.memory);

                      final percentRatio = _sortByCpu
                          ? (p.percent / 100).clamp(0.0, 1.0)
                          : ((p.memory / (1024 * 1024 * 1024 * 4)).clamp(0.0, 1.0));

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: DeckColors.canvas(context),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: DeckColors.subtleBorder(context), width: 0.6),
                        ),
                        child: Row(
                          children: [
                            // Rank
                            SizedBox(
                              width: 22,
                              child: Text(
                                '#$rank',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isTop ? DeckColors.accentIndigo : DeckColors.textMuted(context),
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Process Name & PID/User
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Tooltip(
                                    message: p.cmd.isNotEmpty ? p.cmd : p.name,
                                    child: Text(
                                      p.name.isNotEmpty ? p.name : 'unknown',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: DeckColors.textPrimary(context),
                                        fontFamily: 'monospace',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'PID: ${p.pid} · ${p.user.isNotEmpty ? p.user : 'system'}',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: DeckColors.textMuted(context),
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Value & Mini Progress Bar
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  valueStr,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.bold,
                                    color: isTop ? DeckColors.accentCyan : DeckColors.textPrimary(context),
                                    fontFamily: 'monospace',
                                  ),
                                ),
                                const SizedBox(height: 3),
                                SizedBox(
                                  width: 60,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: LinearProgressIndicator(
                                      value: percentRatio,
                                      minHeight: 3,
                                      backgroundColor: DeckColors.subtleBorder(context),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        isTop ? DeckColors.accentCyan : DeckColors.accentIndigo.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }

                // Wide view - multi-column table
                return Column(
                  children: [
                    // Table Header
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        children: [
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 4,
                            child: Text(
                              l10n.dashboard_process_name,
                              style: TextStyle(fontSize: 11, color: DeckColors.textMuted(context), fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              l10n.dashboard_process_pid,
                              style: TextStyle(fontSize: 11, color: DeckColors.textMuted(context), fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              l10n.dashboard_process_user,
                              style: TextStyle(fontSize: 11, color: DeckColors.textMuted(context), fontWeight: FontWeight.w600),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              _sortByCpu ? l10n.dashboard_top_cpu : l10n.dashboard_top_mem,
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 11, color: DeckColors.textMuted(context), fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 8),

                    // Process Rows
                    ...displayItems.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final p = entry.value;
                      final rank = idx + 1;
                      final isTop = rank == 1;

                      final valueStr = _sortByCpu
                          ? '${p.percent.toStringAsFixed(1)}%'
                          : Formatters.formatBytes(p.memory);

                      final percentRatio = _sortByCpu
                          ? (p.percent / 100).clamp(0.0, 1.0)
                          : ((p.memory / (1024 * 1024 * 1024 * 4)).clamp(0.0, 1.0));

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24,
                              child: Text(
                                '#$rank',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: isTop ? DeckColors.accentIndigo : DeckColors.textMuted(context),
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Tooltip(
                                message: p.cmd.isNotEmpty ? p.cmd : p.name,
                                child: Text(
                                  p.name.isNotEmpty ? p.name : 'unknown',
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: DeckColors.textPrimary(context),
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                '${p.pid}',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  color: DeckColors.textSecondary(context),
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                p.user.isNotEmpty ? p.user : 'system',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: DeckColors.textMuted(context),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    valueStr,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.bold,
                                      color: isTop ? DeckColors.accentCyan : DeckColors.textPrimary(context),
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(2),
                                    child: LinearProgressIndicator(
                                      value: percentRatio,
                                      minHeight: 3,
                                      backgroundColor: DeckColors.subtleBorder(context),
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        isTop ? DeckColors.accentCyan : DeckColors.accentIndigo.withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildToggleBtn({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? DeckColors.card(context) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? DeckColors.textPrimary(context) : DeckColors.textMuted(context),
          ),
        ),
      ),
    );
  }
}
