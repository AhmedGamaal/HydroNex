using System.Security.Claims;
using HydroNex.Application.Features.Auth;
using HydroNex.Application.Features.Auth.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HydroNex.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthService _authService;
    private readonly IWebHostEnvironment _env;

    public AuthController(IAuthService authService, IWebHostEnvironment env)
    {
        _authService = authService;
        _env = env;
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register(
        RegisterRequest request)
    {
        try
        {
            var response =
                await _authService.RegisterAsync(request);

            return Ok(response);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new
            {
                message = ex.Message
            });
        }
    }

    [HttpPost("login")]
    public async Task<IActionResult> Login(
        LoginRequest request)
    {
        try
        {
            var response =
                await _authService.LoginAsync(request);

            return Ok(response);
        }
        catch (InvalidOperationException ex)
        {
            return Unauthorized(new
            {
                message = ex.Message
            });
        }
    }

    [HttpPost("verify-otp")]
    public async Task<IActionResult> VerifyOtp(
        VerifyOtpRequest request)
    {
        try
        {
            var response =
                await _authService.VerifyOtpAsync(request);

            return Ok(response);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new
            {
                message = ex.Message
            });
        }
    }

    [HttpPost("forgot-password")]
    public async Task<IActionResult> ForgotPassword(
        ForgotPasswordRequest request)
    {
        try
        {
            var response =
                await _authService.ForgotPasswordAsync(request);

            return Ok(response);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new
            {
                message = ex.Message
            });
        }
    }

    [HttpPost("reset-password")]
    public async Task<IActionResult> ResetPassword(
        ResetPasswordRequest request)
    {
        try
        {
            var response =
                await _authService.ResetPasswordAsync(request);

            return Ok(response);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new
            {
                message = ex.Message
            });
        }
    }

    [Authorize]
    [HttpGet("me")]
    public async Task<IActionResult> Me()
    {
        var userId =
            User.FindFirstValue(
                ClaimTypes.NameIdentifier);

        if (userId is null)
            return Unauthorized();

        var user =
            await _authService.GetCurrentUserAsync(userId);

        if (user is null)
            return NotFound();

        return Ok(user);
    }

    // DEV ONLY - only responds when the API is running in the Development
    // environment. Returns the current unused OTP for an email so testers
    // don't have to dig through console logs. Remove once real email/SMS
    // delivery is wired in for OTPs.
    [HttpGet("dev-otp/{email}")]
    public async Task<IActionResult> GetOtpForDev(string email)
    {
        if (!_env.IsDevelopment())
            return NotFound();

        var code = await _authService.GetLatestOtpForDevAsync(email);

        if (code is null)
            return NotFound(new { message = "No active OTP found for this email." });

        return Ok(new { email, code });
    }
}