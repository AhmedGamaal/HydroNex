using HydroNex.Application.Features.Dashboard;
using HydroNex.Application.Features.Dashboard.DTOs;
using HydroNex.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace HydroNex.Infrastructure.Services;

public class DashboardService : IDashboardService
{
    private readonly ApplicationDbContext _db;

    public DashboardService(ApplicationDbContext db)
    {
        _db = db;
    }

    public async Task<DashboardResponse> GetAsync(
        string userId)
    {
        var farms = _db.Farms
            .Where(x => x.UserId == userId);

        var crops = _db.Crops
            .Where(x => x.Farm.UserId == userId);

        var cropData = await crops
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new
            {
                x.Id,
                x.Name,
                x.CropType,
                x.BatchId,
                x.PlantingDate,
                x.CycleDuration,
                x.GrowthStage,
                x.Status
            })
            .ToListAsync();

        var openAlertCount = await _db.Alerts
            .CountAsync(x =>
                x.Crop.Farm.UserId == userId &&
                x.Status == Domain.Enums.AlertStatus.Open);

        var onlineSensorCount = await _db.Sensors
            .CountAsync(x =>
                x.Crop.Farm.UserId == userId &&
                x.Status == Domain.Enums.SensorStatus.Active);

        var dashboardCrops = cropData
            .Select(x =>
            {
                var currentDay = Math.Max(
                    1,
                    (DateTime.UtcNow.Date -
                     x.PlantingDate.Date).Days + 1);

                var progress = Math.Clamp(
                    (int)Math.Round(
                        currentDay * 100.0 /
                        x.CycleDuration),
                    0,
                    100);

                return new DashboardCropResponse(
                    x.Id,
                    x.Name,
                    x.CropType,
                    x.BatchId,
                    currentDay,
                    x.CycleDuration,
                    progress,
                    x.GrowthStage.ToString(),
                    x.Status.ToString());
            })
            .ToList();

        return new DashboardResponse(
            await farms.CountAsync(),
            cropData.Count,
            cropData.Count(x =>
                x.Status == Domain.Enums.CropStatus.Active),
            openAlertCount,
            onlineSensorCount,
            dashboardCrops);
    }
}