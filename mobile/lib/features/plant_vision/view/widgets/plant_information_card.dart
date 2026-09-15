import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:hydronex_app/core/theme/app_theme.dart';

class PlantInformationCard extends StatelessWidget {
  final String plantType;
  final String growthStage;
  final String age;
  final String system;

  const PlantInformationCard({
    super.key,
    required this.plantType,
    required this.growthStage,
    required this.age,
    required this.system,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InformationItem(
            icon: 'assets/icons/plant_type.svg',
            title: 'Plant Type',
            value: plantType,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _InformationItem(
            icon: 'assets/icons/growth_stage.svg',
            title: 'Growth Stage',
            value: growthStage,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _InformationItem(
            icon: 'assets/icons/age.svg',
            title: 'Age',
            value: age,
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: _InformationItem(
            icon: 'assets/icons/system.svg',
            title: 'System',
            value: system,
          ),
        ),
      ],
    );
  }
}

class _InformationItem extends StatelessWidget {
  final String icon;
  final String title;
  final String value;

  const _InformationItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);
    return Container(
      height: 130,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.cream,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.21)),
      ),
      child: Column(
        children: [
          SvgPicture.asset(icon, width: 24, height: 24),
          SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: textTheme.titleSmall),
          const SizedBox(height: 6),
          Expanded(
            child: Center(
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: textTheme.titleSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
