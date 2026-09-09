using HydroNex.Domain.Enums;

namespace HydroNex.Application.Features.Alerts;

public interface IAlertService
{
    Task CheckSensorReadingAsync(
        int cropId,
        int sensorId,
        SensorType sensorType,
        decimal normalizedValue,
        CancellationToken cancellationToken = default);
}