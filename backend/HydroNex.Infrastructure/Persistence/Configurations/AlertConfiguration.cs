using HydroNex.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace HydroNex.Infrastructure.Persistence.Configurations;

public class AlertConfiguration : IEntityTypeConfiguration<Alert>
{
    public void Configure(EntityTypeBuilder<Alert> builder)
    {
        builder.Property(a => a.Type).HasConversion<string>().HasMaxLength(30);
        builder.Property(a => a.Message).IsRequired().HasMaxLength(500);
        builder.Property(a => a.Severity).HasConversion<string>().HasMaxLength(20);
        builder.Property(a => a.Status).HasConversion<string>().HasMaxLength(20);

        builder.HasOne(a => a.Crop)
            .WithMany(c => c.Alerts)
            .HasForeignKey(a => a.CropId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasOne(a => a.Recommendation)
            .WithMany(r => r.Alerts)
            .HasForeignKey(a => a.RecommendationId)
            .OnDelete(DeleteBehavior.Restrict)
            .IsRequired(false);

        builder.HasIndex(a => a.CropId);
        builder.HasIndex(a => a.Status); // for "get open alerts" queries
    }
}
