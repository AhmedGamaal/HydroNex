namespace HydroNex.Domain.Entities;

public class OtpVerification
{
    public int Id { get; set; }

    public string UserId { get; set; } = null!;

    public string Code { get; set; } = null!;

    public DateTime ExpiresAt { get; set; }

    public bool IsUsed { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public ApplicationUser User { get; set; } = null!;
}