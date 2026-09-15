class DiseaseAnalysisModel {
  final int id;
  final int plantImageId;
  final String diseaseName;
  final double confidenceScore;
  final String analysisResult;
  final DateTime analyzedAt;

  const DiseaseAnalysisModel({
    required this.id,
    required this.plantImageId,
    required this.diseaseName,
    required this.confidenceScore,
    required this.analysisResult,
    required this.analyzedAt,
  });

  factory DiseaseAnalysisModel.fromJson(Map<String, dynamic> json) {
    return DiseaseAnalysisModel(
      id: (json['id'] as num).toInt(),
      plantImageId: (json['plantImageId'] as num).toInt(),
      diseaseName: json['diseaseName']?.toString() ?? '',
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble() ?? 0.0,
      analysisResult: json['analysisResult']?.toString() ?? '',
      analyzedAt: DateTime.parse(json['analyzedAt'].toString()),
    );
  }

  double get confidencePercentage => confidenceScore * 100;
}
