import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF0D2D1E);
  static const Color cream = Color(0xFFE7EFDA);

  // Auth-flow additions
  static const Color headingDark = Color(0xFF1E232C);
  static const Color textMuted = Color(0xFF80807F);
  static const Color inputBorder = primaryDark;
  static const Color inputInactiveBg = Color(0x33D9D9D9);
  static const Color inputInactiveBorder = Color(0x1A000000);
  static const Color error = Color(0xFFD64545);
  static const Color buttonInactiveBg = Color(0xFFC7D0B9);

  static Color black(double opacity) => Colors.black.withOpacity(opacity);
}
