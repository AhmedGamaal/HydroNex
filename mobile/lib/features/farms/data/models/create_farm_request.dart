class CreateFarmRequest {
  final String name;
  final String location;
  final String description;

  const CreateFarmRequest({
    required this.name,
    required this.location,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {'name': name, 'location': location, 'description': description};
  }
}
