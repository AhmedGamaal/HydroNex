class RecommendationModel {
  final int id;
  final int cropId;
  final int? diseaseAnalysisId;
  final String title;
  final String description;
  final String riskLevel;
  final String actionType;
  final String status;
  final DateTime createdAt;

  const RecommendationModel({
    required this.id,
    required this.cropId,
    required this.diseaseAnalysisId,
    required this.title,
    required this.description,
    required this.riskLevel,
    required this.actionType,
    required this.status,
    required this.createdAt,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    return RecommendationModel(
      id: (json['id'] as num).toInt(),
      cropId: (json['cropId'] as num).toInt(),
      diseaseAnalysisId: json['diseaseAnalysisId'] == null
          ? null
          : (json['diseaseAnalysisId'] as num).toInt(),
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      riskLevel: json['riskLevel']?.toString() ?? '',
      actionType: json['actionType']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }

  String get displayText {
    if (title.trim().isEmpty) {
      return description;
    }

    if (description.trim().isEmpty) {
      return title;
    }

    return '$title\n\n$description';
  }
}
