import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class SensorTermCard extends StatelessWidget {
  String iconName;
  String title;
  String idealRange;

  SensorTermCard({super.key, 
    required this.iconName,
    required this.title,
    required this.idealRange,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.lightSage,
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/$iconName.svg', width: 24, height: 24),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.titleMedium),
                Text(idealRange, style: textTheme.titleSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
