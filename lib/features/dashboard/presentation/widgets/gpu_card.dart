import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
import '../../../../core/widgets/deck_card.dart';
import '../../data/models/dashboard_models.dart';

/// GPU / AI Accelerator monitor card.
class GpuCard extends StatelessWidget {
  final List<GPUInfo> gpus;

  const GpuCard({
    super.key,
    required this.gpus,
  });

  @override
  Widget build(BuildContext context) {
    if (gpus.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;

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
                  color: DeckColors.statusOnline.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.zap, size: 16, color: DeckColors.statusOnline),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.dashboard_gpu_title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: DeckColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...gpus.map((gpu) {
            final tempNum = int.tryParse(gpu.temperature) ?? 0;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
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
                        gpu.productName.isNotEmpty ? gpu.productName : 'NVIDIA Accelerator',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: DeckColors.textPrimary(context),
                        ),
                      ),
                      Text(
                        '${l10n.dashboard_gpu_temp}: ${gpu.temperature.isNotEmpty ? "${gpu.temperature}°C" : "--"}',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: tempNum > 80 ? DeckColors.statusError : DeckColors.statusOnline,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${l10n.dashboard_gpu_mem}: ${gpu.memUsed} / ${gpu.memTotal}',
                          style: TextStyle(fontSize: 11, color: DeckColors.textSecondary(context), fontFamily: 'monospace'),
                        ),
                      ),
                      if (gpu.powerUsage.isNotEmpty)
                        Text(
                          '${l10n.dashboard_gpu_power}: ${gpu.powerUsage} / ${gpu.maxPowerLimit}',
                          style: TextStyle(fontSize: 11, color: DeckColors.textMuted(context), fontFamily: 'monospace'),
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
