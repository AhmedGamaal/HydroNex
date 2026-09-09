using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
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

    public AuthService(
        UserManager<ApplicationUser> userManager,
        ApplicationDbContext db,
        IConfiguration configuration)
    {
        _userManager = userManager;
        _db = db;
        _configuration = configuration;
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

        await CreateOtpAsync(user.Id);

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

        // Don't reveal whether the email exists.
        if (user is null)
        {
            return new MessageResponse(
                "If the email exists, an OTP has been sent.");
        }

        await CreateOtpAsync(user.Id);

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

    private async Task CreateOtpAsync(string userId)
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

        // Temporary for development.
        // Replace with Email/SMS provider later.
        Console.WriteLine(
            $"[HydroNex OTP] User: {userId}, Code: {otp.Code}");
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
}