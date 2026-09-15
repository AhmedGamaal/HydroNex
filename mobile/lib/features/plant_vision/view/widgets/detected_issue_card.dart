import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/features/plant_vision/data/models/detected_issue_model.dart';

class DetectedIssueCard extends StatelessWidget {
  final DetectedIssueModel issue;

  const DetectedIssueCard({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);

    final bool isLow = issue.severity.toLowerCase() == 'low';

    final Color severityBackground = isLow
        ? AppTheme.lowSeverity
        : AppTheme.moderateSeverity;

    final Color severityText = isLow ? AppTheme.primary : Colors.white;

    final Color leafColor = isLow
        ? AppTheme.resolvedText
        : AppTheme.moderateSeverity;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppTheme.primary.withValues(alpha: 0.26),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/leaf.svg',
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(leafColor, BlendMode.srcIn),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(issue.name, style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(issue.description, style: textTheme.titleSmall),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: severityBackground,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              issue.severity,
              style: textTheme.titleSmall!.copyWith(color: severityText),
            ),
          ),
        ],
      ),
    );
  }
}
