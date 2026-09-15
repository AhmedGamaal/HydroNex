class PlantImageModel {
  final int id;
  final int cropId;
  final String imageUrl;
  final DateTime capturedAt;
  final DateTime createdAt;

  const PlantImageModel({
    required this.id,
    required this.cropId,
    required this.imageUrl,
    required this.capturedAt,
    required this.createdAt,
  });

  factory PlantImageModel.fromJson(Map<String, dynamic> json) {
    return PlantImageModel(
      id: (json['id'] as num).toInt(),
      cropId: (json['cropId'] as num).toInt(),
      imageUrl: json['imageUrl']?.toString() ?? '',
      capturedAt: DateTime.parse(json['capturedAt'].toString()),
      createdAt: DateTime.parse(json['createdAt'].toString()),
    );
  }
}
