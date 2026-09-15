class SensorResponse {
  final int id;
  final int cropId;
  final String type;
  final String unit;
  final String name;
  final String? location;
  final String status;
  final DateTime? lastSeenAt;
  final DateTime createdAt;

  const SensorResponse({
    required this.id,
    required this.cropId,
    required this.type,
    required this.unit,
    required this.name,
    required this.location,
    required this.status,
    required this.lastSeenAt,
    required this.createdAt,
  });

  factory SensorResponse.fromJson(Map<String, dynamic> json) {
    return SensorResponse(
      id: json['id'],
      cropId: json['cropId'],
      type: json['type'],
      unit: json['unit'],
      name: json['name'],
      location: json['location'],
      status: json['status'],
      lastSeenAt: json['lastSeenAt'] != null
          ? DateTime.parse(json['lastSeenAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
