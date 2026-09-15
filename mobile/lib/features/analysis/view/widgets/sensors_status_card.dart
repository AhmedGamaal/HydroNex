import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class SensorsStatusCard extends StatelessWidget {
  bool allSensorsOnline;
  String lastUpdated;

  SensorsStatusCard({
    required this.allSensorsOnline,
    required this.lastUpdated,
  });
  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.lightSage,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: allSensorsOnline ? AppTheme.liveGreen : AppTheme.red,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                allSensorsOnline
                    ? 'All Sensors Online'
                    : 'Some Sensors Offline',
                style: textTheme.titleMedium,
              ),
              Text('Last updated: $lastUpdated', style: textTheme.titleSmall),
            ],
          ),
          Spacer(),
          SvgPicture.asset('assets/icons/wifi.svg'),
        ],
      ),
    );
  }
}
