class CreateCropRequest {
  final int farmId;
  final String cropType;
  final String batchId;
  final String location;
  final String notes;
  final String variety;
  final String plantingDate;
  final int cycleDuration;

  const CreateCropRequest({
    required this.farmId,
    required this.cropType,
    required this.batchId,
    required this.location,
    required this.notes,
    required this.variety,
    required this.plantingDate,
    required this.cycleDuration,
  });

  Map<String, dynamic> toJson() {
    return {
      'farmId': farmId,
      'cropType': cropType,
      'batchId': batchId,
      'location': location,
      'notes': notes,
      'variety': variety,
      'plantingDate': plantingDate,
      'cycleDuration': cycleDuration,
    };
  }
}
