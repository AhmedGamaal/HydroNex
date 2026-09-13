using HydroNex.Application.Features.Actions;
using HydroNex.Application.Features.Actions.DTOs;
using HydroNex.Application.Features.AI;
using HydroNex.Application.Features.Alerts;
using HydroNex.Application.Features.CropContext;
using HydroNex.Application.Features.Recommendations;
using HydroNex.Application.Features.Recommendations.DTOs;
using HydroNex.Application.Features.Telemetry;
using HydroNex.Domain.Entities;
using HydroNex.Domain.Enums;
using HydroNex.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace HydroNex.Infrastructure.Services;

public class RecommendationService : IRecommendationService
{
    // Explicit RiskLevel -> AlertSeverity mapping (handoff #27: business
    // rule must be explicit). High and Critical both surface as a
    // Critical alert since both need grower attention promptly.
    private static AlertSeverity SeverityFor(RiskLevel riskLevel) => riskLevel switch
    {
        RiskLevel.Critical => AlertSeverity.Critical,
        RiskLevel.High => AlertSeverity.Critical,
        RiskLevel.Medium => AlertSeverity.Warning,
        _ => AlertSeverity.Info
    };

    // Explicit RecommendationActionType -> ActuatorActionType mapping
    // (handoff section 29). ApplyTreatment/ContinueMonitoring have no
    // direct actuator equivalent - they can be Applied without creating
    // an ActionLog, since there's nothing for the digital twin to execute.
    private static ActuatorActionType? ActuatorFor(RecommendationActionType actionType) => actionType switch
    {
        RecommendationActionType.Irrigation => ActuatorActionType.IRRIGATION_ON,
        RecommendationActionType.AdjustPH => ActuatorActionType.PH_UP,
        RecommendationActionType.AdjustEC => ActuatorActionType.EC_ADJUST,
        RecommendationActionType.ReduceHumidity => ActuatorActionType.VENTILATION_ON,
        RecommendationActionType.IncreaseVentilation => ActuatorActionType.VENTILATION_ON,
        _ => null // ApplyTreatment, ContinueMonitoring
    };

    private readonly ApplicationDbContext _db;
    private readonly ICropContextService _cropContextService;
    private readonly IRecommendationAiClient _recommendationAiClient;
    private readonly IAlertService _alertService;
    private readonly IActionService _actionService;
    private readonly ITelemetryHubPublisher _hubPublisher;

    public RecommendationService(
        ApplicationDbContext db,
        ICropContextService cropContextService,
        IRecommendationAiClient recommendationAiClient,
        IAlertService alertService,
        IActionService actionService,
        ITelemetryHubPublisher hubPublisher)
    {
        _db = db;
        _cropContextService = cropContextService;
        _recommendationAiClient = recommendationAiClient;
        _alertService = alertService;
        _actionService = actionService;
        _hubPublisher = hubPublisher;
    }

    public async Task<RecommendationResponse> GenerateAsync(
        string userId,
        GenerateRecommendationRequest request,
        CancellationToken cancellationToken = default)
    {
        if (request.DiseaseAnalysisId.HasValue)
        {
            var diseaseBelongsToCrop = await _db.DiseaseAnalyses
                .AnyAsync(
                    d => d.Id == request.DiseaseAnalysisId.Value &&
                         d.PlantImage.CropId == request.CropId &&
                         d.PlantImage.Crop.Farm.UserId == userId,
                    cancellationToken);

            if (!diseaseBelongsToCrop)
                throw new InvalidOperationException(
                    "Disease analysis not found for this crop.");
        }

        // ICropContextService itself validates crop ownership.
        var context = await _cropContextService.BuildContextAsync(
            userId,
            request.CropId,
            cancellationToken);

        var aiResult = await _recommendationAiClient.GenerateAsync(
            context,
            cancellationToken);

        var recommendation = new Recommendation
        {
            CropId = request.CropId,
            DiseaseAnalysisId = request.DiseaseAnalysisId,
            Title = aiResult.Title,
            Description = aiResult.Description,
            RiskLevel = aiResult.RiskLevel,
            ActionType = aiResult.ActionType,
            Status = RecommendationStatus.Pending
        };

        _db.Recommendations.Add(recommendation);

        await _db.SaveChangesAsync(cancellationToken);

        // Recommendation -> Alert (handoff section 27).
        var alert = await _alertService.CreateAlertAsync(
            request.CropId,
            AlertType.AIRecommendation,
            SeverityFor(recommendation.RiskLevel),
            $"New recommendation: {recommendation.Title}",
            recommendation.Id,
            cancellationToken);

        var response = Map(recommendation);

        await _hubPublisher.PublishRecommendationCreatedAsync(
            request.CropId,
            response);

        return response;
    }

    public async Task<List<RecommendationResponse>> GetByCropAsync(
        string userId,
        int cropId,
        CancellationToken cancellationToken = default)
    {
        return await _db.Recommendations
            .Where(r => r.CropId == cropId && r.Crop.Farm.UserId == userId)
            .OrderByDescending(r => r.CreatedAt)
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
    }

    public async Task<RecommendationResponse?> GetByIdAsync(
        string userId,
        int id,
        CancellationToken cancellationToken = default)
    {
        var recommendation = await _db.Recommendations
            .FirstOrDefaultAsync(
                r => r.Id == id && r.Crop.Farm.UserId == userId,
                cancellationToken);

        return recommendation is null ? null : Map(recommendation);
    }

    public async Task<RecommendationResponse> ApplyAsync(
        string userId,
        int id,
        CancellationToken cancellationToken = default)
    {
        var recommendation = await LoadOwnedAsync(userId, id, cancellationToken);

        if (recommendation.Status == RecommendationStatus.Applied)
            return Map(recommendation);

        if (recommendation.Status == RecommendationStatus.Dismissed)
            throw new InvalidOperationException(
                "Dismissed recommendation cannot be applied.");

        var actuator = ActuatorFor(recommendation.ActionType);

        if (actuator.HasValue)
        {
            // Recommendation.CropId == Action.CropId is enforced here by
            // construction, and IActionService re-validates ownership
            // (handoff section 29) - never a second action system.
            await _actionService.CreateAsync(
                userId,
                new CreateActionRequest(
                    recommendation.CropId,
                    recommendation.Id,
                    actuator.Value,
                    $"Auto-generated from recommendation #{recommendation.Id}: {recommendation.Title}"),
                cancellationToken);
        }

        recommendation.Status = RecommendationStatus.Applied;

        await _db.SaveChangesAsync(cancellationToken);

        return Map(recommendation);
    }

    public async Task<RecommendationResponse> DismissAsync(
        string userId,
        int id,
        CancellationToken cancellationToken = default)
    {
        var recommendation = await LoadOwnedAsync(userId, id, cancellationToken);

        if (recommendation.Status != RecommendationStatus.Applied)
            recommendation.Status = RecommendationStatus.Dismissed;

        await _db.SaveChangesAsync(cancellationToken);

        return Map(recommendation);
    }

    private async Task<Recommendation> LoadOwnedAsync(
        string userId,
        int id,
        CancellationToken cancellationToken)
    {
        var recommendation = await _db.Recommendations
            .FirstOrDefaultAsync(
                r => r.Id == id && r.Crop.Farm.UserId == userId,
                cancellationToken);

        if (recommendation is null)
            throw new InvalidOperationException("Recommendation not found.");

        return recommendation;
    }

    private static RecommendationResponse Map(Recommendation recommendation)
    {
        return new RecommendationResponse(
            recommendation.Id,
            recommendation.CropId,
            recommendation.DiseaseAnalysisId,
            recommendation.Title,
            recommendation.Description,
            recommendation.RiskLevel,
            recommendation.ActionType,
            recommendation.Status,
            recommendation.CreatedAt);
    }
}
