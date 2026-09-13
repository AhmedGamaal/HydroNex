using HydroNex.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace HydroNex.Infrastructure.Persistence.Configurations;

public class CropConfiguration : IEntityTypeConfiguration<Crop>
{
    public void Configure(EntityTypeBuilder<Crop> builder)
    {
        builder.HasKey(x => x.Id);

        builder.Property(x => x.Name)
            .IsRequired()
            .HasMaxLength(150);

        builder.Property(x => x.CropType)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(x => x.BatchId)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(x => x.Location)
            .HasMaxLength(250);

        builder.Property(x => x.Notes)
            .HasMaxLength(1000);

        builder.Property(x => x.Variety)
            .HasMaxLength(100);

        builder.Property(x => x.CycleDuration)
            .IsRequired();

        builder.HasIndex(x => new
        {
            x.FarmId,
            x.BatchId
        })
        .IsUnique();

        builder.HasOne(x => x.Farm)
            .WithMany(x => x.Crops)
            .HasForeignKey(x => x.FarmId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}