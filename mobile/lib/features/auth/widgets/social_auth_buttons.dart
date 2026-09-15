import 'package:flutter/material.dart';
import 'package:hydronex_app/core/constants/app_colors.dart';
import 'package:hydronex_app/core/constants/app_text_styles.dart';
class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onFacebookTap;
  final VoidCallback? onGoogleTap;
  final Widget? facebookIcon;
  final Widget? googleIcon;

  const SocialAuthButtons({
    super.key,
    this.onFacebookTap,
    this.onGoogleTap,
    this.facebookIcon,
    this.googleIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            label: 'Facebook',
            icon: Image.asset('assets/icons/logos_facebook.png') ,
            onTap: onFacebookTap,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _SocialButton(
            label: 'Google',
            icon: Image.asset('assets/icons/icons_google.png') ,
            onTap: onGoogleTap,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onTap;

  const _SocialButton({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryDark),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 24, width: 24, child: icon),
            const SizedBox(width: 8),
            Text(label, style: AppTextStyles.authSocialLabel),
          ],
        ),
      ),
    );
  }
}


