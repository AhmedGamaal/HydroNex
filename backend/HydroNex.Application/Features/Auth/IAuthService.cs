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
}