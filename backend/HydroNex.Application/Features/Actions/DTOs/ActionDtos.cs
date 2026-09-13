using HydroNex.Domain.Enums;

namespace HydroNex.Application.Features.Actions.DTOs;

public record CreateActionRequest(
    int CropId,
    int? RecommendationId,
    ActuatorActionType ActionType,
    string? Description
);

public record ActionResponse(
    long Id,
    int CropId,
    int? RecommendationId,
    ActuatorActionType ActionType,
    string? Description,
    ActionStatus Status,
    DateTime? ExecutedAt,
    DateTime CreatedAt
);