class FarmResponse {
  final int id;
  final String name;
  final String location;
  final String description;
  final int cropCount;
  final DateTime createdAt;

  const FarmResponse({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.cropCount,
    required this.createdAt,
  });

  factory FarmResponse.fromJson(Map<String, dynamic> json) {
    return FarmResponse(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      cropCount: json['cropCount'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
