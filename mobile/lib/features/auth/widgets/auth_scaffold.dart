import 'package:flutter/material.dart';
import 'package:hydronex_app/core/constants/app_colors.dart';

/// Common chrome for every screen in the auth flow: the cream
/// background, the [SafeArea], and (optionally) the plain back-button
/// app bar used by OTP / Set-New-Password.
///
/// Screens should never build their own `Scaffold` — wrapping [body]
/// here keeps that boilerplate (and any future tweak to it, like a
/// different background) in exactly one place.
class AuthScaffold extends StatelessWidget {
  final Widget body;
  final bool showBackButton;
  final VoidCallback? onBack;

  const AuthScaffold({
    super.key,
    required this.body,
    this.showBackButton = false,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: showBackButton
          ? AppBar(
              backgroundColor: AppColors.cream,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: onBack ?? () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: SafeArea(child: body),
    );
  }
}
