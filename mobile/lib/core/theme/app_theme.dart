import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF0D2D1E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color cream = Color(0xFFE7EFDA);
  static const Color lightSage = Color(0xFFDAE6D8);
  static const Color darkGery = Color(0xFF3C3C41);
  static const Color lightgery = Color(0xFFA0A0A5);
  static const Color gery = Color(0xFF757474);
  static const Color red = Color(0xFFEA3B37);
  static const Color liveGreen = Color(0xFF43EE7D);
  static const Color green = Color(0xFF237850);
  static const Color criticalBackground = Color(0xFFEED1D1);
  static const Color criticalText = Color(0xFFD70C22);
  static const Color warningBackground = Color(0xFFFDE9C5);
  static const Color warningText = Color(0xFFDA8B1B);
  static const Color resolvedBackground = Color(0xFFD0FAE4);
  static const Color resolvedText = Color(0xFF2B8147);
  static const Color temperature = Color(0xFFEF1B24);
  static const Color ph = Color(0xFF3978B9);
  static const Color ec = Color(0xFFB27A0A);
  static const Color humidity = Color(0xFF5DA9E9);
  static const Color light = Color(0xFFFFB51B);
  static const Color water = Color(0xFF149BEF);
  static const Color lowSeverity = Color(0xFFACDA8A);
  static const Color moderateSeverity = Color(0xFF9D7409);
  static const Color recommendationBackground = Color(0xFFB7DDBB);

  // Dark-mode surfaces. Status/critical/warning colors above are kept
  // as-is for both themes since they're used on tinted badges, not on
  // the raw background.
  static const Color darkBackground = Color(0xFF10140F);
  static const Color darkSurface = Color(0xFF1B211A);
  static const Color darkText = Color(0xFFE7EFDA);

  static const String fontFamily = 'Manrope';

  static ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    appBarTheme: AppBarThemeData(
      surfaceTintColor: Colors.transparent,
      backgroundColor: cream,
      foregroundColor: black,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: black,
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: primary,
      selectionColor: primary.withValues(alpha: 0.2),
      selectionHandleColor: primary,
    ),

    scaffoldBackgroundColor: cream,

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cream,
      selectedItemColor: black,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      showSelectedLabels: false,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: cream,
      shape: CircleBorder(),
    ),

    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 18,
        fontWeight: .w400,
        color: darkGery,
      ),
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: black,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: .w500,
        color: black,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: .w400,
        color: black,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primary,

    appBarTheme: AppBarThemeData(
      surfaceTintColor: Colors.transparent,
      backgroundColor: darkSurface,
      foregroundColor: darkText,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),
    ),

    textSelectionTheme: TextSelectionThemeData(
      cursorColor: cream,
      selectionColor: cream.withValues(alpha: 0.2),
      selectionHandleColor: cream,
    ),

    scaffoldBackgroundColor: darkBackground,

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: darkSurface,
      selectedItemColor: darkText,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      showSelectedLabels: false,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: cream,
      foregroundColor: primary,
      shape: CircleBorder(),
    ),

    textTheme: TextTheme(
      titleMedium: TextStyle(
        fontFamily: fontFamily,
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: darkText,
      ),
      titleSmall: TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: darkText,
      ),
      labelLarge: TextStyle(
        fontFamily: fontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: darkText,
      ),
    ),
  );
}
