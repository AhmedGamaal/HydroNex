import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SensorChart extends StatelessWidget {
  final List<double> chartData;
  final Color color;

  const SensorChart({super.key, required this.chartData, required this.color});

  @override
  Widget build(BuildContext context) {
    if (chartData.isEmpty) {
      return const SizedBox(height: 65);
    }

    final maxValue = chartData.reduce((a, b) => a > b ? a : b);

    final minValue = chartData.reduce((a, b) => a < b ? a : b);

    final range = maxValue - minValue;

    final chartMaxY = maxValue + (range == 0 ? 1 : range * 0.15);

    final chartMinY = minValue - (range == 0 ? 1 : range * 0.15);

    return SizedBox(
      height: 65,
      child: LineChart(
        LineChartData(
          minY: chartMinY,
          maxY: chartMaxY,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: chartData.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value);
              }).toList(),
              isCurved: true,
              barWidth: 2.5,
              color: color,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.30),
                    color.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
