class LatestSensorReadingResponse {
  final int sensorId;
  final String sensorType;
  final String unit;
  final double value;
  final DateTime recordedAt;

  const LatestSensorReadingResponse({
    required this.sensorId,
    required this.sensorType,
    required this.unit,
    required this.value,
    required this.recordedAt,
  });

  factory LatestSensorReadingResponse.fromJson(Map<String, dynamic> json) {
    return LatestSensorReadingResponse(
      sensorId: json['sensorId'],
      sensorType: json['sensorType'],
      unit: json['unit'],
      value: (json['value'] as num).toDouble(),
      recordedAt: DateTime.parse('${json['recordedAt']}Z'),
    );
  }
}
