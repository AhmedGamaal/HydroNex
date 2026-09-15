using HydroNex.Domain.Enums;

namespace HydroNex.Application.Features.Recommendations.DTOs;

// DiseaseAnalysisId is optional: recommendations can also be generated
// purely from live sensor context, with no disease involved.
public record GenerateRecommendationRequest(
    int CropId,
    int? DiseaseAnalysisId
);

public record RecommendationResponse(
    int Id,
    int CropId,
    int? DiseaseAnalysisId,
    string Title,
    string Description,
    RiskLevel RiskLevel,
    RecommendationActionType ActionType,
    RecommendationStatus Status,
    DateTime CreatedAt
);
