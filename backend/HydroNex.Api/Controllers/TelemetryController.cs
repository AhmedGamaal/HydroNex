using System.Security.Claims;
using HydroNex.Application.Features.Telemetry;
using HydroNex.Application.Features.Telemetry.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HydroNex.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/telemetry")]
public class TelemetryController : ControllerBase
{
    private readonly ITelemetryService _telemetryService;

    public TelemetryController(ITelemetryService telemetryService)
    {
        _telemetryService = telemetryService;
    }

    [HttpPost]
    public async Task<IActionResult> AddReading(
        [FromBody] SensorReadingRequest request,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        try
        {
            var result = await _telemetryService.AddReadingAsync(
                userId,
                request,
                cancellationToken);

            return Ok(result);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }

    [HttpPost("bulk")]
    public async Task<IActionResult> AddBulkReadings(
        [FromBody] BulkSensorReadingRequest request,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        try
        {
            var result = await _telemetryService.AddBulkReadingsAsync(
                userId,
                request,
                cancellationToken);

            return Ok(result);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }

    [HttpGet("crop/{cropId:int}/latest")]
    public async Task<IActionResult> GetLatest(
        int cropId,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        try
        {
            var result = await _telemetryService.GetLatestByCropAsync(
                userId,
                cropId,
                cancellationToken);

            return Ok(result);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }

    [HttpGet("crop/{cropId:int}/history")]
    public async Task<IActionResult> GetHistory(
        int cropId,
        [FromQuery] DateTime? from,
        [FromQuery] DateTime? to,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        try
        {
            var result = await _telemetryService.GetHistoryAsync(
                userId,
                cropId,
                from,
                to,
                cancellationToken);

            return Ok(result);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }

    private string GetUserId()
    {
        return User.FindFirstValue(ClaimTypes.NameIdentifier)
            ?? throw new UnauthorizedAccessException(
                "User ID is missing.");
    }
}