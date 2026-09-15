using System.Security.Claims;
using HydroNex.Application.Features.Farms;
using HydroNex.Application.Features.Farms.DTOs;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace HydroNex.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]")]
public class FarmsController : ControllerBase
{
    private readonly IFarmService _farmService;

    public FarmsController(IFarmService farmService)
    {
        _farmService = farmService;
    }

    [HttpPost]
    public async Task<IActionResult> Create(
        CreateFarmRequest request)
    {
        try
        {
            var result = await _farmService.CreateAsync(
                GetUserId(),
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
    public async Task<IActionResult> GetMyFarms()
    {
        var result = await _farmService.GetMyFarmsAsync(
            GetUserId());

        return Ok(result);
    }

    [HttpGet("{id:int}")]
    public async Task<IActionResult> GetById(int id)
    {
        var result = await _farmService.GetByIdAsync(
            GetUserId(),
            id);

        if (result is null)
            return NotFound(new
            {
                message = "Farm not found."
            });

        return Ok(result);
    }

    [HttpPut("{id:int}")]
    public async Task<IActionResult> Update(
        int id,
        UpdateFarmRequest request)
    {
        try
        {
            var result = await _farmService.UpdateAsync(
                GetUserId(),
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
            await _farmService.DeleteAsync(
                GetUserId(),
                id);

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