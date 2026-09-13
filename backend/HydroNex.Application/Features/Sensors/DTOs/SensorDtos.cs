using HydroNex.Domain.Enums;

namespace HydroNex.Application.Features.Sensors.DTOs;

public record CreateSensorRequest(
    int CropId,
    SensorType Type,
    string Unit,
    string Name,
    string? Location
);

public record UpdateSensorRequest(
    SensorType Type,
    string Unit,
    string Name,
    string? Location,
    SensorStatus Status
);

public record SensorResponse(
    int Id,
    int CropId,
    SensorType Type,
    string Unit,
    string Name,
    string? Location,
    SensorStatus Status,
    DateTime? LastSeenAt,
    DateTime CreatedAt
);