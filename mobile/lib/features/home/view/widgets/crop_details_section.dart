import 'package:flutter/material.dart';
import 'package:hydronex_app/features/home/view/widgets/custom_text_field.dart';

class CropDetailsSection extends StatelessWidget {
  TextEditingController batchIdController;
  TextEditingController locationController;
  TextEditingController noteController;

  String? batchIdError;
  String? locationError;

  CropDetailsSection({
    required this.batchIdController,
    required this.locationController,
    required this.noteController,
    this.batchIdError,
    this.locationError,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text('Crop Details', style: textTheme.titleMedium),
        SizedBox(height: 8),
        CustomTextField(
          hintText: 'Batch ID',
          controller: batchIdController,
          errorText: batchIdError,
        ),
        SizedBox(height: 16),
        CustomTextField(
          hintText: 'Location',
          controller: locationController,
          errorText: locationError,
        ),
        SizedBox(height: 16),
        CustomTextField(hintText: 'Note', controller: noteController),
      ],
    );
  }
}
