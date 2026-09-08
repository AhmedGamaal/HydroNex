using HydroNex.Application.Features.Auth;
using HydroNex.Application.Features.Crops;
using HydroNex.Application.Features.Dashboard;
using HydroNex.Application.Features.Farms;
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
                configuration.GetConnectionString(
                    "DefaultConnection")));
        services.AddScoped<IAuthService, AuthService>();
        services.AddScoped<ICropService, CropService>();
        services.AddScoped<IFarmService, FarmService>();
        services.AddScoped<IDashboardService, DashboardService>();

        return services;
    }
}