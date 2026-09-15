import 'package:flutter/material.dart';
import 'package:hydronex_app/features/profile/view/widgets/sensor_term_card.dart';

class SensorTermSection extends StatelessWidget {
  const SensorTermSection({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> sensors = [
      {
        'iconName': 'ph',
        'title': 'PH (Acidity of Water)',
        'idealRange': 'Ideal Range: 5.5 - 6.5',
      },
      {
        'iconName': 'ec',
        'title': 'EC (Electrical Conductivity / Nutrient Strength)',
        'idealRange': 'Ideal Range: 0.8 - 2.5 dS/m',
      },
      {
        'iconName': 'humidity',
        'title': 'Humidity (Moisture in Air)',
        'idealRange': 'Ideal Range: 40% - 80% RH',
      },
      {
        'iconName': 'temperature',
        'title': 'Temperature (Heat in the Air)',
        'idealRange': 'Ideal Range: 18°C - 28°C',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sensor Terms Explained',
          style: TextTheme.of(context).titleMedium,
        ),
        const SizedBox(height: 16),

        ...sensors.map(
          (sensor) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SensorTermCard(
              iconName: sensor['iconName']!,
              title: sensor['title']!,
              idealRange: sensor['idealRange']!,
            ),
          ),
        ),
      ],
    );
  }
}
