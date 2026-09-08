using System.Security.Claims;
using HydroNex.Application.Features.Sensors;
using HydroNex.Application.Features.Sensors.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HydroNex.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/sensors")]
public class SensorsController : ControllerBase
{
    private readonly ISensorService _sensorService;

    public SensorsController(ISensorService sensorService)
    {
        _sensorService = sensorService;
    }

    [HttpPost]
    public async Task<IActionResult> Create(
        [FromBody] CreateSensorRequest request,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        try
        {
            var result = await _sensorService.CreateAsync(
                userId,
                request,
                cancellationToken);

            return CreatedAtAction(
                nameof(GetById),
                new { id = result.Id },
                result);
        }
        catch (KeyNotFoundException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }

    [HttpGet("crop/{cropId:int}")]
    public async Task<IActionResult> GetByCrop(
        int cropId,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        try
        {
            var result = await _sensorService.GetByCropAsync(
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

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(
        int id,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        var result = await _sensorService.GetByIdAsync(
            userId,
            id,
            cancellationToken);

        if (result is null)
            return NotFound(new { message = "Sensor not found." });

        return Ok(result);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(
        int id,
        [FromBody] UpdateSensorRequest request,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        var result = await _sensorService.UpdateAsync(
            userId,
            id,
            request,
            cancellationToken);

        if (result is null)
            return NotFound(new { message = "Sensor not found." });

        return Ok(result);
    }

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(
        int id,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        var deleted = await _sensorService.DeleteAsync(
            userId,
            id,
            cancellationToken);

        if (!deleted)
            return NotFound(new { message = "Sensor not found." });

        return NoContent();
    }

    private string GetUserId()
    {
        return User.FindFirstValue(ClaimTypes.NameIdentifier)
            ?? throw new UnauthorizedAccessException("User ID is missing.");
    }
}