using HydroNex.Application.Features.Actions.DTOs;

namespace HydroNex.Application.Features.Actions;

public interface IActionService
{
    Task<ActionResponse> CreateAsync(
        string userId,
        CreateActionRequest request,
        CancellationToken cancellationToken = default);

    Task<ActionResponse?> ExecuteAsync(
        string userId,
        long actionId,
        CancellationToken cancellationToken = default);

    Task<List<ActionResponse>> GetByCropAsync(
        string userId,
        int cropId,
        CancellationToken cancellationToken = default);
}