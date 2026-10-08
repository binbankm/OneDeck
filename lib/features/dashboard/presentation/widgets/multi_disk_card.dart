import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/deck_card.dart';
import '../../data/models/dashboard_models.dart';

/// Multi-mount disk partitions and Inodes monitor card.
class MultiDiskCard extends StatelessWidget {
  final List<DiskInfo> disks;

  const MultiDiskCard({
    super.key,
    required this.disks,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
                      child: const Icon(LucideIcons.hardDrive, size: 16, color: DeckColors.accentCyan),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.dashboard_multi_disk,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: DeckColors.canvas(context),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
                ),
                child: Text(
                  l10n.dashboard_disks_count(disks.length.toString()),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: DeckColors.textSecondary(context),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Disks list
          if (disks.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(l10n.dashboard_disks_empty, style: TextStyle(fontSize: 12, color: DeckColors.textMuted(context))),
              ),
            )
          else
            ...disks.map((d) {
              final usedPercent = d.usedPercent.clamp(0.0, 100.0);
              final ratio = (usedPercent / 100.0).clamp(0.0, 1.0);

              Color barColor = DeckColors.statusOnline;
              if (usedPercent >= 90) {
                barColor = DeckColors.statusError;
              } else if (usedPercent >= 75) {
                barColor = DeckColors.statusWarning;
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Line 1: Mount Path + Filesystem Badge on Left, Usage Percent on Right
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  d.path,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: DeckColors.textPrimary(context),
                                    fontFamily: 'monospace',
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (d.type.isNotEmpty) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: DeckColors.canvas(context),
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: DeckColors.subtleBorder(context), width: 0.6),
                                  ),
                                  child: Text(
                                    d.type,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: DeckColors.textSecondary(context),
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${usedPercent.toStringAsFixed(1)}%',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: barColor,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Line 2: Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: ratio,
                        minHeight: 6,
                        backgroundColor: DeckColors.subtleBorder(context).withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(barColor),
                      ),
                    ),
                    const SizedBox(height: 5),
                    // Line 3: Device Path on Left (ellipsized), Used / Total on Right
                    Row(
                      children: [
                        if (d.device.isNotEmpty)
                          Expanded(
                            child: Text(
                              d.device,
                              style: TextStyle(
                                fontSize: 10.5,
                                color: DeckColors.textMuted(context),
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          )
                        else
                          const Spacer(),
                        const SizedBox(width: 8),
                        Text(
                          '${Formatters.formatBytes(d.used)} / ${Formatters.formatBytes(d.total)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: DeckColors.textSecondary(context),
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    // Line 4: Free Space on Left, Inodes on Right
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${l10n.dashboard_disk_free}: ${Formatters.formatBytes(d.free)}',
                          style: TextStyle(fontSize: 10, color: DeckColors.textMuted(context)),
                        ),
                        Text(
                          '${l10n.dashboard_inodes}: ${d.inodesUsedPercent.toStringAsFixed(1)}%',
                          style: TextStyle(fontSize: 10, color: DeckColors.textMuted(context), fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
