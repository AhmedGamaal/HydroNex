using System.Security.Claims;
using HydroNex.Application.Common.Exceptions;
using HydroNex.Application.Features.Recommendations;
using HydroNex.Application.Features.Recommendations.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HydroNex.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/recommendations")]
public class RecommendationsController : ControllerBase
{
    private readonly IRecommendationService _recommendationService;

    public RecommendationsController(IRecommendationService recommendationService)
    {
        _recommendationService = recommendationService;
    }

    [HttpPost("generate")]
    public async Task<ActionResult<RecommendationResponse>> Generate(
        GenerateRecommendationRequest request,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        if (userId is null)
            return Unauthorized();

        try
        {
            var result = await _recommendationService.GenerateAsync(
                userId,
                request,
                cancellationToken);

            return Ok(result);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
        catch (AiServiceUnavailableException ex)
        {
            return StatusCode(StatusCodes.Status503ServiceUnavailable, new { message = ex.Message });
        }
    }

    [HttpGet("crop/{cropId:int}")]
    public async Task<ActionResult<List<RecommendationResponse>>> GetByCrop(
        int cropId,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        if (userId is null)
            return Unauthorized();

        var result = await _recommendationService.GetByCropAsync(
            userId,
            cropId,
            cancellationToken);

        return Ok(result);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<RecommendationResponse>> GetById(
        int id,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        if (userId is null)
            return Unauthorized();

        var result = await _recommendationService.GetByIdAsync(
            userId,
            id,
            cancellationToken);

        if (result is null)
            return NotFound(new { message = "Recommendation not found." });

        return Ok(result);
    }

    [HttpPost("{id:int}/apply")]
    public async Task<ActionResult<RecommendationResponse>> Apply(
        int id,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        if (userId is null)
            return Unauthorized();

        try
        {
            var result = await _recommendationService.ApplyAsync(
                userId,
                id,
                cancellationToken);

            return Ok(result);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpPost("{id:int}/dismiss")]
    public async Task<ActionResult<RecommendationResponse>> Dismiss(
        int id,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        if (userId is null)
            return Unauthorized();

        try
        {
            var result = await _recommendationService.DismissAsync(
                userId,
                id,
                cancellationToken);

            return Ok(result);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    private string? GetUserId()
    {
        return User.FindFirstValue(ClaimTypes.NameIdentifier);
    }
}
