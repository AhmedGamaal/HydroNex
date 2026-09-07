using HydroNex.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace HydroNex.Infrastructure.Persistence.Configurations;

public class RecommendationConfiguration : IEntityTypeConfiguration<Recommendation>
{
    public void Configure(EntityTypeBuilder<Recommendation> builder)
    {
        builder.Property(r => r.Title).IsRequired().HasMaxLength(200);
        builder.Property(r => r.Description).IsRequired().HasMaxLength(2000);
        builder.Property(r => r.RiskLevel).HasConversion<string>().HasMaxLength(20);
        builder.Property(r => r.ActionType).HasConversion<string>().HasMaxLength(30);
        builder.Property(r => r.Status).HasConversion<string>().HasMaxLength(20);

        builder.HasOne(r => r.Crop)
            .WithMany(c => c.Recommendations)
            .HasForeignKey(r => r.CropId)
            .OnDelete(DeleteBehavior.Cascade);

        // Optional link - if a DiseaseAnalysis is deleted, don't cascade-delete the
        // Recommendation (it may still be actionable/historical). Restrict instead.
        builder.HasOne(r => r.DiseaseAnalysis)
            .WithMany(d => d.Recommendations)
            .HasForeignKey(r => r.DiseaseAnalysisId)
            .OnDelete(DeleteBehavior.Restrict)
            .IsRequired(false);

        builder.HasIndex(r => r.CropId);
    }
}
