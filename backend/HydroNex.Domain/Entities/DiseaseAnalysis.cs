using HydroNex.Domain.Common;

namespace HydroNex.Domain.Entities;

// Kept separate from PlantImage per instructions - the image never stores its own
// diagnosis directly, so re-analysis or multiple model passes stay possible later.
public class DiseaseAnalysis : BaseEntity
{
    public int PlantImageId { get; set; }
    public string DiseaseName { get; set; } = string.Empty;
    public decimal ConfidenceScore { get; set; } // 0.00 - 1.00
    public string? AnalysisResult { get; set; } // free-text/JSON summary from the CV model
    public DateTime AnalyzedAt { get; set; } = DateTime.UtcNow;

    public PlantImage PlantImage { get; set; } = null!;
    public ICollection<Recommendation> Recommendations { get; set; } = new List<Recommendation>();
}
