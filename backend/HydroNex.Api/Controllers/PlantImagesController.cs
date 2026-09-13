using System.Security.Claims;
using HydroNex.Application.Features.PlantImages;
using HydroNex.Application.Features.PlantImages.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HydroNex.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/plant-images")]
public class PlantImagesController : ControllerBase
{
    private readonly IPlantImageService _plantImageService;

    public PlantImagesController(IPlantImageService plantImageService)
    {
        _plantImageService = plantImageService;
    }

    [HttpPost]
    [RequestSizeLimit(10 * 1024 * 1024)]
    public async Task<ActionResult<PlantImageResponse>> Upload(
        [FromForm] int cropId,
        IFormFile file,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        if (userId is null)
            return Unauthorized();

        if (file is null || file.Length == 0)
            return BadRequest(new { message = "No file uploaded." });

        try
        {
            await using var stream = file.OpenReadStream();

            var result = await _plantImageService.UploadAsync(
                userId,
                cropId,
                stream,
                file.FileName,
                file.ContentType,
                file.Length,
                cancellationToken);

            return CreatedAtAction(
                nameof(GetById),
                new { imageId = result.Id },
                result);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new { message = ex.Message });
        }
    }

    [HttpGet("crop/{cropId:int}")]
    public async Task<ActionResult<List<PlantImageResponse>>> GetByCrop(
        int cropId,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        if (userId is null)
            return Unauthorized();

        var result = await _plantImageService.GetByCropAsync(
            userId,
            cropId,
            cancellationToken);

        return Ok(result);
    }

    [HttpGet("{imageId:int}")]
    public async Task<ActionResult<PlantImageResponse>> GetById(
        int imageId,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        if (userId is null)
            return Unauthorized();

        var result = await _plantImageService.GetByIdAsync(
            userId,
            imageId,
            cancellationToken);

        if (result is null)
            return NotFound(new { message = "Plant image not found." });

        return Ok(result);
    }

    [HttpDelete("{imageId:int}")]
    public async Task<IActionResult> Delete(
        int imageId,
        CancellationToken cancellationToken)
    {
        var userId = GetUserId();

        if (userId is null)
            return Unauthorized();

        try
        {
            await _plantImageService.DeleteAsync(userId, imageId, cancellationToken);

            return NoContent();
        }
        catch (InvalidOperationException ex)
        {
            return NotFound(new { message = ex.Message });
        }
    }

    private string? GetUserId()
    {
        return User.FindFirstValue(ClaimTypes.NameIdentifier);
    }
}
