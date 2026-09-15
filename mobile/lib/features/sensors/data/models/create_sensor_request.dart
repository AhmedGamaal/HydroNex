class CreateSensorRequest {
  final int cropId;
  final String type;
  final String unit;
  final String name;
  final String? location;

  const CreateSensorRequest({
    required this.cropId,
    required this.type,
    required this.unit,
    required this.name,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'cropId': cropId,
      'type': type,
      'unit': unit,
      'name': name,
      'location': location,
    };
  }
}
