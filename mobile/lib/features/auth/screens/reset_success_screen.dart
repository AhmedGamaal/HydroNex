import 'package:flutter/material.dart';

import 'package:hydronex_app/core/constants/app_text_styles.dart';
import 'package:hydronex_app/core/widgets/custom_button.dart';

import '../widgets/auth_header.dart';
import '../widgets/auth_scaffold.dart';
import 'sign_in_screen.dart';

class ResetSuccessScreen extends StatelessWidget {
  static const String routeName = '/ResetSuccessScreen';

  final String title;
  final String message;
  final VoidCallback? onBackToLogin;

  const ResetSuccessScreen({
    super.key,
    this.title = 'Ready to Explore !',
    this.message = 'Your account password has been changed successfully.',
    this.onBackToLogin,
  });

  void _goToLogin(BuildContext context) {
    if (onBackToLogin != null) {
      onBackToLogin!();
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(SignInScreen.routeName, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthHeader(
                    title: title,
                    titleStyle: AppTextStyles.headingSemibold24,
                    subtitle: message,
                    subtitleStyle: AppTextStyles.bodyMuted16,
                    gap: 20,
                  ),
                  const SizedBox(height: 64),
                  CustomButton(text: 'Go back to login', onPressed: () => _goToLogin(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
