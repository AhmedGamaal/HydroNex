using HydroNex.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace HydroNex.Infrastructure.Persistence.Configurations;

public class DiseaseAnalysisConfiguration : IEntityTypeConfiguration<DiseaseAnalysis>
{
    public void Configure(EntityTypeBuilder<DiseaseAnalysis> builder)
    {
        builder.Property(d => d.DiseaseName).IsRequired().HasMaxLength(150);
        builder.Property(d => d.ConfidenceScore).HasColumnType("decimal(5,4)"); // e.g. 0.9234
        builder.Property(d => d.AnalysisResult).HasMaxLength(2000);

        builder.HasOne(d => d.PlantImage)
            .WithMany(p => p.DiseaseAnalyses)
            .HasForeignKey(d => d.PlantImageId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(d => d.PlantImageId);
    }
}
