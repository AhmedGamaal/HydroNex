import 'package:flutter/material.dart';
import 'package:hydronex_app/core/constants/app_colors.dart';
import 'package:hydronex_app/core/constants/app_text_styles.dart';

/// "Didn't receive code? Resend in Ns" line used on the OTP screen.
/// Takes the remaining cooldown seconds and renders either the
/// countdown or an active "Resend" link — all the cubit has to do is
/// hand over [secondsLeft] and react to [onResend].
class OtpResendLink extends StatelessWidget {
  final int secondsLeft;
  final VoidCallback onResend;
  final String prompt;

  const OtpResendLink({
    super.key,
    required this.secondsLeft,
    required this.onResend,
    this.prompt = "Didn't receive code? ",
  });

  bool get _canResend => secondsLeft <= 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _canResend ? onResend : null,
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontFamily: AppTextStyles.fontFamily),
            children: [
              TextSpan(
                text: prompt,
                style: TextStyle(fontSize: 14, color: AppColors.black(0.5)),
              ),
              TextSpan(
                text: _canResend ? 'Resend' : 'Resend in ${secondsLeft}s',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _canResend ? AppColors.primaryDark : AppColors.black(0.4),
                  decoration: _canResend ? TextDecoration.underline : TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
