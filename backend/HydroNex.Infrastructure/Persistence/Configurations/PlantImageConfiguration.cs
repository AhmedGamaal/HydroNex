using HydroNex.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace HydroNex.Infrastructure.Persistence.Configurations;

public class PlantImageConfiguration : IEntityTypeConfiguration<PlantImage>
{
    public void Configure(EntityTypeBuilder<PlantImage> builder)
    {
        builder.Property(p => p.ImageUrl).IsRequired().HasMaxLength(500);

        builder.HasOne(p => p.Crop)
            .WithMany(c => c.PlantImages)
            .HasForeignKey(p => p.CropId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(p => p.CropId);
    }
}
