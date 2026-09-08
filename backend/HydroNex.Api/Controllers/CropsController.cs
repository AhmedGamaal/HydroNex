using System.Security.Claims;
using HydroNex.Application.Features.Crops;
using HydroNex.Application.Features.Crops.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HydroNex.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public class CropsController : ControllerBase
{
    private readonly ICropService _cropService;

    public CropsController(ICropService cropService)
    {
        _cropService = cropService;
    }

    [HttpPost]
    public async Task<IActionResult> Create(
        CreateCropRequest request)
    {
        try
        {
            var userId = GetUserId();

            var result = await _cropService.CreateAsync(
                userId,
                request);

            return CreatedAtAction(
                nameof(GetById),
                new { id = result.Id },
                result);
        }
        catch (InvalidOperationException ex)
        {
            return BadRequest(new
            {
                message = ex.Message
            });
        }
    }

    [HttpGet]
    public async Task<IActionResult> GetMyCrops()
    {
        var userId = GetUserId();

        var crops =
            await _cropService.GetMyCropsAsync(userId);

        return Ok(crops);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var userId = GetUserId();

        var crop =
            await _cropService.GetByIdAsync(userId, id);

        if (crop is null)
            return NotFound(new
            {
                message = "Crop not found."
            });

        return Ok(crop);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(
        int id,
        UpdateCropRequest request)
    {
        try
        {
            var userId = GetUserId();

            var result = await _cropService.UpdateAsync(
                userId,
                id,
                request);

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

    [HttpDelete("{id:int}")]
    public async Task<IActionResult> Delete(int id)
    {
        try
        {
            var userId = GetUserId();

            await _cropService.DeleteAsync(userId, id);

            return NoContent();
        }
        catch (InvalidOperationException ex)
        {
            return NotFound(new
            {
                message = ex.Message
            });
        }
    }

    private string GetUserId()
    {
        return User.FindFirstValue(
                   ClaimTypes.NameIdentifier)
               ?? throw new UnauthorizedAccessException();
    }
}