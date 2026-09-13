using HydroNex.Application.Features.DiseaseAnalysis.DTOs;

namespace HydroNex.Application.Features.DiseaseAnalysis;

public interface IDiseaseAnalysisService
{
    /// <summary>
    /// Full pipeline: validate image ownership, call the Python disease AI,
    /// persist the DiseaseAnalysis, and - if significant - raise a
    /// DiseaseDetected alert and generate a follow-up recommendation
    /// (handoff sections 23, 24, 28).
    /// </summary>
    Task<DiseaseAnalysisResponse> AnalyzeAsync(
        string userId,
        AnalyzeDiseaseRequest request,
        CancellationToken cancellationToken = default);

    Task<List<DiseaseAnalysisResponse>> GetByImageAsync(
        string userId,
        int plantImageId,
        CancellationToken cancellationToken = default);

    Task<DiseaseAnalysisResponse?> GetByIdAsync(
        string userId,
        int id,
        CancellationToken cancellationToken = default);
}
