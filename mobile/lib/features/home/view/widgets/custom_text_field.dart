import 'package:flutter/material.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';

class CustomTextField extends StatelessWidget {
  String hintText;
  TextEditingController? controller;
  String? errorText;

  CustomTextField({required this.hintText, this.controller, this.errorText});
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        errorText: errorText,
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppTheme.red, width: 2),
        ),
      ),
    );
  }
}
