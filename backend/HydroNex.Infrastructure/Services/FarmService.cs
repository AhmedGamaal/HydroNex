using HydroNex.Application.Features.Farms;
using HydroNex.Application.Features.Farms.DTOs;
using HydroNex.Domain.Entities;
using HydroNex.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace HydroNex.Infrastructure.Services;

public class FarmService : IFarmService
{
    private readonly ApplicationDbContext _db;

    public FarmService(ApplicationDbContext db)
    {
        _db = db;
    }

    public async Task<FarmResponse> CreateAsync(
        string userId,
        CreateFarmRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Name))
            throw new InvalidOperationException(
                "Farm name is required.");

        var farm = new Farm
        {
            UserId = userId,
            Name = request.Name.Trim(),
            Location = request.Location?.Trim(),
            Description = request.Description?.Trim()
        };

        _db.Farms.Add(farm);
        await _db.SaveChangesAsync();

        return Map(farm, 0);
    }

    public async Task<List<FarmResponse>> GetMyFarmsAsync(
        string userId)
    {
        return await _db.Farms
            .Where(x => x.UserId == userId)
            .Select(x => new FarmResponse(
                x.Id,
                x.Name,
                x.Location,
                x.Description,
                x.Crops.Count,
                x.CreatedAt))
            .OrderByDescending(x => x.CreatedAt)
            .ToListAsync();
    }

    public async Task<FarmResponse?> GetByIdAsync(
        string userId,
        int farmId)
    {
        return await _db.Farms
            .Where(x =>
                x.Id == farmId &&
                x.UserId == userId)
            .Select(x => new FarmResponse(
                x.Id,
                x.Name,
                x.Location,
                x.Description,
                x.Crops.Count,
                x.CreatedAt))
            .FirstOrDefaultAsync();
    }

    public async Task<FarmResponse> UpdateAsync(
        string userId,
        int farmId,
        UpdateFarmRequest request)
    {
        if (string.IsNullOrWhiteSpace(request.Name))
            throw new InvalidOperationException(
                "Farm name is required.");

        var farm = await _db.Farms
            .FirstOrDefaultAsync(x =>
                x.Id == farmId &&
                x.UserId == userId);

        if (farm is null)
            throw new InvalidOperationException(
                "Farm not found.");

        farm.Name = request.Name.Trim();
        farm.Location = request.Location?.Trim();
        farm.Description = request.Description?.Trim();
        farm.UpdatedAt = DateTime.UtcNow;

        await _db.SaveChangesAsync();

        var cropCount = await _db.Crops
            .CountAsync(x => x.FarmId == farmId);

        return Map(farm, cropCount);
    }

    public async Task DeleteAsync(
        string userId,
        int farmId)
    {
        var farm = await _db.Farms
            .FirstOrDefaultAsync(x =>
                x.Id == farmId &&
                x.UserId == userId);

        if (farm is null)
            throw new InvalidOperationException(
                "Farm not found.");

        _db.Farms.Remove(farm);

        await _db.SaveChangesAsync();
    }

    private static FarmResponse Map(
        Farm farm,
        int cropCount)
    {
        return new FarmResponse(
            farm.Id,
            farm.Name,
            farm.Location,
            farm.Description,
            cropCount,
            farm.CreatedAt);
    }
}