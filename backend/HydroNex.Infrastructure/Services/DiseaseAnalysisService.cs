using HydroNex.Application.Common.Exceptions;
using HydroNex.Application.Common.Files;
using HydroNex.Application.Features.AI;
using HydroNex.Application.Features.Alerts;
using HydroNex.Application.Features.DiseaseAnalysis;
using HydroNex.Application.Features.DiseaseAnalysis.DTOs;
using HydroNex.Application.Features.Recommendations;
using HydroNex.Application.Features.Recommendations.DTOs;
using HydroNex.Application.Features.Telemetry;
using HydroNex.Domain.Entities;
using HydroNex.Domain.Enums;
using HydroNex.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace HydroNex.Infrastructure.Services;

public class DiseaseAnalysisService : IDiseaseAnalysisService
{
    // Explicit business rules (handoff section 28: "should be explicit,
    // not random") for when a disease result is significant enough to
    // raise an alert / trigger a recommendation, and how severity maps.
    private const decimal DetectionConfidenceThreshold = 0.60m;
    private const decimal CriticalConfidenceThreshold = 0.85m;
    private static readonly string[] NoDiseaseLabels = { "healthy", "none", "no disease" };

    private readonly ApplicationDbContext _db;
    private readonly IFileStorageService _fileStorage;
    private readonly IPlantDiseaseAiClient _diseaseAiClient;
    private readonly IAlertService _alertService;
    private readonly IRecommendationService _recommendationService;
    private readonly ITelemetryHubPublisher _hubPublisher;

    public DiseaseAnalysisService(
        ApplicationDbContext db,
        IFileStorageService fileStorage,
        IPlantDiseaseAiClient diseaseAiClient,
        IAlertService alertService,
        IRecommendationService recommendationService,
        ITelemetryHubPublisher hubPublisher)
    {
        _db = db;
        _fileStorage = fileStorage;
        _diseaseAiClient = diseaseAiClient;
        _alertService = alertService;
        _recommendationService = recommendationService;
        _hubPublisher = hubPublisher;
    }

    public async Task<DiseaseAnalysisResponse> AnalyzeAsync(
        string userId,
        AnalyzeDiseaseRequest request,
        CancellationToken cancellationToken = default)
    {
        var plantImage = await _db.PlantImages
            .Include(p => p.Crop)
            .FirstOrDefaultAsync(
                p => p.Id == request.PlantImageId && p.Crop.Farm.UserId == userId,
                cancellationToken);

        if (plantImage is null)
            throw new InvalidOperationException("Plant image not found.");

        var (fileName, contentType) = GuessFileMetadata(plantImage.ImageUrl);

        DiseaseAnalysis analysis;

        await using (var imageStream = await _fileStorage.OpenReadAsync(
            plantImage.ImageUrl,
            cancellationToken))
        {
            var aiResult = await _diseaseAiClient.AnalyzeAsync(
                imageStream,
                fileName,
                contentType,
                cancellationToken);

            analysis = new DiseaseAnalysis
            {
                PlantImageId = plantImage.Id,
                DiseaseName = aiResult.DiseaseName,
                ConfidenceScore = aiResult.Confidence,
                AnalysisResult = aiResult.AnalysisResult,
                AnalyzedAt = DateTime.UtcNow
            };
        }

        _db.DiseaseAnalyses.Add(analysis);

        await _db.SaveChangesAsync(cancellationToken);

        await _hubPublisher.PublishDiseaseDetectedAsync(
            plantImage.CropId,
            new
            {
                analysis.Id,
                analysis.PlantImageId,
                analysis.DiseaseName,
                analysis.ConfidenceScore,
                analysis.AnalyzedAt
            });

        if (IsSignificant(analysis.DiseaseName, analysis.ConfidenceScore))
        {
            var severity = analysis.ConfidenceScore >= CriticalConfidenceThreshold
                ? AlertSeverity.Critical
                : AlertSeverity.Warning;

            await _alertService.CreateAlertAsync(
                plantImage.CropId,
                AlertType.DiseaseDetected,
                severity,
                $"Disease detected: {analysis.DiseaseName} " +
                $"(confidence {analysis.ConfidenceScore:P0}).",
                recommendationId: null,
                cancellationToken);

            // Disease -> Recommendation (handoff section 25/44). If the
            // recommendation AI is unavailable, the disease analysis and
            // its alert are still valid and already persisted - we don't
            // fail the whole request over a downstream, best-effort step.
            try
            {
                await _recommendationService.GenerateAsync(
                    userId,
                    new GenerateRecommendationRequest(plantImage.CropId, analysis.Id),
                    cancellationToken);
            }
            catch (AiServiceUnavailableException)
            {
                // Swallow: disease analysis itself succeeded and was
                // saved/alerted; recommendation can be generated later
                // via POST /api/recommendations/generate.
            }
        }

        return Map(analysis);
    }

    public async Task<List<DiseaseAnalysisResponse>> GetByImageAsync(
        string userId,
        int plantImageId,
        CancellationToken cancellationToken = default)
    {
        return await _db.DiseaseAnalyses
            .Where(d =>
                d.PlantImageId == plantImageId &&
                d.PlantImage.Crop.Farm.UserId == userId)
            .OrderByDescending(d => d.AnalyzedAt)
            .Select(d => new DiseaseAnalysisResponse(
                d.Id,
                d.PlantImageId,
                d.DiseaseName,
                d.ConfidenceScore,
                d.AnalysisResult,
                d.AnalyzedAt))
            .ToListAsync(cancellationToken);
    }

    public async Task<DiseaseAnalysisResponse?> GetByIdAsync(
        string userId,
        int id,
        CancellationToken cancellationToken = default)
    {
        var analysis = await _db.DiseaseAnalyses
            .FirstOrDefaultAsync(
                d => d.Id == id && d.PlantImage.Crop.Farm.UserId == userId,
                cancellationToken);

        return analysis is null ? null : Map(analysis);
    }

    private static bool IsSignificant(string diseaseName, decimal confidence)
    {
        if (confidence < DetectionConfidenceThreshold)
            return false;

        var normalized = diseaseName.Trim().ToLowerInvariant();

        return !NoDiseaseLabels.Contains(normalized);
    }

    private static (string FileName, string ContentType) GuessFileMetadata(string imageUrl)
    {
        var extension = Path.GetExtension(imageUrl).ToLowerInvariant();

        var contentType = extension switch
        {
            ".png" => "image/png",
            ".webp" => "image/webp",
            _ => "image/jpeg"
        };

        return (Path.GetFileName(imageUrl), contentType);
    }

    private static DiseaseAnalysisResponse Map(DiseaseAnalysis analysis)
    {
        return new DiseaseAnalysisResponse(
            analysis.Id,
            analysis.PlantImageId,
            analysis.DiseaseName,
            analysis.ConfidenceScore,
            analysis.AnalysisResult,
            analysis.AnalyzedAt);
    }
}
