import '../data/models/forgot_password_request.dart';
import '../data/models/login_request.dart';
import '../data/models/login_response.dart';
import '../data/models/register_request.dart';
import '../data/models/register_response.dart';
import '../data/models/reset_password_request.dart';
import '../data/models/user_response.dart';
import '../data/models/verify_otp_request.dart';

abstract class AuthRepository {
  Future<LoginResponse> signIn(LoginRequest request);

  Future<RegisterResponse> signUp(RegisterRequest request);

  Future<UserResponse> getCurrentUser();

  Future<void> sendOtp(ForgotPasswordRequest request);

  Future<void> verifyOtp(VerifyOtpRequest request);

  Future<void> resetPassword(ResetPasswordRequest request);
}
