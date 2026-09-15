import 'package:flutter/material.dart';
import 'package:hydronex_app/core/routes/app_routes.dart';
import 'package:hydronex_app/core/routes/route_context_extention.dart';
import 'package:hydronex_app/features/aibot/view/screens/ai_bot_screen.dart';
import 'package:hydronex_app/features/profile/view/widgets/ask_ai_card.dart';
import 'package:hydronex_app/features/profile/view/widgets/growth_stage_section.dart';
import 'package:hydronex_app/features/profile/view/widgets/how_to_add_crop_section.dart';
import 'package:hydronex_app/features/profile/view/widgets/sensor_term_section.dart';

class HelpSupportScreen extends StatelessWidget {
  static const String routeName = '/HelpSupportScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SensorTermSection(),
              const SizedBox(height: 24),
              GrowthStageSection(),
              const SizedBox(height: 24),
              HowToAddCropSection(),
              const SizedBox(height: 24),
              AskAiCard(
                onPressed: () {
                  context.pushNamed(AppRoutes.aiBot);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
