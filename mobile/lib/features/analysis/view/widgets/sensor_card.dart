import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/features/analysis/data/models/analysis_model.dart';
import 'package:hydronex_app/features/analysis/view/widgets/sensor_chart.dart';

class SensorCard extends StatelessWidget {
  final SensorModel sensor;

  const SensorCard({super.key, required this.sensor});

  Color getSensorColor() {
    switch (sensor.iconName) {
      case 'temperature':
        return AppTheme.temperature;

      case 'temperature_water':
        return AppTheme.temperature;

      case 'ph':
        return AppTheme.ph;

      case 'ec':
        return AppTheme.ec;

      case 'humidity':
        return AppTheme.humidity;

      case 'light':
        return AppTheme.light;

      case 'water':
        return AppTheme.water;

      case 'co2':
        return AppTheme.ec;

      default:
        return AppTheme.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final sensorColor = getSensorColor();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: sensorColor),
      ),
      child: Row(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/${sensor.iconName}.svg',
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 8),
              Column(
                children: [
                  Text(sensor.name, style: textTheme.titleMedium),
                  Text(
                    '${sensor.value}${sensor.unit}',
                    style: textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text('Optimal Range', style: textTheme.labelLarge),
                  Text(sensor.optimalRange, style: textTheme.labelLarge),
                ],
              ),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SensorChart(chartData: sensor.chartData, color: sensorColor),
          ),
        ],
      ),
    );
  }
}
