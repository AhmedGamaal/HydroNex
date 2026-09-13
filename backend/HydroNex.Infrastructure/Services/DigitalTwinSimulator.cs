using HydroNex.Application.Features.Telemetry;
using HydroNex.Application.Features.Telemetry.DTOs;
using HydroNex.Domain.Enums;
using HydroNex.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;

namespace HydroNex.Infrastructure.Services;

public class DigitalTwinSimulator : BackgroundService
{
    private readonly IServiceScopeFactory _scopeFactory;
    private readonly ILogger<DigitalTwinSimulator> _logger;

    public DigitalTwinSimulator(
        IServiceScopeFactory scopeFactory,
        ILogger<DigitalTwinSimulator> logger)
    {
        _scopeFactory = scopeFactory;
        _logger = logger;
    }

    protected override async Task ExecuteAsync(
        CancellationToken stoppingToken)
    {
        _logger.LogInformation(
            "Digital Twin Simulator started.");

        while (!stoppingToken.IsCancellationRequested)
        {
            try
            {
                await GenerateReadingsAsync(stoppingToken);
            }
            catch (OperationCanceledException)
                when (stoppingToken.IsCancellationRequested)
            {
                break;
            }
            catch (Exception ex)
            {
                _logger.LogError(
                    ex,
                    "Error while generating digital twin readings.");
            }

            try
            {
                await Task.Delay(
                    TimeSpan.FromSeconds(10),
                    stoppingToken);
            }
            catch (OperationCanceledException)
                when (stoppingToken.IsCancellationRequested)
            {
                break;
            }
        }

        _logger.LogInformation(
            "Digital Twin Simulator stopped.");
    }

    private async Task GenerateReadingsAsync(
        CancellationToken cancellationToken)
    {
        using var scope = _scopeFactory.CreateScope();

        var context = scope.ServiceProvider
            .GetRequiredService<ApplicationDbContext>();

        var telemetryService = scope.ServiceProvider
            .GetRequiredService<ITelemetryService>();

        var sensors = await context.Sensors
            .Include(s => s.Crop)
            .ThenInclude(c => c.Farm)
            .AsNoTracking()
            .Where(s => s.Status == SensorStatus.Active)
            .ToListAsync(cancellationToken);

        foreach (var sensor in sensors)
        {
            var value = GenerateValue(sensor.Type);

            await telemetryService.AddReadingAsync(
                sensor.Crop.Farm.UserId,
                new SensorReadingRequest(
                    sensor.Id,
                    value,
                    DateTime.UtcNow),
                cancellationToken);
        }

        _logger.LogInformation(
            "Generated {Count} simulated sensor readings.",
            sensors.Count);
    }

    private static decimal GenerateValue(
        SensorType sensorType)
    {
        return sensorType switch
        {
            SensorType.PH =>
                Random.Shared.Next(50, 71) / 10m,

            SensorType.EC =>
                Random.Shared.Next(10, 31) / 10m,

            SensorType.WaterTemperature =>
                Random.Shared.Next(180, 241) / 10m,

            SensorType.AirTemperature =>
                Random.Shared.Next(180, 301) / 10m,

            SensorType.Humidity =>
                Random.Shared.Next(40, 81),

            SensorType.WaterLevel =>
                Random.Shared.Next(20, 101),

            SensorType.CO2 =>
                Random.Shared.Next(400, 1501),

            SensorType.Light =>
                Random.Shared.Next(1000, 30001),

            _ => 0m
        };
    }
}