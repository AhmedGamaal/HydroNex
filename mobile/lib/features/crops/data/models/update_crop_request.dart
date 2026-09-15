class UpdateCropRequest {
  final String cropType;
  final String batchId;
  final String location;
  final String notes;
  final String variety;
  final DateTime plantingDate;
  final int cycleDuration;
  final String growthStage;
  final String status;

  const UpdateCropRequest({
    required this.cropType,
    required this.batchId,
    required this.location,
    required this.notes,
    required this.variety,
    required this.plantingDate,
    required this.cycleDuration,
    required this.growthStage,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'cropType': cropType,
      'batchId': batchId,
      'location': location,
      'notes': notes,
      'variety': variety,
      'plantingDate': plantingDate.toIso8601String(),
      'cycleDuration': cycleDuration,
      'growthStage': growthStage,
      'status': status,
    };
  }
}
