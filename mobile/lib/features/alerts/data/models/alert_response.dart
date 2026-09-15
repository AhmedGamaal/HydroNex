class AlertResponse {
  final int id;
  final int cropId;
  final int? recommendationId;
  final String type;
  final String message;
  final String severity;
  final String status;
  final DateTime? resolvedAt;
  final DateTime createdAt;

  const AlertResponse({
    required this.id,
    required this.cropId,
    required this.recommendationId,
    required this.type,
    required this.message,
    required this.severity,
    required this.status,
    required this.resolvedAt,
    required this.createdAt,
  });

  factory AlertResponse.fromJson(Map<String, dynamic> json) {
    return AlertResponse(
      id: json['id'],
      cropId: json['cropId'],
      recommendationId: json['recommendationId'],
      type: json['type'],
      message: json['message'],
      severity: json['severity'],
      status: json['status'],
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'])
          : null,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
