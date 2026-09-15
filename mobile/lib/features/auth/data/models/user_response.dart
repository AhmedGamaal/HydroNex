class UserResponse {
  final String userId;
  final String fullName;
  final String email;

  const UserResponse({
    required this.userId,
    required this.fullName,
    required this.email,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      userId: json['userId'],
      fullName: json['fullName'],
      email: json['email'],
    );
  }
}
