using HydroNex.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace HydroNex.Infrastructure.Persistence.Configurations;

public class ActionLogConfiguration : IEntityTypeConfiguration<ActionLog>
{
    public void Configure(EntityTypeBuilder<ActionLog> builder)
    {
        builder.Property(a => a.ActionType).HasConversion<string>().HasMaxLength(30);
        builder.Property(a => a.Description).HasMaxLength(500);
        builder.Property(a => a.Status).HasConversion<string>().HasMaxLength(20);

        builder.HasOne(a => a.Crop)
            .WithMany()
            .HasForeignKey(a => a.CropId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(a => a.Recommendation)
            .WithMany(r => r.ActionLogs)
            .HasForeignKey(a => a.RecommendationId)
            .OnDelete(DeleteBehavior.Restrict)
            .IsRequired(false);

        builder.HasIndex(a => new { a.CropId, a.CreatedAt });
    }
}
