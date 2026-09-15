import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hydronex_app/core/constants/app_colors.dart';
import 'package:hydronex_app/core/constants/app_text_styles.dart';

/// Row of single-digit boxes for OTP entry. Auto-advances focus on
/// input, moves back on backspace, and reports the joined code via
/// [onChanged] / [onCompleted].
class OtpBoxInput extends StatefulWidget {
  final int length;
  final void Function(String code)? onChanged;
  final void Function(String code)? onCompleted;

  const OtpBoxInput({
    super.key,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
  });

  @override
  State<OtpBoxInput> createState() => OtpBoxInputState();
}

class OtpBoxInputState extends State<OtpBoxInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _focusNodes;
  late final List<FocusNode> _rawKeyFocusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    _rawKeyFocusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    for (final f in _rawKeyFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  /// Clears every box. Handy after a failed verification attempt.
  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes.first.requestFocus();
    _emitChange();
  }

  String get code => _controllers.map((c) => c.text).join();

  void _emitChange() {
    widget.onChanged?.call(code);
    if (code.length == widget.length) {
      widget.onCompleted?.call(code);
    }
  }

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    _emitChange();
  }

  void _onKey(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      _emitChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 46,
          height: 50,
          child: RawKeyboardListener(
            focusNode: _rawKeyFocusNodes[index],
            onKey: (event) => _onKey(index, event),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              style: AppTextStyles.otpDigit,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
                ),
              ),
              onChanged: (value) => _onDigitChanged(index, value),
            ),
          ),
        );
      }),
    );
  }
}
