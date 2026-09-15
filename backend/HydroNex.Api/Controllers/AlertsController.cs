using System.Security.Claims;
using HydroNex.Application.Features.Alerts;
using HydroNex.Application.Features.Alerts.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HydroNex.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/alerts")]
public class AlertsController : ControllerBase
{
    private readonly IAlertService _alertService;

    public AlertsController(IAlertService alertService)
    {
        _alertService = alertService;
    }

    [HttpGet("crop/{cropId:int}")]
    public async Task<ActionResult<List<AlertResponse>>> GetByCrop(
        int cropId,
        CancellationToken cancellationToken)
    {
        var userId = User.FindFirstValue(ClaimTypes.NameIdentifier);

        if (userId is null)
            return Unauthorized();

        var alerts = await _alertService.GetByCropAsync(userId, cropId, cancellationToken);
        return Ok(alerts);
    }
}
