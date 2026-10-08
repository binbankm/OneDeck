import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/deck_card.dart';
import '../../data/models/dashboard_models.dart';

/// Real-time disk I/O metrics card.
class DiskIoCard extends StatelessWidget {
  final DashboardCurrent? current;

  const DiskIoCard({
    super.key,
    required this.current,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final readBytes = current?.ioReadBytes ?? 0;
    final writeBytes = current?.ioWriteBytes ?? 0;
    final ioCount = current?.ioCount ?? 0;

    return DeckCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: DeckColors.accentIndigo.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.arrowDownUp, size: 16, color: DeckColors.accentIndigo),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.dashboard_disk_io,
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
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 460;

              if (isNarrow) {
                return Column(
                  children: [
                    _buildNarrowMetric(
                      context,
                      icon: LucideIcons.download,
                      title: l10n.dashboard_io_read,
                      value: Formatters.formatBytes(readBytes),
                      color: DeckColors.accentCyan,
                    ),
                    const SizedBox(height: 8),
                    _buildNarrowMetric(
                      context,
                      icon: LucideIcons.upload,
                      title: l10n.dashboard_io_write,
                      value: Formatters.formatBytes(writeBytes),
                      color: DeckColors.accentIndigo,
                    ),
                    const SizedBox(height: 8),
                    _buildNarrowMetric(
                      context,
                      icon: LucideIcons.activity,
                      title: l10n.dashboard_io_count,
                      value: '$ioCount ${l10n.dashboard_io_ops_unit}',
                      color: DeckColors.accentPurple,
                    ),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: _buildWideMetric(
                      context,
                      icon: LucideIcons.download,
                      title: l10n.dashboard_io_read,
                      value: Formatters.formatBytes(readBytes),
                      color: DeckColors.accentCyan,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildWideMetric(
                      context,
                      icon: LucideIcons.upload,
                      title: l10n.dashboard_io_write,
                      value: Formatters.formatBytes(writeBytes),
                      color: DeckColors.accentIndigo,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildWideMetric(
                      context,
                      icon: LucideIcons.activity,
                      title: l10n.dashboard_io_count,
                      value: '$ioCount ${l10n.dashboard_io_ops_unit}',
                      color: DeckColors.accentPurple,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowMetric(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: DeckColors.canvas(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                color: DeckColors.textSecondary(context),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: DeckColors.textPrimary(context),
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideMetric(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: DeckColors.canvas(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10.5, color: DeckColors.textMuted(context)),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: DeckColors.textPrimary(context),
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
