import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Compact mini sparkline chart embedded in KPI metric cards.
class MetricSparkline extends StatelessWidget {
  final List<double> values;
  final Color color;
  final double? height;
  final double? minY;
  final double? maxY;

  const MetricSparkline({
    super.key,
    required this.values,
    required this.color,
    this.height,
    this.minY,
    this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) {
      return SizedBox(height: height ?? 28);
    }

    final safeValues = values.length == 1 ? [values.first, values.first] : values;
    final spots = <FlSpot>[];
    for (int i = 0; i < safeValues.length; i++) {
      spots.add(FlSpot(i.toDouble(), safeValues[i].clamp(0.0, 1000000000.0)));
    }

    // Determine bounds
    final dataMin = safeValues.reduce((a, b) => a < b ? a : b);
    final dataMax = safeValues.reduce((a, b) => a > b ? a : b);
    final effectiveMinY = minY ?? (dataMin < 0 ? dataMin : 0.0);
    final effectiveMaxY = maxY ?? (dataMax > effectiveMinY ? dataMax * 1.15 : 10.0);

    final chart = LineChart(
      LineChartData(
        minX: 0,
        maxX: (safeValues.length - 1).toDouble(),
        minY: effectiveMinY,
        maxY: effectiveMaxY,
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            curveSmoothness: 0.35,
            color: color,
            barWidth: 2.0,
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
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuad,
    );

    if (height != null) {
      return SizedBox(
        height: height,
        width: double.infinity,
        child: chart,
      );
    }

    return chart;
  }
}
