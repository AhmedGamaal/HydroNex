import 'package:dio/dio.dart';
import '../models/forgot_password_request.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';
import '../models/reset_password_request.dart';
import '../models/user_response.dart';
import '../models/verify_otp_request.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource({required this.dio});

  Future<LoginResponse> signIn(LoginRequest request) async {
    final response = await dio.post('/api/Auth/login', data: request.toJson());

    return LoginResponse.fromJson(response.data);
  }

  Future<RegisterResponse> signUp(RegisterRequest request) async {
    final response = await dio.post(
      '/api/Auth/register',
      data: request.toJson(),
    );

    return RegisterResponse.fromJson(response.data);
  }

  Future<void> sendOtp(ForgotPasswordRequest request) async {
    await dio.post('/api/Auth/forgot-password', data: request.toJson());
  }

  Future<void> verifyOtp(VerifyOtpRequest request) async {
    await dio.post('/api/Auth/verify-otp', data: request.toJson());
  }

  Future<void> resetPassword(ResetPasswordRequest request) async {
    await dio.post('/api/Auth/reset-password', data: request.toJson());
  }

  Future<UserResponse> getCurrentUser() async {
    final response = await dio.get('/api/Auth/me');

    return UserResponse.fromJson(response.data);
  }
}
