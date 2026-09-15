using HydroNex.Application.Features.Recommendations.DTOs;

namespace HydroNex.Application.Features.Recommendations;

public interface IRecommendationService
{
    /// <summary>
    /// Builds crop context (sensors + optional disease analysis), calls the
    /// Python recommendation AI, persists the Recommendation, and raises an
    /// AIRecommendation alert (handoff sections 25-27).
    /// </summary>
    Task<RecommendationResponse> GenerateAsync(
        string userId,
        GenerateRecommendationRequest request,
        CancellationToken cancellationToken = default);

    Task<List<RecommendationResponse>> GetByCropAsync(
        string userId,
        int cropId,
        CancellationToken cancellationToken = default);

    Task<RecommendationResponse?> GetByIdAsync(
        string userId,
        int id,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Marks the recommendation Applied and, where the action type maps to
    /// a real actuator command, creates an ActionLog via the EXISTING
    /// IActionService (handoff section 29) - never a second action system.
    /// </summary>
    Task<RecommendationResponse> ApplyAsync(
        string userId,
        int id,
        CancellationToken cancellationToken = default);

    Task<RecommendationResponse> DismissAsync(
        string userId,
        int id,
        CancellationToken cancellationToken = default);
}
