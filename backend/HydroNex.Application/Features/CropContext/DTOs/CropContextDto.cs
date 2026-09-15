using HydroNex.Application.Features.DiseaseAnalysis.DTOs;
using HydroNex.Application.Features.Recommendations.DTOs;
using HydroNex.Application.Features.Telemetry.DTOs;
using HydroNex.Domain.Enums;

namespace HydroNex.Application.Features.CropContext.DTOs;

// Normalized "what does the AI need to know about this crop right now"
// snapshot, per handoff section 30. Built by ICropContextService from
// existing services only (ITelemetryService, DiseaseAnalysis/Recommendation
// repositories) - never queried ad-hoc from controllers or AI clients.
public record CropContextDto(
    int CropId,
    string CropName,
    string CropType,
    GrowthStage GrowthStage,
    CropStatus Status,
    List<LatestSensorReadingResponse> CurrentSensors,
    List<SensorReadingResponse> RecentHistory,
    List<DiseaseAnalysisResponse> RecentDiseaseAnalyses,
    List<RecommendationResponse> RecentRecommendations
);
