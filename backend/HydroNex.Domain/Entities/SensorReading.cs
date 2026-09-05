using HydroNex.Domain.Common;

namespace HydroNex.Domain.Entities;

// Append-only time-series table. Never update/overwrite - every simulated or real
// reading creates a new row. Uses bigint PK (via BaseTelemetryEntity) given expected volume.
public class SensorReading : BaseTelemetryEntity
{
    public int SensorId { get; set; }
    public decimal Value { get; set; }
    public DateTime RecordedAt { get; set; } = DateTime.UtcNow;

    public Sensor Sensor { get; set; } = null!;
}
