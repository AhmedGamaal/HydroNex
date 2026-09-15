using HydroNex.Application.Features.Alerts.DTOs;
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

    // Additive for Developer 3: a generic way to raise Alerts from the
    // Disease/Recommendation pipelines, reusing the exact same Alert
    // entity + SignalR "AlertCreated" event that threshold alerts already
    // use (handoff Rule 3: do NOT create a second alert system).
    Task<AlertResponse> CreateAlertAsync(
        int cropId,
        AlertType type,
        AlertSeverity severity,
        string message,
        int? recommendationId,
        CancellationToken cancellationToken = default);

    // Added so the Alerts screen has something to call - was missing
    // entirely (IAlertService previously had write methods only).
    Task<List<AlertResponse>> GetByCropAsync(
        string userId,
        int cropId,
        CancellationToken cancellationToken = default);
}