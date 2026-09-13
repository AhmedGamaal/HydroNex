using HydroNex.Application.Features.AI.DTOs;
using HydroNex.Application.Features.CropContext.DTOs;

namespace HydroNex.Application.Features.AI;

// Boundary to the external Python recommendation-intelligence service.
public interface IRecommendationAiClient
{
    Task<RecommendationAiResult> GenerateAsync(
        CropContextDto context,
        CancellationToken cancellationToken = default);
}
