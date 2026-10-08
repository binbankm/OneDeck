import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
import '../../../../core/widgets/deck_card.dart';
import '../../data/models/dashboard_models.dart';

/// System load average (1m, 5m, 15m) and per-core CPU matrix card.
class SystemLoadAndCoresCard extends StatelessWidget {
  final DashboardCurrent? current;
  final DashboardBase? base;

  const SystemLoadAndCoresCard({
    super.key,
    required this.current,
    required this.base,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cores = base != null && base!.cpuCores > 0 ? base!.cpuCores : 4;

    final load1 = current?.load1 ?? 0.0;
    final load5 = current?.load5 ?? 0.0;
    final load15 = current?.load15 ?? 0.0;

    final isOverloaded = load1 > (cores * 1.5);
    final isWarning = load1 > cores && !isOverloaded;

    final perCore = current?.cpuPercent ?? [];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 620;

        final loadWidget = DeckCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: DeckColors.accentPurple.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(LucideIcons.activity, size: 16, color: DeckColors.accentPurple),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.dashboard_load_detail,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: DeckColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isOverloaded
                          ? DeckColors.statusError.withValues(alpha: 0.12)
                          : (isWarning ? DeckColors.statusWarning.withValues(alpha: 0.12) : DeckColors.statusOnline.withValues(alpha: 0.12)),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isOverloaded
                            ? DeckColors.statusError.withValues(alpha: 0.4)
                            : (isWarning ? DeckColors.statusWarning.withValues(alpha: 0.4) : DeckColors.statusOnline.withValues(alpha: 0.4)),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      isOverloaded
                          ? l10n.dashboard_load_critical
                          : (isWarning ? l10n.dashboard_load_warning : l10n.dashboard_load_healthy),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isOverloaded
                            ? DeckColors.statusError
                            : (isWarning ? DeckColors.statusWarning : DeckColors.statusOnline),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 3 Loads Row
              Row(
                children: [
                  Expanded(child: _buildLoadMeter(context, l10n.dashboard_load_1m, load1, cores)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildLoadMeter(context, l10n.dashboard_load_5m, load5, cores)),
                  const SizedBox(width: 10),
                  Expanded(child: _buildLoadMeter(context, l10n.dashboard_load_15m, load15, cores)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                l10n.dashboard_cores_baseline(cores.toString()),
                style: TextStyle(fontSize: 11, color: DeckColors.textMuted(context)),
              ),
            ],
          ),
        );

        final coresWidget = DeckCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: DeckColors.accentIndigo.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(LucideIcons.cpu, size: 16, color: DeckColors.accentIndigo),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.dashboard_cpu_cores_matrix,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: DeckColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    l10n.dashboard_cores_count(perCore.length.toString()),
                    style: TextStyle(fontSize: 11, color: DeckColors.textMuted(context), fontFamily: 'monospace'),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              if (perCore.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Center(
                    child: Text(l10n.dashboard_cores_empty, style: TextStyle(fontSize: 12, color: DeckColors.textMuted(context))),
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, c) {
                    final cols = c.maxWidth < 360 ? 3 : (c.maxWidth < 600 ? 4 : 6);
                    final itemWidth = ((c.maxWidth - (cols - 1) * 8) / cols).floorToDouble();
                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: perCore.asMap().entries.take(16).map((entry) {
                        final idx = entry.key;
                        final val = entry.value.clamp(0.0, 100.0);
                        final ratio = val / 100.0;

                        Color coreColor = DeckColors.accentIndigo;
                        if (val > 85) {
                          coreColor = DeckColors.statusError;
                        } else if (val > 50) {
                          coreColor = DeckColors.statusWarning;
                        }

                        return Container(
                          width: itemWidth,
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          decoration: BoxDecoration(
                            color: DeckColors.canvas(context),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '#$idx',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: DeckColors.textMuted(context),
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                  Text(
                                    '${val.toStringAsFixed(0)}%',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: coreColor,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(2),
                                child: LinearProgressIndicator(
                                  value: ratio,
                                  minHeight: 3,
                                  backgroundColor: DeckColors.subtleBorder(context),
                                  valueColor: AlwaysStoppedAnimation<Color>(coreColor),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
            ],
          ),
        );

        if (isNarrow) {
          return Column(
            children: [
              loadWidget,
              const SizedBox(height: 12),
              coresWidget,
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 5, child: loadWidget),
            const SizedBox(width: 12),
            Expanded(flex: 6, child: coresWidget),
          ],
        );
      },
    );
  }

  Widget _buildLoadMeter(BuildContext context, String title, double val, int cores) {
    final ratio = (val / cores).clamp(0.0, 1.0);
    Color color = DeckColors.statusOnline;
    if (val > cores * 1.5) {
      color = DeckColors.statusError;
    } else if (val > cores) {
      color = DeckColors.statusWarning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: DeckColors.canvas(context),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, color: DeckColors.textMuted(context))),
          const SizedBox(height: 4),
          Text(
            val.toStringAsFixed(2),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: ratio,
              minHeight: 3.5,
              backgroundColor: DeckColors.subtleBorder(context),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
