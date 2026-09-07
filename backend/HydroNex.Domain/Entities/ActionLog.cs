using HydroNex.Domain.Common;
using HydroNex.Domain.Enums;

namespace HydroNex.Domain.Entities;

// Represents a simulated (later: real) actuator execution.
// Uses bigint PK (BaseTelemetryEntity) since this is an append-only execution history,
// same reasoning as SensorReading.
public class ActionLog : BaseTelemetryEntity
{
    public int CropId { get; set; }
    public int? RecommendationId { get; set; } // nullable: manual/system actions may not trace back to an AI recommendation
    public ActuatorActionType ActionType { get; set; }
    public string? Description { get; set; }
    public ActionStatus Status { get; set; } = ActionStatus.Pending;
    public DateTime? ExecutedAt { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public Crop Crop { get; set; } = null!;
    public Recommendation? Recommendation { get; set; }
}
