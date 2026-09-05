namespace HydroNex.Domain.Common;

public abstract class BaseEntity
{
    public int Id { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}

// Separate base for high-volume, append-only tables (SensorReading, ActionLog)
// These use a bigint PK and don't need UpdatedAt since rows are never modified after insert.
public abstract class BaseTelemetryEntity
{
    public long Id { get; set; }
}
