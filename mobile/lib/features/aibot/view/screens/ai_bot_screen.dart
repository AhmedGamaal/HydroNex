import 'package:flutter/material.dart';
import 'package:hydronex_app/features/aibot/view/tab/ai_bot_tab.dart';

class AiBotScreen extends StatelessWidget {
  static const String routeName = '/AiBotScreen';

  const AiBotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ask AI')),
      body: AiBotTab(),
    );
  }
}
