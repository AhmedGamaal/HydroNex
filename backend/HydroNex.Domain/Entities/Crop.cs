using HydroNex.Domain.Common;
using HydroNex.Domain.Enums;

namespace HydroNex.Domain.Entities;

// No separate "Field" entity: a Farm containing multiple Crops directly is sufficient
// for the MVP. A Field abstraction would only matter if a single physical area needed
// to host multiple concurrent crops with independent sensor sets sharing infrastructure -
// not a requirement here, so it's deliberately left out.
public class Crop : BaseEntity
{
    public int FarmId { get; set; }
    public string Name { get; set; } = string.Empty;
    public string CropType { get; set; } = string.Empty;
    public string? Variety { get; set; }
    public DateTime PlantingDate { get; set; }
    public DateTime? ExpectedHarvestDate { get; set; }
    public GrowthStage GrowthStage { get; set; } = GrowthStage.Seedling;
    public CropStatus Status { get; set; } = CropStatus.Active;

    public Farm Farm { get; set; } = null!;
    public ICollection<Sensor> Sensors { get; set; } = new List<Sensor>();
    public ICollection<PlantImage> PlantImages { get; set; } = new List<PlantImage>();
    public ICollection<Recommendation> Recommendations { get; set; } = new List<Recommendation>();
    public ICollection<Alert> Alerts { get; set; } = new List<Alert>();
}
