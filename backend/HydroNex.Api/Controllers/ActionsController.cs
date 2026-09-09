using System.Security.Claims;
using HydroNex.Application.Features.Actions;
using HydroNex.Application.Features.Actions.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HydroNex.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/actions")]
public class ActionsController : ControllerBase
{
    private readonly IActionService _actionService;

    public ActionsController(IActionService actionService)
    {
        _actionService = actionService;
    }

    [HttpPost]
    public async Task<ActionResult<ActionResponse>> Create(
        CreateActionRequest request,
        CancellationToken cancellationToken)
    {
        var userId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (userId is null)
            return Unauthorized();

        try
        {
            var result = await _actionService.CreateAsync(
                userId,
                request,
                cancellationToken);

            return Ok(result);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new
            {
                message = ex.Message
            });
        }
    }

    [HttpPost("{actionId:long}/execute")]
    public async Task<ActionResult<ActionResponse>> Execute(
        long actionId,
        CancellationToken cancellationToken)
    {
        var userId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (userId is null)
            return Unauthorized();

        try
        {
            var result = await _actionService.ExecuteAsync(
                userId,
                actionId,
                cancellationToken);

            if (result is null)
                return NotFound();

            return Ok(result);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new
            {
                message = ex.Message
            });
        }
    }

    [HttpGet("crop/{cropId:int}")]
    public async Task<ActionResult<List<ActionResponse>>> GetByCrop(
        int cropId,
        CancellationToken cancellationToken)
    {
        var userId = User.FindFirstValue(
            ClaimTypes.NameIdentifier);

        if (userId is null)
            return Unauthorized();

        var result = await _actionService.GetByCropAsync(
            userId,
            cropId,
            cancellationToken);

        return Ok(result);
    }
}