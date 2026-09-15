import 'package:flutter/material.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class AiBotLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.lightSage,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          width: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildDot(), _buildDot(), _buildDot()],
          ),
        ),
      ),
    );
  }

  Widget _buildDot() {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(
        color: AppTheme.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}
