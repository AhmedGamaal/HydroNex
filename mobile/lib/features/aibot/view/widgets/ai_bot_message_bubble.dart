import 'package:flutter/material.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/features/aibot/data/models/chat_message_model.dart';

class AiBotMessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const AiBotMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = TextTheme.of(context);
    final bool isUser = message.sender == 'user';

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.lightSage : AppTheme.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.message,
          style: textTheme.titleMedium?.copyWith(
            color: isUser ? AppTheme.darkGery : AppTheme.white,
          ),
        ),
      ),
    );
  }
}
