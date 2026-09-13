using HydroNex.Application.Features.Auth.DTOs;

namespace HydroNex.Application.Features.Auth;

public interface IAuthService
{
    Task<AuthResponse> RegisterAsync(RegisterRequest request);

    Task<AuthResponse> LoginAsync(LoginRequest request);

    Task<UserResponse?> GetCurrentUserAsync(string userId);

    Task<MessageResponse> VerifyOtpAsync(
        VerifyOtpRequest request);

    Task<MessageResponse> ForgotPasswordAsync(
        ForgotPasswordRequest request);

    Task<MessageResponse> ResetPasswordAsync(
        ResetPasswordRequest request);

    // Development convenience only - see AuthController.GetOtpForDev for the
    // environment gate. Lets testers retrieve the OTP without digging through
    // console logs. Remove once a real email/SMS provider is wired in.
    Task<string?> GetLatestOtpForDevAsync(string email);
}