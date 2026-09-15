import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class LiveStatusCard extends StatelessWidget {
  const LiveStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset('assets/icons/live.svg'),
          SizedBox(width: 8),
          Text(
            'Live',
            style: TextTheme.of(
              context,
            ).titleMedium!.copyWith(color: AppTheme.cream),
          ),
          Spacer(),
          SvgPicture.asset('assets/icons/date.svg'),
        ],
      ),
    );
  }
}
