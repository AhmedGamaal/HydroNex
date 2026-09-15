using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using HydroNex.Application.Common;
using HydroNex.Application.Features.Auth;
using HydroNex.Application.Features.Auth.DTOs;
using HydroNex.Domain.Entities;
using HydroNex.Infrastructure.Persistence;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace HydroNex.Infrastructure.Services;

public class AuthService : IAuthService
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly ApplicationDbContext _db;
    private readonly IConfiguration _configuration;
    private readonly IEmailService _emailService;

    public AuthService(
        UserManager<ApplicationUser> userManager,
        ApplicationDbContext db,
        IConfiguration configuration,
        IEmailService emailService)
    {
        _userManager = userManager;
        _db = db;
        _configuration = configuration;
        _emailService = emailService;
    }

    public async Task<AuthResponse> RegisterAsync(
        RegisterRequest request)
    {
        if (request.Password != request.ConfirmPassword)
            throw new InvalidOperationException(
                "Passwords do not match.");

        var existingUser =
            await _userManager.FindByEmailAsync(request.Email);

        if (existingUser is not null)
            throw new InvalidOperationException(
                "Email is already registered.");

        var user = new ApplicationUser
        {
            UserName = request.Email,
            Email = request.Email,
            FullName = request.FullName,
            CreatedAt = DateTime.UtcNow
        };

        var result = await _userManager.CreateAsync(
            user,
            request.Password);

        if (!result.Succeeded)
        {
            var errors = string.Join(
                " ",
                result.Errors.Select(x => x.Description));

            throw new InvalidOperationException(errors);
        }

        await CreateOtpAsync(user.Id, user.Email!);

        var token = GenerateJwtToken(user);

        return new AuthResponse(
            token,
            user.Id,
            user.FullName,
            user.Email!);
    }

    public async Task<AuthResponse> LoginAsync(
        LoginRequest request)
    {
        var user =
            await _userManager.FindByEmailAsync(request.Email);

        if (user is null)
            throw new InvalidOperationException(
                "Invalid email or password.");

        var validPassword =
            await _userManager.CheckPasswordAsync(
                user,
                request.Password);

        if (!validPassword)
            throw new InvalidOperationException(
                "Invalid email or password.");

        var token = GenerateJwtToken(user);

        return new AuthResponse(
            token,
            user.Id,
            user.FullName,
            user.Email!);
    }

    public async Task<UserResponse?> GetCurrentUserAsync(
        string userId)
    {
        var user =
            await _userManager.FindByIdAsync(userId);

        if (user is null)
            return null;

        return new UserResponse(
            user.Id,
            user.FullName,
            user.Email!);
    }

    public async Task<MessageResponse> VerifyOtpAsync(
        VerifyOtpRequest request)
    {
        var user =
            await _userManager.FindByEmailAsync(request.Email);

        if (user is null)
            throw new InvalidOperationException(
                "Invalid OTP.");

        var otp = await _db.OtpVerifications
            .Where(x =>
                x.UserId == user.Id &&
                x.Code == request.Code &&
                !x.IsUsed)
            .OrderByDescending(x => x.CreatedAt)
            .FirstOrDefaultAsync();

        if (otp is null || otp.ExpiresAt < DateTime.UtcNow)
            throw new InvalidOperationException(
                "Invalid or expired OTP.");

        otp.IsUsed = true;

        await _db.SaveChangesAsync();

        return new MessageResponse(
            "OTP verified successfully.");
    }

    public async Task<MessageResponse> ForgotPasswordAsync(
        ForgotPasswordRequest request)
    {
        var user =
            await _userManager.FindByEmailAsync(request.Email);

        if (user is not null)
        {
            await CreateOtpAsync(user.Id, user.Email!);
        }

        return new MessageResponse(
            "If the email exists, an OTP has been sent.");
    }

    public async Task<MessageResponse> ResetPasswordAsync(
        ResetPasswordRequest request)
    {
        if (request.NewPassword != request.ConfirmPassword)
            throw new InvalidOperationException(
                "Passwords do not match.");

        var user =
            await _userManager.FindByEmailAsync(request.Email);

        if (user is null)
            throw new InvalidOperationException(
                "Invalid OTP.");

        var otp = await _db.OtpVerifications
            .Where(x =>
                x.UserId == user.Id &&
                x.Code == request.Code &&
                !x.IsUsed)
            .OrderByDescending(x => x.CreatedAt)
            .FirstOrDefaultAsync();

        if (otp is null || otp.ExpiresAt < DateTime.UtcNow)
            throw new InvalidOperationException(
                "Invalid or expired OTP.");

        var resetToken =
            await _userManager.GeneratePasswordResetTokenAsync(
                user);

        var result =
            await _userManager.ResetPasswordAsync(
                user,
                resetToken,
                request.NewPassword);

        if (!result.Succeeded)
        {
            var errors = string.Join(
                " ",
                result.Errors.Select(x => x.Description));

            throw new InvalidOperationException(errors);
        }

        otp.IsUsed = true;

        await _db.SaveChangesAsync();

        return new MessageResponse(
            "Password reset successfully.");
    }

    private async Task CreateOtpAsync(
        string userId,
        string emailAddress)
    {
        var oldOtps = await _db.OtpVerifications
            .Where(x =>
                x.UserId == userId &&
                !x.IsUsed)
            .ToListAsync();

        foreach (var oldOtp in oldOtps)
            oldOtp.IsUsed = true;

        var random = Random.Shared.Next(100000, 1000000);

        var otp = new OtpVerification
        {
            UserId = userId,
            Code = random.ToString(),
            ExpiresAt = DateTime.UtcNow.AddMinutes(5),
            IsUsed = false,
            CreatedAt = DateTime.UtcNow
        };

        await _db.OtpVerifications.AddAsync(otp);
        await _db.SaveChangesAsync();

        var emailBody = $"""
            <div style="font-family: Arial, sans-serif;">
                <h2>HydroNex OTP Verification</h2>
                <p>Your verification code is:</p>
                <h1 style="letter-spacing: 6px;">
                    {otp.Code}
                </h1>
                <p>This code expires in 5 minutes.</p>
                <p>If you did not request this code, ignore this email.</p>
            </div>
            """;

        await _emailService.SendAsync(
            emailAddress,
            "HydroNex OTP Verification Code",
            emailBody);
    }

    private string GenerateJwtToken(
        ApplicationUser user)
    {
        var key = _configuration["Jwt:Key"]
            ?? throw new InvalidOperationException(
                "JWT Key is not configured.");

        var issuer = _configuration["Jwt:Issuer"];
        var audience = _configuration["Jwt:Audience"];

        var expirationMinutes =
            _configuration.GetValue<int>(
                "Jwt:ExpirationMinutes");

        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, user.Id),
            new(JwtRegisteredClaimNames.Email, user.Email!),
            new(ClaimTypes.NameIdentifier, user.Id),
            new(ClaimTypes.Email, user.Email!),
            new(ClaimTypes.Name, user.FullName)
        };

        var credentials = new SigningCredentials(
            new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(key)),
            SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer,
            audience,
            claims,
            expires: DateTime.UtcNow.AddMinutes(
                expirationMinutes),
            signingCredentials: credentials);

        return new JwtSecurityTokenHandler()
            .WriteToken(token);
    }

    public async Task<string?> GetLatestOtpForDevAsync(
        string email)
    {
        var user =
            await _userManager.FindByEmailAsync(email);

        if (user is null)
            return null;

        var otp = await _db.OtpVerifications
            .Where(x =>
                x.UserId == user.Id &&
                !x.IsUsed &&
                x.ExpiresAt > DateTime.UtcNow)
            .OrderByDescending(x => x.CreatedAt)
            .FirstOrDefaultAsync();

        return otp?.Code;
    }
}