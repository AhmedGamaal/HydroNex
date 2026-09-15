import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hydronex_app/core/constants/app_colors.dart';
import 'package:hydronex_app/core/constants/app_text_styles.dart';

/// "By continuing you accept our Terms of Service..." footer.
/// Was a private class nested inside `SetNewPasswordScreen` — moved
/// here so it's a normal reusable widget like the rest of `widgets/`.
class TermsFooter extends StatelessWidget {
  final VoidCallback? onTermsTap;
  final VoidCallback? onPrivacyTap;
  final VoidCallback? onCookiesTap;

  const TermsFooter({
    super.key,
    this.onTermsTap,
    this.onPrivacyTap,
    this.onCookiesTap,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 12,
      color: AppColors.textMuted,
    );
    final linkStyle = baseStyle.copyWith(
      color: AppColors.primaryDark,
      decoration: TextDecoration.underline,
    );

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: baseStyle,
        children: [
          const TextSpan(text: 'By continuing you accept our '),
          TextSpan(
            text: 'Terms of Service',
            style: linkStyle,
            recognizer: onTermsTap == null ? null : (TapGestureRecognizer()..onTap = onTermsTap),
          ),
          const TextSpan(text: '. Also learn how we process your data in our '),
          TextSpan(
            text: 'Privacy Policy',
            style: linkStyle,
            recognizer: onPrivacyTap == null ? null : (TapGestureRecognizer()..onTap = onPrivacyTap),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Cookies policy',
            style: linkStyle,
            recognizer: onCookiesTap == null ? null : (TapGestureRecognizer()..onTap = onCookiesTap),
          ),
          const TextSpan(text: '.'),
        ],
      ),
    );
  }
}
