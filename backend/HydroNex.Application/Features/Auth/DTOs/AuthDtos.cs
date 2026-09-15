namespace HydroNex.Application.Features.Auth.DTOs;

public record RegisterRequest(
    string FullName,
    string Email,
    string Password,
    string ConfirmPassword
);

public record LoginRequest(
    string Email,
    string Password
);

public record VerifyOtpRequest(
    string Email,
    string Code
);

public record ForgotPasswordRequest(
    string Email
);

public record ResetPasswordRequest(
    string Email,
    string Code,
    string NewPassword,
    string ConfirmPassword
);

public record AuthResponse(
    string Token,
    string UserId,
    string FullName,
    string Email
);

public record UserResponse(
    string UserId,
    string FullName,
    string Email
);

public record MessageResponse(
    string Message
);