using Microsoft.AspNetCore.Identity;

namespace HydroNex.Domain.Entities;

// Extends IdentityUser directly rather than a separate custom Users table + linked profile.
// Pragmatic choice for MVP timeline: Identity already provides Id (string/GUID), Email,
// PasswordHash, etc. We only add the domain-specific fields we actually need.
public class ApplicationUser : IdentityUser
{
    public string FullName { get; set; } = string.Empty;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public ICollection<Farm> Farms { get; set; } = new List<Farm>();
}
