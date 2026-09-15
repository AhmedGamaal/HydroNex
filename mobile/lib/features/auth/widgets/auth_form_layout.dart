import 'package:flutter/material.dart';

/// Common skeleton shared by every form-based auth screen (Sign In,
/// Sign Up, Set New Password): a scrollable [Form] that fills the
/// available space, plus an optional [footer] pinned below it.
///
/// Screens only provide the [formKey] and their field widgets — the
/// scaffolding around them (padding, scroll behaviour, footer spacing)
/// lives here once instead of being retyped in every screen.
class AuthFormLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final Widget? footer;
  final double topSpacing;
  final EdgeInsets scrollPadding;
  final EdgeInsets footerPadding;

  const AuthFormLayout({
    super.key,
    required this.formKey,
    required this.children,
    this.footer,
    this.topSpacing = 70,
    this.scrollPadding = const EdgeInsets.fromLTRB(16, 24, 16, 16),
    this.footerPadding = const EdgeInsets.symmetric(vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: scrollPadding,
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: topSpacing),
                  ...children,
                ],
              ),
            ),
          ),
        ),
        if (footer != null) Padding(padding: footerPadding, child: footer),
        const SizedBox(height: 32),
      ],
    );
  }
}
