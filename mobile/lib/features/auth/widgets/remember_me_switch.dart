import 'package:flutter/material.dart';
import 'package:hydronex_app/core/constants/app_colors.dart';

/// "Remember me" switch + label, as used on the Sign In screen.
/// Purely presentational — the checked value and the change callback
/// come from the caller (the cubit owns the actual boolean state).
class RememberMeSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const RememberMeSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Remember me',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Transform.scale(
          scale: 0.75,
          child: Switch(
            value: value,
            activeColor: AppColors.primaryDark,
            onChanged: onChanged,
          ),
        ),
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF404040))),
      ],
    );
  }
}
