using HydroNex.Domain.Enums;

namespace HydroNex.Application.Features.Alerts.DTOs;

public record AlertResponse(
    int Id,
    int CropId,
    int? RecommendationId,
    AlertType Type,
    string Message,
    AlertSeverity Severity,
    AlertStatus Status,
    DateTime? ResolvedAt,
    DateTime CreatedAt
);
