import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/core/widgets/status_badge.dart';
import 'package:hydronex_app/features/alerts/data/models/alert_response.dart';

class AlertItem extends StatelessWidget {
  final AlertResponse alert;

  const AlertItem({super.key, required this.alert});

  String _getIconName() {
    final message = alert.message.toLowerCase();

    if (message.contains('ph')) {
      return 'ph';
    }

    if (message.contains('ec')) {
      return 'ec';
    }

    if (message.contains('humidity')) {
      return 'humidity';
    }

    if (message.contains('light')) {
      return 'light';
    }

    if (message.contains('water level')) {
      return 'water';
    }

    if (message.contains('water temperature')) {
      return 'temperature';
    }

    if (message.contains('air temperature')) {
      return 'temperature';
    }

    return 'temperature';
  }

  Color _getSensorColor() {
    final iconName = _getIconName();

    switch (iconName) {
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

      case 'temperature':
        return AppTheme.temperature;

      default:
        return AppTheme.primary;
    }
  }

  String _getTime() {
    final difference = DateTime.now().difference(alert.createdAt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    }

    if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    }

    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    }

    return '${alert.createdAt.day}/${alert.createdAt.month}/${alert.createdAt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    final sensorColor = _getSensorColor();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: sensorColor.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/${_getIconName()}.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(sensorColor, BlendMode.srcIn),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              children: [
                Text(
                  alert.message,
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Text(_getTime(), style: textTheme.titleSmall),
              ],
            ),
          ),

          const SizedBox(width: 30),

          StatusBadge(text: alert.status),
        ],
      ),
    );
  }
}
