using HydroNex.Domain.Common;
using HydroNex.Domain.Enums;

namespace HydroNex.Domain.Entities;

// Represents both real and simulated sensors - identical either way from the backend's
// perspective. The virtual simulator creates/reads these exactly as a real ESP32 would.
public class Sensor : BaseEntity
{
    public int CropId { get; set; }
    public SensorType Type { get; set; }
    public string Unit { get; set; } = string.Empty;
    public string Name { get; set; } = string.Empty;
    public string? Location { get; set; }
    public SensorStatus Status { get; set; } = SensorStatus.Active;
    public DateTime? LastSeenAt { get; set; }

    public Crop Crop { get; set; } = null!;
    public ICollection<SensorReading> Readings { get; set; } = new List<SensorReading>();
}
