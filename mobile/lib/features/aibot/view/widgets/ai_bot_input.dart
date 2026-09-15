import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:hydronex_app/core/theme/app_theme.dart';

class AiBotInput extends StatefulWidget {
  TextEditingController controller;
  VoidCallback onSend;
  bool isLoading;

  AiBotInput({
    required this.controller,
    required this.onSend,
    required this.isLoading,
  });

  @override
  State<AiBotInput> createState() => _AiBotInputState();
}

class _AiBotInputState extends State<AiBotInput> {
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);

    bool isFocused = focusNode.hasFocus;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isFocused ? AppTheme.white : Colors.transparent,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: isFocused ? AppTheme.lightgery : AppTheme.primary,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: focusNode,
              enabled: !widget.isLoading,
              onTapOutside: (_) => focusNode.unfocus(),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) {
                focusNode.unfocus();
                widget.onSend();
              },
              decoration: InputDecoration(
                hintText: widget.isLoading
                    ? 'Waiting for HydroNex AI...'
                    : 'Send a message...',
                hintStyle: textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w400,
                  color: isFocused
                      ? AppTheme.lightgery
                      : AppTheme.primary.withValues(alpha: 0.60),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 15),
              ),
            ),
          ),
          IconButton(
            onPressed: widget.isLoading
                ? null
                : () {
                    focusNode.unfocus();
                    widget.onSend();
                  },
            icon: SvgPicture.asset(
              'assets/icons/send.svg',
              width: 30,
              height: 30,
              colorFilter: ColorFilter.mode(
                isFocused
                    ? AppTheme.lightgery
                    : AppTheme.primary.withValues(alpha: 0.60),
                .srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
