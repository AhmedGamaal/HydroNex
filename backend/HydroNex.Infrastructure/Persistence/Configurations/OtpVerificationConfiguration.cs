using HydroNex.Domain.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace HydroNex.Infrastructure.Persistence.Configurations;

public class OtpVerificationConfiguration
    : IEntityTypeConfiguration<OtpVerification>
{
    public void Configure(EntityTypeBuilder<OtpVerification> builder)
    {
        builder.HasKey(x => x.Id);

        builder.Property(x => x.UserId)
            .IsRequired()
            .HasMaxLength(450);

        builder.Property(x => x.Code)
            .IsRequired()
            .HasMaxLength(6);

        builder.HasIndex(x => new
        {
            x.UserId,
            x.Code,
            x.IsUsed
        });

        builder.HasOne(x => x.User)
            .WithMany()
            .HasForeignKey(x => x.UserId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}