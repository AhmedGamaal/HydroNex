import 'package:flutter/material.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final String text;

  const StatusBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (text.toLowerCase()) {
      case 'critical':
        backgroundColor = AppTheme.criticalBackground;
        textColor = AppTheme.criticalText;
        break;

      case 'warning':
        backgroundColor = AppTheme.warningBackground;
        textColor = AppTheme.warningText;
        break;

      case 'resolved':
        backgroundColor = AppTheme.resolvedBackground;
        textColor = AppTheme.resolvedText;
        break;

      case 'open':
        backgroundColor = AppTheme.warningBackground;
        textColor = AppTheme.warningText;
        break;

      default:
        backgroundColor = AppTheme.warningBackground;
        textColor = AppTheme.warningText;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: AppTheme.fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ).copyWith(color: textColor),
      ),
    );
  }
}
