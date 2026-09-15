using HydroNex.Domain.Enums;

namespace HydroNex.Infrastructure.Services;

public record SensorThreshold(
    decimal Min,
    decimal Max,
    AlertSeverity Severity,
    string Unit);

public interface ISensorThresholdService
{
    SensorThreshold? GetThreshold(SensorType sensorType);

    bool IsOutsideRange(
        SensorType sensorType,
        decimal normalizedValue);
}

public class SensorThresholdService : ISensorThresholdService
{
    private static readonly Dictionary<SensorType, SensorThreshold> Thresholds = new()
    {
        [SensorType.PH] = new(
            5.5m,
            6.5m,
            AlertSeverity.Warning,
            "pH"),

        [SensorType.EC] = new(
            1.0m,
            3.0m,
            AlertSeverity.Warning,
            "mS/cm"),

        [SensorType.WaterTemperature] = new(
            18m,
            24m,
            AlertSeverity.Warning,
            "°C"),

        [SensorType.AirTemperature] = new(
            18m,
            30m,
            AlertSeverity.Warning,
            "°C"),

        [SensorType.Humidity] = new(
            40m,
            80m,
            AlertSeverity.Warning,
            "%"),

        [SensorType.CO2] = new(
            400m,
            1500m,
            AlertSeverity.Warning,
            "ppm"),

        [SensorType.WaterLevel] = new(
            20m,
            100m,
            AlertSeverity.Warning,
            "%"),

        [SensorType.Light] = new(
            1000m,
            30000m,
            AlertSeverity.Warning,
            "lux")
    };

    public SensorThreshold? GetThreshold(
        SensorType sensorType)
    {
        return Thresholds.TryGetValue(
            sensorType,
            out var threshold)
            ? threshold
            : null;
    }

    public bool IsOutsideRange(
        SensorType sensorType,
        decimal normalizedValue)
    {
        var threshold = GetThreshold(sensorType);

        if (threshold is null)
            return false;

        return normalizedValue < threshold.Min ||
               normalizedValue > threshold.Max;
    }
}