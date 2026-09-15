import 'package:flutter/material.dart';
import 'package:hydronex_app/features/profile/view/widgets/crop_step_item.dart';

class HowToAddCropSection extends StatelessWidget {
  const HowToAddCropSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> steps = [
      'Click "Add Crop" in the dashboard',
      'Choose crop type - Lettuce, Tomato, Basil, or Strawberry',
      'Enter a unique Batch ID and optional location/notes',
      'Click "Register Crop" - the system auto-sets cycle duration and sensors',
      'After registration, go to the crop’s Info tab → Run Agent Cycle',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How to add a crop', style: TextTheme.of(context).titleMedium),
        SizedBox(height: 16),
        ...steps.map(
          (step) => Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: CropStepItem(text: step),
          ),
        ),
      ],
    );
  }
}
