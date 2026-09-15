import 'package:hydronex_app/core/storage/token_storage.dart';
import '../../domain/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/forgot_password_request.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';
import '../models/reset_password_request.dart';
import '../models/user_response.dart';
import '../models/verify_otp_request.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<LoginResponse> signIn(LoginRequest request) async {
    final response = await remoteDataSource.signIn(request);

    await tokenStorage.saveToken(response.token);

    return response;
  }

  @override
  Future<RegisterResponse> signUp(RegisterRequest request) async {
    final response = await remoteDataSource.signUp(request);

    await tokenStorage.saveToken(response.token);

    return response;
  }

  @override
  Future<UserResponse> getCurrentUser() {
    return remoteDataSource.getCurrentUser();
  }

  @override
  Future<void> sendOtp(ForgotPasswordRequest request) {
    return remoteDataSource.sendOtp(request);
  }

  @override
  Future<void> verifyOtp(VerifyOtpRequest request) {
    return remoteDataSource.verifyOtp(request);
  }

  @override
  Future<void> resetPassword(ResetPasswordRequest request) {
    return remoteDataSource.resetPassword(request);
  }
}
