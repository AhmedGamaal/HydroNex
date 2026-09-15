class SensorReadingResponse {
  final int id;
  final int sensorId;
  final int cropId;
  final String sensorType;
  final String unit;
  final double value;
  final DateTime recordedAt;

  const SensorReadingResponse({
    required this.id,
    required this.sensorId,
    required this.cropId,
    required this.sensorType,
    required this.unit,
    required this.value,
    required this.recordedAt,
  });

  factory SensorReadingResponse.fromJson(Map<String, dynamic> json) {
    return SensorReadingResponse(
      id: json['id'],
      sensorId: json['sensorId'],
      cropId: json['cropId'],
      sensorType: json['sensorType'],
      unit: json['unit'],
      value: (json['value'] as num).toDouble(),
      recordedAt: DateTime.parse('${json['recordedAt']}Z'),
    );
  }
}
