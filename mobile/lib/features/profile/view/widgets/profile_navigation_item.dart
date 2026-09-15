import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class ProfileNavigationItem extends StatelessWidget {
  String title;
  String iconName;
  VoidCallback onTap;
  Color? textColor;

  ProfileNavigationItem({
    required this.title,
    required this.iconName,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.14)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/$iconName.svg',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextTheme.of(
                  context,
                ).titleMedium!.copyWith(color: textColor ?? AppTheme.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
