import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydronex_app/core/constants/app_colors.dart';

class ChartCard extends StatelessWidget {
  final String? asset;
  final Widget? child;

  const ChartCard({
    super.key,
    this.asset,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 273,
      height: 90,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(48),
        border: Border.all(
          color: Colors.black,
          width: 1,
        ),
      ),
      child: child ??
          SvgPicture.asset(
            asset!,
            height: 55,
            fit: BoxFit.contain,
          ),
    );
  }
}