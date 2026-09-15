import 'package:flutter/material.dart';
import 'package:hydronex_app/core/constants/app_colors.dart';

/// A small tappable line of text (e.g. "Forget password?"). Kept
/// generic and reusable rather than hard-coded per screen.
class AuthTextLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final TextStyle? style;

  const AuthTextLink({
    super.key,
    required this.text,
    required this.onTap,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: style ?? TextStyle(fontSize: 12, color: AppColors.black(0.68)),
      ),
    );
  }
}
