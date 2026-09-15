using HydroNex.Application.Features.Alerts;
using HydroNex.Application.Features.Alerts.DTOs;
using HydroNex.Application.Features.Telemetry;
using HydroNex.Domain.Entities;
using HydroNex.Domain.Enums;
using HydroNex.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace HydroNex.Infrastructure.Services;

public class AlertService : IAlertService
{
    private readonly ApplicationDbContext _context;
    private readonly ISensorThresholdService _thresholdService;
    private readonly ITelemetryHubPublisher _hubPublisher;


    public AlertService(
        ApplicationDbContext context,
        ISensorThresholdService thresholdService,
        ITelemetryHubPublisher hubPublisher)
    {
        _context = context;
        _thresholdService = thresholdService;
        _hubPublisher = hubPublisher;
    }

    public async Task CheckSensorReadingAsync(
        int cropId,
        int sensorId,
        SensorType sensorType,
        decimal normalizedValue,
        CancellationToken cancellationToken = default)
    {
        var threshold = _thresholdService.GetThreshold(sensorType);

        if (threshold is null)
            return;

        var outsideRange =
            normalizedValue < threshold.Min ||
            normalizedValue > threshold.Max;

        var existingAlert = await _context.Alerts
            .FirstOrDefaultAsync(
                a => a.CropId == cropId &&
                     a.Type == AlertType.SensorThreshold &&
                     a.Status == AlertStatus.Open &&
                     a.Message.Contains($"Sensor:{sensorId}"),
                cancellationToken);

        if (!outsideRange)
        {
            if (existingAlert is not null)
            {
                existingAlert.Status = AlertStatus.Resolved;
                existingAlert.ResolvedAt = DateTime.UtcNow;

                await _context.SaveChangesAsync(cancellationToken);
            }

            return;
        }

        if (existingAlert is not null)
            return;

        var severity = GetSeverity(
            normalizedValue,
            threshold);

        var direction =
            normalizedValue < threshold.Min
                ? "below"
                : "above";

        var alert = new Alert
        {
            CropId = cropId,
            Type = AlertType.SensorThreshold,
            Severity = severity,
            Status = AlertStatus.Open,
            Message =
                $"Sensor:{sensorId} {sensorType} is {direction} " +
                $"the safe range. Current value: {normalizedValue} " +
                $"{threshold.Unit}. Safe range: " +
                $"{threshold.Min}-{threshold.Max} {threshold.Unit}."
        };

        _context.Alerts.Add(alert);

        await _context.SaveChangesAsync(cancellationToken);

        await _hubPublisher.PublishAlertAsync(
             cropId,
             new
             {
                 alert.Id,
                 alert.CropId,
                 alert.Type,
                 alert.Message,
                 alert.Severity,
                 alert.Status,
                 alert.CreatedAt
             });
            }

    public async Task<AlertResponse> CreateAlertAsync(
        int cropId,
        AlertType type,
        AlertSeverity severity,
        string message,
        int? recommendationId,
        CancellationToken cancellationToken = default)
    {
        var alert = new Alert
        {
            CropId = cropId,
            Type = type,
            Severity = severity,
            Status = AlertStatus.Open,
            Message = message,
            RecommendationId = recommendationId
        };

        _context.Alerts.Add(alert);

        await _context.SaveChangesAsync(cancellationToken);

        // Reuse the existing "AlertCreated" event - mobile monitoring
        // already listens for it, regardless of what triggered the alert.
        await _hubPublisher.PublishAlertAsync(
            cropId,
            new
            {
                alert.Id,
                alert.CropId,
                alert.RecommendationId,
                alert.Type,
                alert.Message,
                alert.Severity,
                alert.Status,
                alert.CreatedAt
            });

        return Map(alert);
    }

    private static AlertResponse Map(Alert alert)
    {
        return new AlertResponse(
            alert.Id,
            alert.CropId,
            alert.RecommendationId,
            alert.Type,
            alert.Message,
            alert.Severity,
            alert.Status,
            alert.ResolvedAt,
            alert.CreatedAt);
    }

    private static AlertSeverity GetSeverity(
        decimal value,
        SensorThreshold threshold)
    {
        var range = threshold.Max - threshold.Min;

        if (range <= 0)
            return AlertSeverity.Warning;

        var distance =
            value < threshold.Min
                ? threshold.Min - value
                : value - threshold.Max;

        if (distance >= range)
            return AlertSeverity.Critical;

        return AlertSeverity.Warning;
    }

    public async Task<List<AlertResponse>> GetByCropAsync(
        string userId,
        int cropId,
        CancellationToken cancellationToken = default)
    {
        return await _context.Alerts
            .Where(a => a.CropId == cropId && a.Crop.Farm.UserId == userId)
            .OrderByDescending(a => a.CreatedAt)
            .Select(a => new AlertResponse(
                a.Id,
                a.CropId,
                a.RecommendationId,
                a.Type,
                a.Message,
                a.Severity,
                a.Status,
                a.ResolvedAt,
                a.CreatedAt))
            .ToListAsync(cancellationToken);
    }
}