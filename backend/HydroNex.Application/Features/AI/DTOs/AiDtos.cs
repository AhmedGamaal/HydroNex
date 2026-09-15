using HydroNex.Domain.Enums;

namespace HydroNex.Application.Features.AI.DTOs;

// --- Disease detection ---
//
// INTEGRATION POINT: the exact Python disease-detection API contract
// (request/response shape, field names) was not available in the repo at
// implementation time. This result DTO is the boundary shape the rest of
// the backend depends on; PlantDiseaseAiClient (Infrastructure/AI) is the
// only place that needs to change once the real contract is confirmed.
public record DiseaseDetectionAiResult(
    string DiseaseName,
    decimal Confidence, // 0.00 - 1.00, mapped to DiseaseAnalysis.ConfidenceScore
    string? AnalysisResult
);

// --- Recommendations ---
//
// INTEGRATION POINT: same caveat as above - Python recommendation-AI
// contract not confirmed yet. Shape mirrors Recommendation entity fields.
public record RecommendationAiResult(
    string Title,
    string Description,
    RiskLevel RiskLevel,
    RecommendationActionType ActionType
);

// --- Chat ---
//
// INTEGRATION POINT: same caveat - Python chat-AI contract not confirmed.
public record ChatAiResult(
    string Reply
);
