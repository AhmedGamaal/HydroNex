import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:hydronex_app/core/theme/app_theme.dart';

class AiBotFeatureCard extends StatelessWidget {
  String text;

  AiBotFeatureCard({required this.text});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            text,
            style: textTheme.titleSmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightgery,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
