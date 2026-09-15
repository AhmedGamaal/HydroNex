import 'package:flutter/material.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/features/home/data/models/crop_model.dart';

class CropCard extends StatelessWidget {
  final VoidCallback? onTap;
  final CropModel crop;

  const CropCard({super.key, required this.crop, this.onTap});

  @override
  Widget build(BuildContext context) {
    final progressPercentage = double.tryParse(crop.progress) ?? 0;
    final progressValue = (progressPercentage / 100).clamp(0.0, 1.0);

    final textTheme = TextTheme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 120,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.4),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          spacing: 20,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                crop.image,
                width: 115,
                height: 95,
                fit: BoxFit.fill,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(crop.name, style: textTheme.titleMedium),
                  Text(
                    'Batch ID: ${crop.batchId}',
                    style: textTheme.titleSmall,
                  ),
                  Text(
                    'Day ${crop.currentDay} / ${crop.totalDays}',
                    style: textTheme.labelLarge,
                  ),
                  const SizedBox(height: 15),
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progressValue,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                          backgroundColor: AppTheme.primary.withValues(
                            alpha: 0.2,
                          ),
                          color: AppTheme.primary,
                        ),
                      ),
                      Text(
                        '${progressPercentage.toInt()}%',
                        style: textTheme.labelLarge,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
