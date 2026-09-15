class VerifyOtpRequest {
  final String email;
  final String code;

  const VerifyOtpRequest({required this.email, required this.code});

  Map<String, dynamic> toJson() {
    return {'email': email, 'code': code};
  }
}
