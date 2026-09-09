using HydroNex.Application.Features.Telemetry.DTOs;

namespace HydroNex.Application.Features.Telemetry;

public interface ITelemetryService
{
    Task<SensorReadingResponse> AddReadingAsync(
        string userId,
        SensorReadingRequest request,
        CancellationToken cancellationToken = default);

    Task<List<SensorReadingResponse>> AddBulkReadingsAsync(
        string userId,
        BulkSensorReadingRequest request,
        CancellationToken cancellationToken = default);

    Task<List<LatestSensorReadingResponse>> GetLatestByCropAsync(
        string userId,
        int cropId,
        CancellationToken cancellationToken = default);

    Task<List<SensorReadingResponse>> GetHistoryAsync(
        string userId,
        int cropId,
        DateTime? from,
        DateTime? to,
        CancellationToken cancellationToken = default);



}