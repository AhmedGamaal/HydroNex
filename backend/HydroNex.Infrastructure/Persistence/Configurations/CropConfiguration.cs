using HydroNex.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace HydroNex.Infrastructure.Persistence.Configurations;

public class CropConfiguration : IEntityTypeConfiguration<Crop>
{
    public void Configure(EntityTypeBuilder<Crop> builder)
    {
        builder.Property(c => c.Name).IsRequired().HasMaxLength(150);
        builder.Property(c => c.CropType).IsRequired().HasMaxLength(100);
        builder.Property(c => c.Variety).HasMaxLength(100);
        builder.Property(c => c.GrowthStage).HasConversion<string>().HasMaxLength(30);
        builder.Property(c => c.Status).HasConversion<string>().HasMaxLength(30);

        builder.HasOne(c => c.Farm)
            .WithMany(f => f.Crops)
            .HasForeignKey(c => c.FarmId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(c => c.FarmId);
    }
}
