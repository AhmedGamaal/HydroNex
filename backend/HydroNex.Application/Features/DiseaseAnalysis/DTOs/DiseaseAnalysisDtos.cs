namespace HydroNex.Application.Features.DiseaseAnalysis.DTOs;

public record AnalyzeDiseaseRequest(
    int PlantImageId
);

// Fields match the DiseaseAnalysis entity 1:1 (no extra invented fields -
// the entity itself has no RiskLevel; that concept lives on Recommendation,
// see handoff section 24).
public record DiseaseAnalysisResponse(
    int Id,
    int PlantImageId,
    string DiseaseName,
    decimal ConfidenceScore,
    string? AnalysisResult,
    DateTime AnalyzedAt
);
