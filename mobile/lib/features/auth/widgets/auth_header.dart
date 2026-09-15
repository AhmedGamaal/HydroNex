import 'package:flutter/material.dart';
import 'package:hydronex_app/core/constants/app_text_styles.dart';

/// Shared header block used across the auth flow (Sign In, Sign Up,
/// OTP, Set New Password, Success). Keeping it as one widget means the
/// logo + title + subtitle spacing only has to be tuned in one place.
class AuthHeader extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool showLogo;
  final double gap;
  final double subtitleGap;
  final TextAlign textAlign;

  const AuthHeader({
    super.key,
    this.title,
    this.subtitle,
    this.titleStyle,
    this.subtitleStyle,
    this.showLogo = true,
    this.gap = 8,
    this.subtitleGap = 4,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLogo) ...[
          Image.asset(
            'assets/images/HydroNex_dark.png',
            width: 156,
            height: 29,
          ),
          SizedBox(height: gap),
        ],
        if (title != null)
          Text(
            title!,
            textAlign: textAlign,
            style: titleStyle ?? AppTextStyles.authTitle,
          ),
        if (subtitle != null) ...[
          SizedBox(height: subtitleGap),
          Text(
            subtitle!,
            textAlign: textAlign,
            style: subtitleStyle ?? AppTextStyles.authSubtitle,
          ),
        ],
      ],
    );
  }
}
