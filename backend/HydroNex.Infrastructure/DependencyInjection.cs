using HydroNex.Application.Common;
using HydroNex.Application.Common.Files;
using HydroNex.Application.Features.Actions;
using HydroNex.Application.Features.AI;
using HydroNex.Application.Features.Alerts;
using HydroNex.Application.Features.Auth;
using HydroNex.Application.Features.Chat;
using HydroNex.Application.Features.CropContext;
using HydroNex.Application.Features.Crops;
using HydroNex.Application.Features.Dashboard;
using HydroNex.Application.Features.DiseaseAnalysis;
using HydroNex.Application.Features.Farms;
using HydroNex.Application.Features.PlantImages;
using HydroNex.Application.Features.Recommendations;
using HydroNex.Application.Features.Sensors;
using HydroNex.Application.Features.Telemetry;
using HydroNex.Infrastructure.AI;
using HydroNex.Infrastructure.Persistence;
using HydroNex.Infrastructure.Services;
using HydroNex.Infrastructure.Settings;
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

        // --- Developer 3 ---

        services.AddScoped<IFileStorageService, LocalFileStorageService>();
        services.AddScoped<IPlantImageService, PlantImageService>();

        services.AddScoped<ICropContextService, CropContextService>();

        services.AddScoped<IDiseaseAnalysisService, DiseaseAnalysisService>();
        services.AddScoped<IRecommendationService, RecommendationService>();
        services.AddScoped<IChatService, ChatService>();

        // AI clients: named HttpClients configured from the "AI" section
        // in appsettings (no hard-coded URLs - handoff Rule 6).
        var aiSection = configuration.GetSection("AI");

        services.AddHttpClient("DiseaseAI", client =>
        {
            client.BaseAddress = new Uri(aiSection["DiseaseApiUrl"] ?? "http://localhost:9001/");
            client.Timeout = TimeSpan.FromSeconds(30);
        });

        services.AddHttpClient("RecommendationAI", client =>
        {
            client.BaseAddress = new Uri(aiSection["RecommendationApiUrl"] ?? "http://localhost:9002/");
            client.Timeout = TimeSpan.FromSeconds(15);

            var recommendationApiKey = aiSection["RecommendationApiKey"];
            if (!string.IsNullOrWhiteSpace(recommendationApiKey))
                client.DefaultRequestHeaders.Add("X-Api-Key", recommendationApiKey);
        });

        services.AddHttpClient("ChatAI", client =>
        {
            client.BaseAddress = new Uri(aiSection["ChatApiUrl"] ?? "http://localhost:9003/");
            client.Timeout = TimeSpan.FromSeconds(20);
        });

        services.AddScoped<IPlantDiseaseAiClient, PlantDiseaseAiClient>();
        services.AddScoped<IRecommendationAiClient, RecommendationAiClient>();
        services.AddScoped<IChatAiClient, ChatAiClient>();

        services.Configure<EmailSettings>(
        configuration.GetSection("EmailSettings"));

        services.AddScoped<IEmailService, EmailService>();


        return services;
    }
}