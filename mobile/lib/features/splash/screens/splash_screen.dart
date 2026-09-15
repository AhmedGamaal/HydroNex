import 'package:flutter/material.dart';
import 'package:hydronex_app/core/constants/app_colors.dart';
import 'package:hydronex_app/core/routes/app_routes.dart';
import 'package:hydronex_app/features/splash/widgets/animated_logo.dart';

class SplashScreen extends StatelessWidget {
  static const String routeName = AppRoutes.splash;

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: const Center(child: AnimatedLogo()),
    );
  }
}
