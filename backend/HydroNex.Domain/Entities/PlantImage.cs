using HydroNex.Domain.Common;

namespace HydroNex.Domain.Entities;

public class PlantImage : BaseEntity
{
    public int CropId { get; set; }
    public string ImageUrl { get; set; } = string.Empty;
    public DateTime CapturedAt { get; set; } = DateTime.UtcNow;

    public Crop Crop { get; set; } = null!;
    // 1 -> N: an image could in principle be re-analyzed; kept as a collection rather
    // than 1:1 so a re-run doesn't require deleting history (see DiseaseAnalysis).
    public ICollection<DiseaseAnalysis> DiseaseAnalyses { get; set; } = new List<DiseaseAnalysis>();
}
