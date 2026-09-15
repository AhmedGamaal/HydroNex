import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/routes/route_context_extention.dart';

class OnboardingActions extends StatelessWidget {
  const OnboardingActions({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const Spacer(),

            Text.rich(
              TextSpan(
                children: [
                  _bullet('Monitor'),
                  _bullet('Analyses'),
                  _bullet('Grow'),
                ],
              ),
              style: AppTextStyles.onboardingTitle,
            ),

            const SizedBox(height: 16),

            Text(
              'Real-time monitoring, AI insights, and smart recommendations for your hydroponic farm.',
              textAlign: TextAlign.center,
              style: AppTextStyles.onboardingSubtitle,
            ),

            const SizedBox(height: 24),

            CustomButton(
              text: 'Get Started',
              onPressed: () {
                context.pushNamed(AppRoutes.signUp);
              },
            ),

            const SizedBox(height: 16),

            CustomButton(
              text: 'Sign In',
              isPrimary: false,
              onPressed: () {
                context.pushNamed(AppRoutes.signIn);
              },
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  TextSpan _bullet(String text) {
    return TextSpan(text: '•  $text   ');
  }
}
