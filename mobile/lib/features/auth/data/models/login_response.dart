class LoginResponse {
  final String token;
  final String userId;
  final String fullName;
  final String email;

  const LoginResponse({
    required this.token,
    required this.userId,
    required this.fullName,
    required this.email,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'],
      userId: json['userId'],
      fullName: json['fullName'],
      email: json['email'],
    );
  }
}
