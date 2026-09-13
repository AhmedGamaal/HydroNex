using System.Security.Claims;
using HydroNex.Application.Common.Exceptions;
using HydroNex.Application.Features.DiseaseAnalysis;
using HydroNex.Application.Features.DiseaseAnalysis.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HydroNex.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/disease-analysis")]
public class DiseaseAnalysisController : ControllerBase
{
    private readonly IDiseaseAnalysisService _diseaseAnalysisService;

    public DiseaseAnalysisController(IDiseaseAnalysisService diseaseAnalysisService)
    {
        _diseaseAnalysisService = diseaseAnalysisService;
    }

    [HttpPost("analyze")]
    public async Task<ActionResult<DiseaseAnalysisResponse>> Analyze(
        AnalyzeDiseaseRequest request,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        if (userId is null)
            return Unauthorized();

        try
        {
            var result = await _diseaseAnalysisService.AnalyzeAsync(
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

    [HttpGet("image/{plantImageId:int}")]
    public async Task<ActionResult<List<DiseaseAnalysisResponse>>> GetByImage(
        int plantImageId,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        if (userId is null)
            return Unauthorized();

        var result = await _diseaseAnalysisService.GetByImageAsync(
            userId,
            plantImageId,
            cancellationToken);

        return Ok(result);
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<DiseaseAnalysisResponse>> GetById(
        int id,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        if (userId is null)
            return Unauthorized();

        var result = await _diseaseAnalysisService.GetByIdAsync(
            userId,
            id,
            cancellationToken);

        if (result is null)
            return NotFound(new { message = "Disease analysis not found." });

        return Ok(result);
    }

    private string? GetUserId()
    {
        return User.FindFirstValue(ClaimTypes.NameIdentifier);
    }
}
