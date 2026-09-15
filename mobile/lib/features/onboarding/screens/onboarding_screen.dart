import 'package:flutter/material.dart';
import 'package:hydronex_app/core/widgets/logo.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../core/routes/app_routes.dart';
import '../widgets/onboarding_background.dart';
import '../widgets/onboarding_charts.dart';
import '../widgets/onboarding_actions.dart';

class OnboardingScreen extends StatelessWidget {
  static const String routeName = AppRoutes.onboarding;

  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          const OnboardingBackground(),
          const OnboardingLogo(),
          const OnboardingCharts(),
          const OnboardingActions(),
        ],
      ),
    );
  }
}