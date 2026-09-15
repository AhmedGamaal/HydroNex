import 'package:flutter/material.dart';

class OnboardingLogo extends StatelessWidget {
  const OnboardingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 144,
      left: 0,
      right: 0,
      child: Center(
        child: Image.asset(
          'assets/images/HydroNex_logo.png',
          width: 156,
          height: 29,
        ),
      ),
    );
  }
}