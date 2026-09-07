using HydroNex.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace HydroNex.Infrastructure.Persistence.Configurations;

public class FarmConfiguration : IEntityTypeConfiguration<Farm>
{
    public void Configure(EntityTypeBuilder<Farm> builder)
    {
        builder.Property(f => f.Name).IsRequired().HasMaxLength(150);
        builder.Property(f => f.Location).HasMaxLength(250);
        builder.Property(f => f.Description).HasMaxLength(1000);

        builder.HasOne(f => f.User)
            .WithMany(u => u.Farms)
            .HasForeignKey(f => f.UserId)
            .OnDelete(DeleteBehavior.Cascade);

        builder.HasIndex(f => f.UserId);
    }
}
