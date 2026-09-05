using HydroNex.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace HydroNex.Infrastructure.Persistence.Configurations;

public class SensorReadingConfiguration : IEntityTypeConfiguration<SensorReading>
{
    public void Configure(EntityTypeBuilder<SensorReading> builder)
    {
        // Precision for sensor values (pH, EC, temp, etc.) - 2 decimal places is enough
        // for all listed sensor types and keeps storage compact given expected volume.
        builder.Property(r => r.Value).HasColumnType("decimal(9,2)");

        builder.HasOne(r => r.Sensor)
            .WithMany(s => s.Readings)
            .HasForeignKey(r => r.SensorId)
            .OnDelete(DeleteBehavior.Cascade);

        // Composite index supporting "get latest readings for this sensor/crop" queries.
        // Descending on RecordedAt so the most recent rows are found fast without a full scan.
        builder.HasIndex(r => new { r.SensorId, r.RecordedAt })
            .IsDescending(false, true);
    }
}
