import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const String fontFamily = 'Manrope';

  static const TextStyle buttonText = TextStyle(
  fontFamily: fontFamily,
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
static const TextStyle onboardingTitle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: AppColors.primaryDark,
);

static const TextStyle onboardingSubtitle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 14,
  color: Color(0x800D2D1E), 
);

// ---- Auth flow ----
static const TextStyle authTitle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

static const TextStyle authSubtitle = TextStyle(
  fontFamily: fontFamily,
  fontSize: 12,
  fontWeight: FontWeight.normal,
  color: Color(0xB3000000),
);

static const TextStyle authInputText = TextStyle(
  fontFamily: fontFamily,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: Colors.black,
);

static const TextStyle authInputHint = TextStyle(
  fontFamily: fontFamily,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: Color(0x99000000),
);

static const TextStyle authSmallText = TextStyle(
  fontFamily: fontFamily,
  fontSize: 12,
  fontWeight: FontWeight.normal,
  color: Color(0xBD000000),
);

static const TextStyle authLink = TextStyle(
  fontFamily: fontFamily,
  fontSize: 12,
  fontWeight: FontWeight.w600,
  color: AppColors.primaryDark,
  // decoration: TextDecoration.underline,
);

static const TextStyle authSocialLabel = TextStyle(
  fontFamily: fontFamily,
  fontSize: 12,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

static const TextStyle headingBold24 = TextStyle(
  fontFamily: fontFamily,
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: AppColors.headingDark,
);

static const TextStyle headingSemibold24 = TextStyle(
  fontFamily: fontFamily,
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: AppColors.headingDark,
);

static const TextStyle bodyMuted16 = TextStyle(
  fontFamily: fontFamily,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: AppColors.textMuted,
);

static const TextStyle bodyPrimaryDark16 = TextStyle(
  fontFamily: fontFamily,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: AppColors.primaryDark,
);

static const TextStyle otpDigit = TextStyle(
  fontFamily: fontFamily,
  fontSize: 20,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);
}