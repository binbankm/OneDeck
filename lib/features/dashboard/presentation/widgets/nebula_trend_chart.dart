import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/localization/l10n_x.dart';
import '../../../../core/theme/deck_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/deck_card.dart';
import '../providers/dashboard_provider.dart';

/// Full interactive Nebula Trend Chart cockpit supporting CPU, RAM, Network & Load metrics.
class NebulaTrendChart extends ConsumerWidget {
  const NebulaTrendChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(dashboardStateProvider);
    final notifier = ref.read(dashboardStateProvider.notifier);

    final isZh = Localizations.localeOf(context).languageCode == 'zh';
    final tabs = [
      {'label': l10n.dashboard_tab_cpu, 'short': 'CPU', 'icon': Icons.memory_rounded},
      {'label': l10n.dashboard_tab_memory, 'short': isZh ? '内存' : 'RAM', 'icon': Icons.storage_rounded},
      {'label': l10n.dashboard_tab_network, 'short': isZh ? '网络' : 'Net', 'icon': Icons.swap_vert_rounded},
      {'label': l10n.dashboard_tab_load, 'short': isZh ? '负载' : 'Load', 'icon': Icons.speed_rounded},
    ];

    return DeckCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Pulse Dot
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: DeckColors.statusOnline,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.dashboard_trend_title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: DeckColors.textPrimary(context),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Tab Selector (Responsive: Segmented bar on mobile, Wrap on desktop)
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 480;
              if (isNarrow) {
                return Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: DeckColors.canvas(context),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: DeckColors.subtleBorder(context), width: 0.8),
                  ),
                  child: Row(
                    children: List.generate(tabs.length, (idx) {
                      final isSelected = state.selectedChartTab == idx;
                      return Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(7),
                          onTap: () => notifier.selectChartTab(idx),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 160),
                            padding: const EdgeInsets.symmetric(vertical: 6.5),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? DeckColors.card(context)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(7),
                              border: isSelected
                                  ? Border.all(color: DeckColors.subtleBorder(context), width: 0.8)
                                  : null,
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.05),
                                        blurRadius: 3,
                                        offset: const Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  tabs[idx]['icon'] as IconData,
                                  size: 13,
                                  color: isSelected
                                      ? DeckColors.accentIndigo
                                      : DeckColors.textMuted(context),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    tabs[idx]['short'] as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                      color: isSelected
                                          ? DeckColors.textPrimary(context)
                                          : DeckColors.textMuted(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }

              return Wrap(
                spacing: 8,
                runSpacing: 6,
                children: List.generate(tabs.length, (idx) {
                  final isSelected = state.selectedChartTab == idx;
                  return InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => notifier.selectChartTab(idx),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? DeckColors.accentIndigo.withValues(alpha: 0.16)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? DeckColors.accentIndigo.withValues(alpha: 0.6)
                              : DeckColors.subtleBorder(context),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            tabs[idx]['icon'] as IconData,
                            size: 14,
                            color: isSelected
                                ? DeckColors.accentIndigo
                                : DeckColors.textMuted(context),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            tabs[idx]['label'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected
                                  ? DeckColors.textPrimary(context)
                                  : DeckColors.textMuted(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 16),

          // Chart Canvas
          SizedBox(
            height: 200,
            child: Builder(
              builder: (context) {
                switch (state.selectedChartTab) {
                  case 0:
                    final maxCpu = state.cpuHistory.isEmpty ? 0.0 : state.cpuHistory.reduce((a, b) => a > b ? a : b);
                    final dynamicMaxY = maxCpu > 35 ? 100.0 : (maxCpu > 10 ? 50.0 : 20.0);
                    final interval = dynamicMaxY / 4;
                    return _buildSingleLineChart(
                      context,
                      values: state.cpuHistory,
                      color: DeckColors.accentIndigo,
                      maxY: dynamicMaxY,
                      horizontalInterval: interval,
                      formatTooltip: (v) => '${l10n.metric_cpu}: ${v.toStringAsFixed(1)}%',
                    );
                  case 1:
                    return _buildSingleLineChart(
                      context,
                      values: state.memoryHistory,
                      color: DeckColors.accentCyan,
                      maxY: 100,
                      horizontalInterval: 25,
                      formatTooltip: (v) => '${l10n.metric_memory}: ${v.toStringAsFixed(1)}%',
                    );
                  case 2:
                    return _buildDualLineNetworkChart(
                      context,
                      downValues: state.netDownHistory,
                      upValues: state.netUpHistory,
                    );
                  case 3:
                  default:
                    final maxLoad = state.loadHistory.isEmpty ? 0.0 : state.loadHistory.reduce((a, b) => a > b ? a : b);
                    final dynamicMaxLoad = (maxLoad * 1.5).clamp(1.0, 50.0);
                    final loadInterval = (dynamicMaxLoad / 4).clamp(0.5, 50.0);
                    return _buildSingleLineChart(
                      context,
                      values: state.loadHistory,
                      color: DeckColors.accentPurple,
                      maxY: dynamicMaxLoad,
                      horizontalInterval: loadInterval,
                      formatTooltip: (v) => '${l10n.metric_load} 1m: ${v.toStringAsFixed(2)}',
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleLineChart(
    BuildContext context, {
    required List<double> values,
    required Color color,
    required double maxY,
    required double horizontalInterval,
    required String Function(double) formatTooltip,
  }) {
    final safeValues = values.isEmpty ? [0.0, 0.0] : values;
    final spots = <FlSpot>[];
    for (int i = 0; i < safeValues.length; i++) {
      spots.add(FlSpot(i.toDouble(), safeValues[i].clamp(0.0, maxY)));
    }

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: (safeValues.length - 1).toDouble(),
        minY: 0,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: horizontalInterval,
          checkToShowHorizontalLine: (value) => value > 0 && value <= maxY,
          getDrawingHorizontalLine: (value) => FlLine(
            color: DeckColors.subtleBorder(context).withValues(alpha: 0.5),
            strokeWidth: 1.0,
            dashArray: [4, 4],
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              interval: horizontalInterval,
              getTitlesWidget: (v, meta) {
                if (v == meta.min || v == meta.max) return const SizedBox.shrink();
                return Text(
                  maxY == 100 || maxY == 50 || maxY == 20 ? '${v.toInt()}%' : v.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 10,
                    color: DeckColors.textMuted(context),
                  ),
                );
              },
            ),
          ),
          bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  formatTooltip(spot.y),
                  const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: color,
            barWidth: 2.5,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withValues(alpha: 0.28),
                  color.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ],
      ),
      duration: Duration.zero,
    );
  }

  Widget _buildDualLineNetworkChart(
    BuildContext context, {
    required List<double> downValues,
    required List<double> upValues,
  }) {
    final l10n = context.l10n;
    final safeDown = downValues.isEmpty ? [0.0, 0.0] : downValues;
    final safeUp = upValues.isEmpty ? [0.0, 0.0] : upValues;
    final len = safeDown.length > safeUp.length ? safeDown.length : safeUp.length;

    final downSpots = <FlSpot>[];
    final upSpots = <FlSpot>[];
    double maxSpeed = 1024.0; // At least 1 KB/s

    for (int i = 0; i < len; i++) {
      final d = i < safeDown.length ? safeDown[i] : 0.0;
      final u = i < safeUp.length ? safeUp[i] : 0.0;
      downSpots.add(FlSpot(i.toDouble(), d));
      upSpots.add(FlSpot(i.toDouble(), u));
      if (d > maxSpeed) maxSpeed = d;
      if (u > maxSpeed) maxSpeed = u;
    }

    final maxY = maxSpeed * 1.25;
    final netInterval = (maxY / 4).clamp(256.0, double.infinity);

    return Column(
      children: [
        Wrap(
          alignment: WrapAlignment.end,
          spacing: 12,
          runSpacing: 4,
          children: [
            _buildLegendPill(l10n.dashboard_net_down, DeckColors.statusOnline),
            _buildLegendPill(l10n.dashboard_net_up, DeckColors.accentCyan),
          ],
        ),
        const SizedBox(height: 8),
        Expanded(
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (len - 1).toDouble(),
              minY: 0,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: netInterval,
                checkToShowHorizontalLine: (value) => value > 0 && value <= maxY,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: DeckColors.subtleBorder(context).withValues(alpha: 0.5),
                  strokeWidth: 1.0,
                  dashArray: [4, 4],
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 52,
                    interval: netInterval,
                    getTitlesWidget: (v, meta) {
                      if (v == meta.min || v == meta.max) return const SizedBox.shrink();
                      return Text(
                        Formatters.formatNetworkRate(v),
                        style: TextStyle(
                          fontSize: 9,
                          color: DeckColors.textMuted(context),
                        ),
                      );
                    },
                  ),
                ),
                bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      final isDown = spot.barIndex == 0;
                      return LineTooltipItem(
                        '${isDown ? '${l10n.dashboard_net_down}: ' : '${l10n.dashboard_net_up}: '}${Formatters.formatNetworkRate(spot.y)}',
                        TextStyle(
                          color: isDown ? DeckColors.statusOnline : DeckColors.accentCyan,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: downSpots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: DeckColors.statusOnline,
                  barWidth: 2.2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        DeckColors.statusOnline.withValues(alpha: 0.2),
                        DeckColors.statusOnline.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
                LineChartBarData(
                  spots: upSpots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: DeckColors.accentCyan,
                  barWidth: 2.2,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        DeckColors.accentCyan.withValues(alpha: 0.15),
                        DeckColors.accentCyan.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            duration: Duration.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendPill(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
