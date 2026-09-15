import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class GrowthStageCard extends StatelessWidget {
  String iconName;
  String title;
  String description;
  String details;

  GrowthStageCard({super.key, 
    required this.iconName,
    required this.title,
    required this.description,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.lightSage,
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          SvgPicture.asset('assets/icons/$iconName.svg', width: 24, height: 24),
          Text(title, style: textTheme.titleMedium),
          SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: textTheme.titleSmall,
          ),
          SizedBox(height: 4),
          Text(
            details,
            textAlign: TextAlign.center,
            style: textTheme.labelLarge,
          ),
        ],
      ),
      
    );
  }
}
