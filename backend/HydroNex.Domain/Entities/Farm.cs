using HydroNex.Domain.Common;

namespace HydroNex.Domain.Entities;

public class Farm : BaseEntity
{
    public string UserId { get; set; } = string.Empty; // FK -> ApplicationUser.Id (string, Identity default)
    public string Name { get; set; } = string.Empty;
    public string? Location { get; set; }
    public string? Description { get; set; }

    public ApplicationUser User { get; set; } = null!;
    public ICollection<Crop> Crops { get; set; } = new List<Crop>();
}
