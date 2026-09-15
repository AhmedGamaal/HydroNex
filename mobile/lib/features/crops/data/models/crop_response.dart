class CropResponse {
  final int id;
  final String name;
  final String cropType;
  final String batchId;
  final String location;
  final String notes;
  final String variety;
  final String plantingDate;
  final int cycleDuration;
  final String expectedHarvestDate;
  final String growthStage;
  final String status;
  final int currentDay;
  final double progressPercentage;

  const CropResponse({
    required this.id,
    required this.name,
    required this.cropType,
    required this.batchId,
    required this.location,
    required this.notes,
    required this.variety,
    required this.plantingDate,
    required this.cycleDuration,
    required this.expectedHarvestDate,
    required this.growthStage,
    required this.status,
    required this.currentDay,
    required this.progressPercentage,
  });

  factory CropResponse.fromJson(Map<String, dynamic> json) {
    return CropResponse(
      id: json['id'],
      name: (json['name'] ?? '').toString(),
      cropType: (json['cropType'] ?? '').toString(),
      batchId: (json['batchId'] ?? '').toString(),
      location: (json['location'] ?? '').toString(),
      notes: (json['notes'] ?? '').toString(),
      variety: (json['variety'] ?? '').toString(),
      plantingDate: (json['plantingDate'] ?? '').toString(),
      cycleDuration: json['cycleDuration'] ?? 0,
      expectedHarvestDate: (json['expectedHarvestDate'] ?? '').toString(),
      growthStage: (json['growthStage'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      currentDay: json['currentDay'] ?? 0,
      progressPercentage:
          (json['progressPercentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
