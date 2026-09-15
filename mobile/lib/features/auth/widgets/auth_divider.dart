import 'package:flutter/material.dart';
import 'package:hydronex_app/core/constants/app_colors.dart';
import 'package:hydronex_app/core/constants/app_text_styles.dart';

class AuthDivider extends StatelessWidget {
  final String label;

  const AuthDivider({super.key, this.label = 'OR'});

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Divider(color: AppColors.black(0.2), thickness: 2, height: 1),
    );
    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(label, style: AppTextStyles.authSocialLabel),
        ),
        line,
      ],
    );
  }
}
