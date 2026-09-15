using HydroNex.Domain.Enums;

namespace HydroNex.Application.Features.Telemetry.DTOs;

public record SensorReadingRequest(
    int SensorId,
    decimal Value,
    DateTime? RecordedAt
);

public record BulkSensorReadingRequest(
    List<SensorReadingRequest> Readings
);

public record SensorReadingResponse(
    long Id,
    int SensorId,
    int CropId,
    SensorType SensorType,
    string Unit,
    decimal Value,
    DateTime RecordedAt
);

public record LatestSensorReadingResponse(
    int SensorId,
    SensorType SensorType,
    string Unit,
    decimal Value,
    DateTime RecordedAt
);