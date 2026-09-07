using HydroNex.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace HydroNex.Infrastructure.Persistence.Configurations;

public class SensorConfiguration : IEntityTypeConfiguration<Sensor>
{
    public void Configure(EntityTypeBuilder<Sensor> builder)
    {
        builder.Property(s => s.Type).HasConversion<string>().HasMaxLength(30);
        builder.Property(s => s.Unit).IsRequired().HasMaxLength(20);
        builder.Property(s => s.Name).IsRequired().HasMaxLength(100);
        builder.Property(s => s.Location).HasMaxLength(150);
        builder.Property(s => s.Status).HasConversion<string>().HasMaxLength(20);

        builder.HasOne(s => s.Crop)
            .WithMany(c => c.Sensors)
            .HasForeignKey(s => s.CropId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(s => s.CropId);
    }
}
