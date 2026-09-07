using HydroNex.Domain.Entities;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace HydroNex.Infrastructure.Persistence;

// Extends IdentityDbContext so Identity's own tables (AspNetUsers, AspNetRoles, etc.)
// are created alongside our domain tables in the same database.
public class ApplicationDbContext : IdentityDbContext<ApplicationUser>
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options) { }

    public DbSet<Farm> Farms => Set<Farm>();
    public DbSet<Crop> Crops => Set<Crop>();
    public DbSet<Sensor> Sensors => Set<Sensor>();
    public DbSet<SensorReading> SensorReadings => Set<SensorReading>();
    public DbSet<PlantImage> PlantImages => Set<PlantImage>();
    public DbSet<DiseaseAnalysis> DiseaseAnalyses => Set<DiseaseAnalysis>();
    public DbSet<Recommendation> Recommendations => Set<Recommendation>();
    public DbSet<Alert> Alerts => Set<Alert>();
    public DbSet<ActionLog> ActionLogs => Set<ActionLog>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder); // required first - sets up Identity's own tables

        builder.ApplyConfigurationsFromAssembly(typeof(ApplicationDbContext).Assembly);
    }
}
