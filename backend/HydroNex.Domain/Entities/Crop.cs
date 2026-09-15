using HydroNex.Domain.Common;
using HydroNex.Domain.Enums;

namespace HydroNex.Domain.Entities;

public class Crop : BaseEntity
{
    public int FarmId { get; set; }

    public string Name { get; set; } = null!;

    public string CropType { get; set; } = null!;

    public string BatchId { get; set; } = null!;

    public string? Location { get; set; }

    public string? Notes { get; set; }

    public string? Variety { get; set; }

    public DateTime PlantingDate { get; set; }

    public int CycleDuration { get; set; }

    public DateTime? ExpectedHarvestDate { get; set; }

    public GrowthStage GrowthStage { get; set; } = GrowthStage.Seedling;

    public CropStatus Status { get; set; } = CropStatus.Active;

    public Farm Farm { get; set; } = null!;

    public ICollection<Sensor> Sensors { get; set; } = new List<Sensor>();

    public ICollection<PlantImage> PlantImages { get; set; } = new List<PlantImage>();

    public ICollection<Recommendation> Recommendations { get; set; } = new List<Recommendation>();

    public ICollection<Alert> Alerts { get; set; } = new List<Alert>();
}