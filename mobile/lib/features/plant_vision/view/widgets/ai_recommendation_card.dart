import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:hydronex_app/core/theme/app_theme.dart';

class AiRecommendationCard extends StatelessWidget {
  final String recommendation;

  const AiRecommendationCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.recommendationBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/lamb.svg'),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation,
                  style: TextTheme.of(
                    context,
                  ).titleMedium!.copyWith(fontWeight: .w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
