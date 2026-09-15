import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class AskAiCard extends StatelessWidget {
  VoidCallback? onPressed;

  AskAiCard({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Still have questions?',
                  style: textTheme.titleMedium!.copyWith(color: AppTheme.cream),
                ),
                SizedBox(height: 4),
                Text(
                  'Ask our Farm Intelligence AI anything about your crops',
                  style: textTheme.labelLarge!.copyWith(color: AppTheme.cream),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.cream,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ai_recommendation.svg',
                    colorFilter: ColorFilter.mode(
                      AppTheme.black,
                      BlendMode.srcIn,
                    ),
                    width: 20,
                    height: 20,
                  ),
                  SizedBox(width: 6),
                  Text('Ask AI', style: textTheme.titleSmall),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
