import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/features/analysis/data/models/analysis_model.dart';

class EnvironmentTrendsCard extends StatelessWidget {
  final List<TrendModel> trends;

  const EnvironmentTrendsCard({super.key, required this.trends});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);

    if (trends.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.black),
        ),
        child: Text(
          'No environment data available',
          style: textTheme.titleMedium,
        ),
      );
    }

    final values = trends.map((trend) => trend.value).toList();

    final minValue = values.reduce((a, b) => a < b ? a : b);

    final maxValue = values.reduce((a, b) => a > b ? a : b);

    final range = maxValue - minValue;

    final padding = range == 0 ? 2.0 : range * 0.2;

    final chartMinY = minValue - padding;
    final chartMaxY = maxValue + padding;

    final interval = _calculateInterval(chartMinY, chartMaxY);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Environment Trends', style: textTheme.titleLarge),

          const SizedBox(height: 16),

          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (trends.length - 1).toDouble(),
                minY: chartMinY,
                maxY: chartMaxY,

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: AppTheme.lightSage, strokeWidth: 1);
                  },
                ),

                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      reservedSize: 35,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: textTheme.titleSmall!.copyWith(
                            color: AppTheme.gery,
                          ),
                        );
                      },
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _getBottomInterval(trends.length),
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();

                        if (index < 0 || index >= trends.length) {
                          return const SizedBox.shrink();
                        }

                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            trends[index].day,
                            style: textTheme.titleSmall!.copyWith(
                              color: AppTheme.gery,
                              fontSize: 9,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    spots: trends.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value.value);
                    }).toList(),

                    isCurved: true,
                    barWidth: 3,
                    color: AppTheme.resolvedText,
                    dashArray: [8, 6],

                    dotData: const FlDotData(show: true),

                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppTheme.resolvedText.withValues(alpha: 0.18),
                          AppTheme.resolvedText.withValues(alpha: 0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _calculateInterval(double minY, double maxY) {
    final range = maxY - minY;

    if (range <= 5) {
      return 1;
    }

    if (range <= 10) {
      return 2;
    }

    if (range <= 20) {
      return 5;
    }

    if (range <= 50) {
      return 10;
    }

    return 20;
  }

  double _getBottomInterval(int length) {
    if (length <= 6) {
      return 1;
    }

    if (length <= 12) {
      return 2;
    }

    if (length <= 24) {
      return 4;
    }

    return 6;
  }
}
