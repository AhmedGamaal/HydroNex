using HydroNex.Domain.Common;
using HydroNex.Domain.Enums;

namespace HydroNex.Domain.Entities;

public class Alert : BaseEntity
{
    public int CropId { get; set; }
    public int? RecommendationId { get; set; } // nullable: e.g. a raw threshold breach may alert before any recommendation exists
    public AlertType Type { get; set; }
    public string Message { get; set; } = string.Empty;
    public AlertSeverity Severity { get; set; }
    public AlertStatus Status { get; set; } = AlertStatus.Open;
    public DateTime? ResolvedAt { get; set; }

    public Crop Crop { get; set; } = null!;
    public Recommendation? Recommendation { get; set; }
}
