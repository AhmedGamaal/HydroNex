class RegisterResponse {
  final String token;
  final String userId;
  final String fullName;
  final String email;

  const RegisterResponse({
    required this.token,
    required this.userId,
    required this.fullName,
    required this.email,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      token: json['token'],
      userId: json['userId'],
      fullName: json['fullName'],
      email: json['email'],
    );
  }
}
