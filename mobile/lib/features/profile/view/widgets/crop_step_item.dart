import 'package:flutter/material.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class CropStepItem extends StatelessWidget {
  String text;

  CropStepItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.lightSage,
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.22)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '•  $text',
        style: TextTheme.of(context).titleMedium!.copyWith(fontWeight: .w500),
      ),
    );
  }
}
