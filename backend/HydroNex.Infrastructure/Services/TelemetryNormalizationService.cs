using HydroNex.Domain.Enums;

namespace HydroNex.Infrastructure.Services;

public interface ITelemetryNormalizationService
{
    decimal Normalize(SensorType sensorType, decimal value, string unit);
}

public class TelemetryNormalizationService : ITelemetryNormalizationService
{
    public decimal Normalize(
        SensorType sensorType,
        decimal value,
        string unit)
    {
        if (string.IsNullOrWhiteSpace(unit))
            return value;

        var normalizedUnit = unit.Trim().ToLowerInvariant();

        return sensorType switch
        {
            SensorType.WaterTemperature or SensorType.AirTemperature
                => NormalizeTemperature(value, normalizedUnit),

            SensorType.EC
                => NormalizeEc(value, normalizedUnit),

            SensorType.Light
                => NormalizeLight(value, normalizedUnit),

            _ => value
        };
    }

    private static decimal NormalizeTemperature(
        decimal value,
        string unit)
    {
        return unit switch
        {
            "f" or "°f" or "fahrenheit"
                => (value - 32m) * 5m / 9m,

            "k" or "kelvin"
                => value - 273.15m,

            _ => value
        };
    }

    private static decimal NormalizeEc(
        decimal value,
        string unit)
    {
        return unit switch
        {
            "us/cm" or "µs/cm" or "μs/cm"
                => value / 1000m,

            _ => value
        };
    }

    private static decimal NormalizeLight(
        decimal value,
        string unit)
    {
        return unit switch
        {
            "klux"
                => value * 1000m,

            _ => value
        };
    }
}