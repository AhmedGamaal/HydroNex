using HydroNex.Application.Features.Crops;
using HydroNex.Application.Features.Crops.DTOs;
using HydroNex.Domain.Entities;
using HydroNex.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace HydroNex.Infrastructure.Services;

public class CropService : ICropService
{
    private readonly ApplicationDbContext _db;

    public CropService(ApplicationDbContext db)
    {
        _db = db;
    }

    public async Task<CropDetailsResponse> CreateAsync(
        string userId,
        CreateCropRequest request)
    {
        if (request.CycleDuration <= 0)
            throw new InvalidOperationException(
                "Cycle duration must be greater than zero.");

        var farm = await _db.Farms
            .FirstOrDefaultAsync(x =>
                x.Id == request.FarmId &&
                x.UserId == userId);

        if (farm is null)
            throw new InvalidOperationException(
                "Farm not found.");

        var batchExists = await _db.Crops.AnyAsync(x =>
            x.FarmId == request.FarmId &&
            x.BatchId == request.BatchId);

        if (batchExists)
            throw new InvalidOperationException(
                "Batch ID already exists in this farm.");

        var crop = new Crop
        {
            FarmId = request.FarmId,
            Name = request.CropType,
            CropType = request.CropType,
            BatchId = request.BatchId,
            Location = request.Location,
            Notes = request.Notes,
            Variety = request.Variety,
            PlantingDate = request.PlantingDate,
            CycleDuration = request.CycleDuration,
            ExpectedHarvestDate =
                request.PlantingDate.AddDays(request.CycleDuration)
        };

        _db.Crops.Add(crop);
        await _db.SaveChangesAsync();

        return MapDetails(crop);
    }

    public async Task<List<CropListResponse>> GetMyCropsAsync(
        string userId)
    {
        var crops = await _db.Crops
            .Include(x => x.Farm)
            .Where(x => x.Farm.UserId == userId)
            .OrderByDescending(x => x.CreatedAt)
            .ToListAsync();

        return crops.Select(MapList).ToList();
    }

    public async Task<CropDetailsResponse?> GetByIdAsync(
        string userId,
        int cropId)
    {
        var crop = await _db.Crops
            .Include(x => x.Farm)
            .FirstOrDefaultAsync(x =>
                x.Id == cropId &&
                x.Farm.UserId == userId);

        return crop is null ? null : MapDetails(crop);
    }

    public async Task<CropDetailsResponse> UpdateAsync(
        string userId,
        int cropId,
        UpdateCropRequest request)
    {
        if (request.CycleDuration <= 0)
            throw new InvalidOperationException(
                "Cycle duration must be greater than zero.");

        var crop = await _db.Crops
            .Include(x => x.Farm)
            .FirstOrDefaultAsync(x =>
                x.Id == cropId &&
                x.Farm.UserId == userId);

        if (crop is null)
            throw new InvalidOperationException(
                "Crop not found.");

        var duplicateBatch = await _db.Crops.AnyAsync(x =>
            x.Id != cropId &&
            x.FarmId == crop.FarmId &&
            x.BatchId == request.BatchId);

        if (duplicateBatch)
            throw new InvalidOperationException(
                "Batch ID already exists in this farm.");

        crop.Name = request.CropType;
        crop.CropType = request.CropType;
        crop.BatchId = request.BatchId;
        crop.Location = request.Location;
        crop.Notes = request.Notes;
        crop.Variety = request.Variety;
        crop.PlantingDate = request.PlantingDate;
        crop.CycleDuration = request.CycleDuration;
        crop.ExpectedHarvestDate =
            request.PlantingDate.AddDays(request.CycleDuration);
        crop.GrowthStage = request.GrowthStage;
        crop.Status = request.Status;
        crop.UpdatedAt = DateTime.UtcNow;

        await _db.SaveChangesAsync();

        return MapDetails(crop);
    }

    public async Task DeleteAsync(
        string userId,
        int cropId)
    {
        var crop = await _db.Crops
            .Include(x => x.Farm)
            .FirstOrDefaultAsync(x =>
                x.Id == cropId &&
                x.Farm.UserId == userId);

        if (crop is null)
            throw new InvalidOperationException(
                "Crop not found.");

        _db.Crops.Remove(crop);

        await _db.SaveChangesAsync();
    }

    private static CropListResponse MapList(Crop crop)
    {
        var (currentDay, progress) = CalculateProgress(
            crop.PlantingDate,
            crop.CycleDuration);

        return new CropListResponse(
            crop.Id,
            crop.Name,
            crop.CropType,
            crop.BatchId,
            crop.Location,
            crop.GrowthStage,
            crop.Status,
            crop.PlantingDate,
            crop.CycleDuration,
            currentDay,
            progress);
    }

    private static CropDetailsResponse MapDetails(Crop crop)
    {
        var (currentDay, progress) = CalculateProgress(
            crop.PlantingDate,
            crop.CycleDuration);

        return new CropDetailsResponse(
            crop.Id,
            crop.Name,
            crop.CropType,
            crop.BatchId,
            crop.Location,
            crop.Notes,
            crop.Variety,
            crop.PlantingDate,
            crop.CycleDuration,
            crop.ExpectedHarvestDate,
            crop.GrowthStage,
            crop.Status,
            currentDay,
            progress);
    }

    private static (int CurrentDay, int Progress) CalculateProgress(
        DateTime plantingDate,
        int cycleDuration)
    {
        var today = DateTime.UtcNow.Date;
        var start = plantingDate.Date;

        var currentDay = Math.Max(
            1,
            (today - start).Days + 1);

        var progress = Math.Clamp(
            (int)Math.Round(
                currentDay * 100.0 / cycleDuration),
            0,
            100);

        return (currentDay, progress);
    }
}