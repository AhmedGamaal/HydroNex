import 'package:hydronex_app/features/plant_vision/data/models/detected_issue_model.dart';
import 'package:hydronex_app/features/plant_vision/data/models/disease_analysis_model.dart';
import 'package:hydronex_app/features/plant_vision/data/models/recommendation_model.dart';

class PlantAnalysisModel {
  final int cropId;
  final DiseaseAnalysisModel diseaseAnalysis;
  final RecommendationModel? recommendationData;

  final String plantType;
  final String growthStage;
  final String age;
  final String system;

  const PlantAnalysisModel({
    required this.cropId,
    required this.diseaseAnalysis,
    required this.recommendationData,
    required this.plantType,
    required this.growthStage,
    required this.age,
    required this.system,
  });

  String get plantName => diseaseAnalysis.diseaseName;

  String get healthStatus {
    final name = diseaseAnalysis.diseaseName.toLowerCase();

    if (name.contains('healthy')) {
      return 'Healthy';
    }

    return 'Needs Attention';
  }

  String get healthPercentage {
    return '${diseaseAnalysis.confidencePercentage.toStringAsFixed(0)}%';
  }

  String get confidence {
    return '${diseaseAnalysis.confidencePercentage.toStringAsFixed(0)}%';
  }

  List<DetectedIssueModel> get issues {
    final diseaseName = diseaseAnalysis.diseaseName.trim();

    if (diseaseName.isEmpty || diseaseName.toLowerCase().contains('healthy')) {
      return const [];
    }

    return [
      DetectedIssueModel(
        name: diseaseName,
        description: diseaseAnalysis.analysisResult,
        severity: 'Moderate',
      ),
    ];
  }

  String get recommendation {
    if (recommendationData == null) {
      return 'No recommendation available.';
    }

    return recommendationData!.displayText;
  }
}
