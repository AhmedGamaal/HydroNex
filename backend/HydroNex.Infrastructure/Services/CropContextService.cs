using HydroNex.Application.Features.CropContext;
using HydroNex.Application.Features.CropContext.DTOs;
using HydroNex.Application.Features.DiseaseAnalysis.DTOs;
using HydroNex.Application.Features.Recommendations.DTOs;
using HydroNex.Application.Features.Telemetry;
using HydroNex.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace HydroNex.Infrastructure.Services;

public class CropContextService : ICropContextService
{
    // How far back "recent history" looks for AI context - explicit
    // business rule rather than an unbounded query.
    private static readonly TimeSpan RecentHistoryWindow = TimeSpan.FromHours(24);
    private const int RecentDiseaseAnalysisCount = 3;
    private const int RecentRecommendationCount = 3;

    private readonly ApplicationDbContext _db;
    private readonly ITelemetryService _telemetryService;

    public CropContextService(
        ApplicationDbContext db,
        ITelemetryService telemetryService)
    {
        _db = db;
        _telemetryService = telemetryService;
    }

    public async Task<CropContextDto> BuildContextAsync(
        string userId,
        int cropId,
        CancellationToken cancellationToken = default)
    {
        var crop = await _db.Crops
            .FirstOrDefaultAsync(
                c => c.Id == cropId && c.Farm.UserId == userId,
                cancellationToken);

        if (crop is null)
            throw new InvalidOperationException("Crop not found.");

        // Reuse existing telemetry service exactly as REST/SignalR do -
        // never query Sensor/SensorReading tables directly (handoff #31).
        var currentSensors = await _telemetryService.GetLatestByCropAsync(
            userId,
            cropId,
            cancellationToken);

        var recentHistory = await _telemetryService.GetHistoryAsync(
            userId,
            cropId,
            DateTime.UtcNow - RecentHistoryWindow,
            null,
            cancellationToken);

        var recentDiseaseAnalyses = await _db.DiseaseAnalyses
            .Where(d => d.PlantImage.CropId == cropId && d.PlantImage.Crop.Farm.UserId == userId)
            .OrderByDescending(d => d.AnalyzedAt)
            .Take(RecentDiseaseAnalysisCount)
            .Select(d => new DiseaseAnalysisResponse(
                d.Id,
                d.PlantImageId,
                d.DiseaseName,
                d.ConfidenceScore,
                d.AnalysisResult,
                d.AnalyzedAt))
            .ToListAsync(cancellationToken);

        var recentRecommendations = await _db.Recommendations
            .Where(r => r.CropId == cropId && r.Crop.Farm.UserId == userId)
            .OrderByDescending(r => r.CreatedAt)
            .Take(RecentRecommendationCount)
            .Select(r => new RecommendationResponse(
                r.Id,
                r.CropId,
                r.DiseaseAnalysisId,
                r.Title,
                r.Description,
                r.RiskLevel,
                r.ActionType,
                r.Status,
                r.CreatedAt))
            .ToListAsync(cancellationToken);

        return new CropContextDto(
            crop.Id,
            crop.Name,
            crop.CropType,
            crop.GrowthStage,
            crop.Status,
            currentSensors,
            recentHistory,
            recentDiseaseAnalyses,
            recentRecommendations);
    }
}
