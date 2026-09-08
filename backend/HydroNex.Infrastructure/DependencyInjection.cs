using HydroNex.Application.Features.Actions;
using HydroNex.Application.Features.Alerts;
using HydroNex.Application.Features.Auth;
using HydroNex.Application.Features.Crops;
using HydroNex.Application.Features.Dashboard;
using HydroNex.Application.Features.Farms;
using HydroNex.Application.Features.Sensors;
using HydroNex.Application.Features.Telemetry;
using HydroNex.Infrastructure.Persistence;
using HydroNex.Infrastructure.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace HydroNex.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructure(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        services.AddDbContext<ApplicationDbContext>(options =>
            options.UseSqlServer(
                configuration.GetConnectionString("DefaultConnection")));

        services.AddScoped<IAuthService, AuthService>();
        services.AddScoped<ICropService, CropService>();
        services.AddScoped<IFarmService, FarmService>();
        services.AddScoped<IDashboardService, DashboardService>();

        services.AddScoped<ISensorService, SensorService>();

        services.AddScoped<ITelemetryService, TelemetryService>();
        services.AddScoped<
            ITelemetryNormalizationService,
            TelemetryNormalizationService>();

        services.AddScoped<
            ISensorThresholdService,
            SensorThresholdService>();

        services.AddScoped<IAlertService, AlertService>();

        services.AddScoped<IActionService, ActionService>();

        return services;
    }
}