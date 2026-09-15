import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 486,
      child: SvgPicture.asset(
        'assets/images/onboarding_bg.svg',
        fit: BoxFit.fill,
        alignment: Alignment.bottomCenter,
      ),
    );
  }
}