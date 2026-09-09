using HydroNex.Application.Features.Sensors.DTOs;

namespace HydroNex.Application.Features.Sensors;

public interface ISensorService
{
    Task<SensorResponse> CreateAsync(
        string userId,
        CreateSensorRequest request,
        CancellationToken cancellationToken = default);

    Task<List<SensorResponse>> GetByCropAsync(
        string userId,
        int cropId,
        CancellationToken cancellationToken = default);

    Task<SensorResponse?> GetByIdAsync(
        string userId,
        int sensorId,
        CancellationToken cancellationToken = default);

    Task<SensorResponse?> UpdateAsync(
        string userId,
        int sensorId,
        UpdateSensorRequest request,
        CancellationToken cancellationToken = default);

    Task<bool> DeleteAsync(
        string userId,
        int sensorId,
        CancellationToken cancellationToken = default);
}