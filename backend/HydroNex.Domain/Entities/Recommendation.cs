using HydroNex.Domain.Common;
using HydroNex.Domain.Enums;

namespace HydroNex.Domain.Entities;

public class Recommendation : BaseEntity
{
    public int CropId { get; set; }
    public int? DiseaseAnalysisId { get; set; } // nullable: sensor-only recommendations are valid
    public string Title { get; set; } = string.Empty;
    public string Description { get; set; } = string.Empty;
    public RiskLevel RiskLevel { get; set; }
    public RecommendationActionType ActionType { get; set; }
    public RecommendationStatus Status { get; set; } = RecommendationStatus.Pending;

    public Crop Crop { get; set; } = null!;
    public DiseaseAnalysis? DiseaseAnalysis { get; set; }
    public ICollection<Alert> Alerts { get; set; } = new List<Alert>();
    public ICollection<ActionLog> ActionLogs { get; set; } = new List<ActionLog>();
}
