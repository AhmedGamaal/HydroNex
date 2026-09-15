using HydroNex.Application.Features.CropContext.DTOs;

namespace HydroNex.Application.Features.CropContext;

// Builds the normalized AI context for a crop by composing the EXISTING
// telemetry/disease/recommendation services - it never queries sensor
// tables directly (handoff section 31: "do not create another sensor
// system"). Both RecommendationService and ChatService depend on this
// instead of duplicating context-gathering logic.
public interface ICropContextService
{
    Task<CropContextDto> BuildContextAsync(
        string userId,
        int cropId,
        CancellationToken cancellationToken = default);
}
