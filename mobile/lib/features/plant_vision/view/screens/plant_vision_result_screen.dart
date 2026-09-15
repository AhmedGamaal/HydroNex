import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hydronex_app/core/theme/app_theme.dart';
import 'package:hydronex_app/core/widgets/custom_button.dart';
import 'package:hydronex_app/features/plant_vision/data/models/plant_analysis_model.dart';
import 'package:hydronex_app/features/plant_vision/view/screens/camera_screen.dart';
import 'package:hydronex_app/features/plant_vision/view/widgets/ai_recommendation_card.dart';
import 'package:hydronex_app/features/plant_vision/view/widgets/detected_issue_card.dart';
import 'package:hydronex_app/features/plant_vision/view/widgets/plant_health_card.dart';
import 'package:hydronex_app/features/plant_vision/view/widgets/plant_information_card.dart';

class PlantVisionResultScreen extends StatelessWidget {
  final PlantAnalysisModel analysis;
  final String imagePath;

  const PlantVisionResultScreen({
    super.key,
    required this.analysis,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = TextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.cream,
        title: Text('AI Plant Vision'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Scan plant · Detect issues · Get solutions',
                style: textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(imagePath),
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.22,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CameraScreen(cropId: analysis.cropId),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.cream,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          SvgPicture.asset('assets/icons/retake.svg'),
                          Text('Retake', style: textTheme.labelLarge),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            PlantHealthCard(
              healthStatus: analysis.healthStatus,
              healthPercentage: analysis.healthPercentage,
              confidence: analysis.confidence,
            ),
            const SizedBox(height: 16),
            Text('Detected Issues', style: textTheme.titleMedium),
            const SizedBox(height: 10),
            ...analysis.issues.map(
              (issue) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DetectedIssueCard(issue: issue),
              ),
            ),
            const SizedBox(height: 8),
            Text('Plant Information', style: textTheme.titleMedium),
            const SizedBox(height: 10),
            PlantInformationCard(
              plantType: analysis.plantType,
              growthStage: analysis.growthStage,
              age: analysis.age,
              system: analysis.system,
            ),
            const SizedBox(height: 16),
            Text('AI Recommendation', style: textTheme.titleMedium),
            SizedBox(height: 20),
            AiRecommendationCard(recommendation: analysis.recommendation),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Scan another plant',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraScreen(cropId: analysis.cropId),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
