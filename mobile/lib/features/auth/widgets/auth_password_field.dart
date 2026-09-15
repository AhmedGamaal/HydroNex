import 'package:flutter/material.dart';
import 'package:hydronex_app/core/constants/app_colors.dart';
import 'auth_text_field.dart';

/// Password input with the eye/eye-off toggle from the design.
/// Manages its own obscure-text state internally so screens don't
/// have to re-implement the toggle logic each time.
class AuthPasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final TextInputAction textInputAction;
  final void Function(String)? onFieldSubmitted;

  const AuthPasswordField({
    super.key,
    this.controller,
    this.hintText = 'Password',
    this.validator,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  @override
  State<AuthPasswordField> createState() => _AuthPasswordFieldState();
}

class _AuthPasswordFieldState extends State<AuthPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      controller: widget.controller,
      hintText: widget.hintText,
      obscureText: _obscure,
      validator: widget.validator,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      suffixIcon: IconButton(
        splashRadius: 20,
        icon: Icon(
          _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.black(0.6),
          size: 22,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}
