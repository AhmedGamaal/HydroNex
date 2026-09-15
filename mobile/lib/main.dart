import 'package:flutter/material.dart';
import 'package:hydronex_app/core/routes/app_router.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

void main() {
  runApp(const HydronexApp());
}

class HydronexApp extends StatelessWidget {
  const HydronexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}
