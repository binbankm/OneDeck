import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/deck_card.dart';
import '../../data/models/dashboard_models.dart';

/// Detailed Memory breakdown (Used / Cached / Free) & Swap partition card.
class MemorySwapCard extends StatelessWidget {
  final DashboardCurrent? current;

  const MemorySwapCard({
    super.key,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final memTotal = current?.memoryTotal ?? 0;
    final memUsed = current?.memoryUsed ?? 0;
    final memCache = current?.memoryCache ?? 0;
    final memFree = current?.memoryFree ?? 0;

    final usedPercent = memTotal > 0 ? (memUsed / memTotal).clamp(0.0, 1.0) : 0.0;
    final cachePercent = memTotal > 0 ? (memCache / memTotal).clamp(0.0, 1.0) : 0.0;
    final freePercent = (1.0 - usedPercent - cachePercent).clamp(0.0, 1.0);

    final swapTotal = current?.swapMemoryTotal ?? 0;
    final swapUsed = current?.swapMemoryUsed ?? 0;
    final swapPercent = current?.swapMemoryUsedPercent ?? 0.0;
    final hasSwap = swapTotal > 0;
    // Swap warning only triggers under real memory pressure (>= 5% and > 50MB)
    final isSwapActive = hasSwap && (swapPercent >= 5.0 || swapUsed > 50 * 1024 * 1024);

    return DeckCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: resilient to any title length and language
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: DeckColors.accentCyan.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(LucideIcons.layers, size: 16, color: DeckColors.accentCyan),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.dashboard_memory_deep,
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
              Text(
                '${l10n.dashboard_mem_total}: ${Formatters.formatBytes(memTotal)}',
                style: TextStyle(
                  fontSize: 11,
                  color: DeckColors.textSecondary(context),
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 1. Multi-Segmented Memory Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  if (usedPercent > 0)
                    Expanded(
                      flex: (usedPercent * 1000).toInt(),
                      child: Container(color: DeckColors.accentCyan),
                    ),
                  if (cachePercent > 0)
                    Expanded(
                      flex: (cachePercent * 1000).toInt(),
                      child: Container(color: DeckColors.accentPurple),
                    ),
                  if (freePercent > 0)
                    Expanded(
                      flex: (freePercent * 1000).toInt(),
                      child: Container(color: DeckColors.subtleBorder(context)),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Legends
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: [
              _buildLegend(
                context,
                color: DeckColors.accentCyan,
                label: l10n.dashboard_mem_used,
                value: '${Formatters.formatBytes(memUsed)} (${(usedPercent * 100).toStringAsFixed(1)}%)',
              ),
              _buildLegend(
                context,
                color: DeckColors.accentPurple,
                label: l10n.dashboard_mem_cache,
                value: '${Formatters.formatBytes(memCache)} (${(cachePercent * 100).toStringAsFixed(1)}%)',
              ),
              _buildLegend(
                context,
                color: DeckColors.textMuted(context),
                label: l10n.dashboard_mem_free,
                value: '${Formatters.formatBytes(memFree)} (${(freePercent * 100).toStringAsFixed(1)}%)',
              ),
            ],
          ),
          const Divider(height: 24),

          // 2. Responsive Swap Partition
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrowSwap = constraints.maxWidth < 360;

              if (isNarrowSwap) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(LucideIcons.hardDriveDownload, size: 15, color: DeckColors.accentIndigo),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  l10n.dashboard_swap,
                                  style: TextStyle(
                                    fontSize: 12.5,
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
                        if (!hasSwap)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: DeckColors.canvas(context),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
                            ),
                            child: Text(
                              '未启用',
                              style: TextStyle(fontSize: 10.5, color: DeckColors.textMuted(context)),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: isSwapActive
                                  ? DeckColors.statusWarning.withValues(alpha: 0.12)
                                  : DeckColors.statusOnline.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: isSwapActive
                                    ? DeckColors.statusWarning.withValues(alpha: 0.35)
                                    : DeckColors.statusOnline.withValues(alpha: 0.35),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              isSwapActive ? l10n.dashboard_swap_warning : l10n.dashboard_swap_safe,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: isSwapActive ? DeckColors.statusWarning : DeckColors.statusOnline,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (hasSwap) ...[
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              l10n.dashboard_mem_used_total,
                              style: TextStyle(fontSize: 10.5, color: DeckColors.textMuted(context)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${Formatters.formatBytes(swapUsed)} / ${Formatters.formatBytes(swapTotal)} (${swapPercent.toStringAsFixed(1)}%)',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: DeckColors.textSecondary(context),
                              fontFamily: 'monospace',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(LucideIcons.hardDriveDownload, size: 15, color: DeckColors.accentIndigo),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            l10n.dashboard_swap,
                            style: TextStyle(
                              fontSize: 12.5,
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
                  if (!hasSwap)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: DeckColors.canvas(context),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
                      ),
                      child: Text(
                        l10n.dashboard_swap_disabled,
                        style: TextStyle(fontSize: 10.5, color: DeckColors.textMuted(context)),
                      ),
                    )
                  else ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSwapActive
                            ? DeckColors.statusWarning.withValues(alpha: 0.12)
                            : DeckColors.statusOnline.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSwapActive
                              ? DeckColors.statusWarning.withValues(alpha: 0.35)
                              : DeckColors.statusOnline.withValues(alpha: 0.35),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        isSwapActive ? l10n.dashboard_swap_warning : l10n.dashboard_swap_safe,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                          color: isSwapActive ? DeckColors.statusWarning : DeckColors.statusOnline,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${Formatters.formatBytes(swapUsed)} / ${Formatters.formatBytes(swapTotal)} (${swapPercent.toStringAsFixed(1)}%)',
                      style: TextStyle(
                        fontSize: 11,
                        color: DeckColors.textSecondary(context),
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ],
              );
            },
          ),
          if (hasSwap) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: (swapPercent / 100.0).clamp(0.0, 1.0),
                minHeight: 4,
                backgroundColor: DeckColors.subtleBorder(context),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isSwapActive ? DeckColors.statusWarning : DeckColors.statusOnline,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend(
    BuildContext context, {
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text.rich(
            TextSpan(
              text: '$label: ',
              style: TextStyle(fontSize: 10.5, color: DeckColors.textMuted(context)),
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: DeckColors.textPrimary(context),
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
