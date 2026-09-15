import 'package:flutter/material.dart';
import 'package:hydronex_app/core/constants/app_text_styles.dart';

class AuthFooterLink extends StatelessWidget {
  final String question;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.question,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(question, style: AppTextStyles.authSmallText),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onTap,
            child: Text(actionText, style: AppTextStyles.authLink),
          ),
        ],
      ),
    );
  }
}
