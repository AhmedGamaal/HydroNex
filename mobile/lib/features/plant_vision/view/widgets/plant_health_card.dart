import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class PlantHealthCard extends StatelessWidget {
  final String healthStatus;
  final String healthPercentage;
  final String confidence;

  const PlantHealthCard({
    super.key,
    required this.healthStatus,
    required this.healthPercentage,
    required this.confidence,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.07),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset('assets/icons/plant_health.svg'),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Plant Health', style: textTheme.titleSmall),
                      Text(
                        '$healthStatus  $healthPercentage',
                        style: textTheme.titleMedium!.copyWith(
                          color: AppTheme.green,
                        ),
                      ),
                      Text('Overall Health Score', style: textTheme.labelLarge),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 80,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.07),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Confidence', style: textTheme.titleSmall),
                const SizedBox(height: 3),
                Text(
                  confidence,
                  style: textTheme.titleMedium!.copyWith(color: AppTheme.green),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
