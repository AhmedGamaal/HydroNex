using HydroNex.Application.Features.Alerts;
using HydroNex.Application.Features.Telemetry;
using HydroNex.Application.Features.Telemetry.DTOs;
using HydroNex.Domain.Entities;
using HydroNex.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace HydroNex.Infrastructure.Services;

public class TelemetryService : ITelemetryService
{
    private readonly ApplicationDbContext _context;
    private readonly ITelemetryNormalizationService _normalizationService;
    private readonly IAlertService _alertService;
    private readonly ITelemetryHubPublisher _hubPublisher;

    public TelemetryService(ApplicationDbContext context, ITelemetryNormalizationService normalizationService, IAlertService alertService, ITelemetryHubPublisher hubPublisher)
    {
        _context = context;
        _normalizationService = normalizationService;
        _alertService = alertService;
        _hubPublisher = hubPublisher;

    }

    public async Task<SensorReadingResponse> AddReadingAsync(
        string userId,
        SensorReadingRequest request,
        CancellationToken cancellationToken = default)
    {
        var sensor = await _context.Sensors
            .Include(s => s.Crop)
            .ThenInclude(c => c.Farm)
            .FirstOrDefaultAsync(
                s => s.Id == request.SensorId &&
                     s.Crop.Farm.UserId == userId,
                cancellationToken);

        if (sensor is null)
            throw new KeyNotFoundException("Sensor not found.");

        var recordedAt = request.RecordedAt ?? DateTime.UtcNow;

        var reading = new SensorReading
        {
            SensorId = sensor.Id,
            Value = request.Value,
            RecordedAt = recordedAt
        };

        sensor.LastSeenAt = recordedAt;

        var normalizedValue = _normalizationService.Normalize(
        sensor.Type,
        request.Value,
        sensor.Unit);

        reading.Value = normalizedValue;

        _context.SensorReadings.Add(reading);

        await _context.SaveChangesAsync(cancellationToken);

        await _alertService.CheckSensorReadingAsync(
        sensor.CropId,
        sensor.Id,
        sensor.Type,
        normalizedValue,
        cancellationToken);

        await _hubPublisher.PublishReadingAsync(
            sensor.CropId,
            Map(reading, sensor));

        return Map(reading, sensor);
    }

    public async Task<List<SensorReadingResponse>> AddBulkReadingsAsync(
        string userId,
        BulkSensorReadingRequest request,
        CancellationToken cancellationToken = default)
    {
        if (request.Readings is null || request.Readings.Count == 0)
            return new List<SensorReadingResponse>();

        var sensorIds = request.Readings
            .Select(x => x.SensorId)
            .Distinct()
            .ToList();

        var sensors = await _context.Sensors
            .Include(s => s.Crop)
            .ThenInclude(c => c.Farm)
            .Where(s =>
                sensorIds.Contains(s.Id) &&
                s.Crop.Farm.UserId == userId)
            .ToListAsync(cancellationToken);

        if (sensors.Count != sensorIds.Count)
            throw new KeyNotFoundException(
                "One or more sensors were not found.");

        var sensorDictionary = sensors.ToDictionary(s => s.Id);

        var responses = new List<SensorReadingResponse>();

        foreach (var item in request.Readings)
        {
            var sensor = sensorDictionary[item.SensorId];

            var recordedAt = item.RecordedAt ?? DateTime.UtcNow;
            var normalizedValue = _normalizationService.Normalize(
                sensor.Type,
                item.Value,
                sensor.Unit);

            var reading = new SensorReading
            {
                SensorId = sensor.Id,
                Value = normalizedValue,
                RecordedAt = recordedAt
            };

            sensor.LastSeenAt = recordedAt;

            _context.SensorReadings.Add(reading);

            responses.Add(Map(reading, sensor));
        }

        await _context.SaveChangesAsync(cancellationToken);
        foreach (var reading in responses)
        {
            await _alertService.CheckSensorReadingAsync(
                reading.CropId,
                reading.SensorId,
                reading.SensorType,
                reading.Value,
                cancellationToken);
        }

        foreach (var reading in responses)
        {
            await _hubPublisher.PublishReadingAsync(
                reading.CropId,
                reading);
        }
        return responses;
    }

    public async Task<List<LatestSensorReadingResponse>> GetLatestByCropAsync(
        string userId,
        int cropId,
        CancellationToken cancellationToken = default)
    {
        var cropExists = await _context.Crops
            .AnyAsync(
                c => c.Id == cropId &&
                     c.Farm.UserId == userId,
                cancellationToken);

        if (!cropExists)
            throw new KeyNotFoundException("Crop not found.");

        var sensors = await _context.Sensors
            .Where(s =>
                s.CropId == cropId &&
                s.Crop.Farm.UserId == userId)
            .Include(s => s.Readings)
            .ToListAsync(cancellationToken);

        var result = sensors
            .Select(sensor =>
            {
                var latest = sensor.Readings
                    .OrderByDescending(r => r.RecordedAt)
                    .FirstOrDefault();

                if (latest is null)
                    return null;

                return new LatestSensorReadingResponse(
                    sensor.Id,
                    sensor.Type,
                    sensor.Unit,
                    latest.Value,
                    latest.RecordedAt);
            })
            .Where(x => x is not null)
            .Select(x => x!)
            .OrderBy(x => x.SensorType)
            .ToList();

        return result;
    }

    public async Task<List<SensorReadingResponse>> GetHistoryAsync(
        string userId,
        int cropId,
        DateTime? from,
        DateTime? to,
        CancellationToken cancellationToken = default)
    {
        var cropExists = await _context.Crops
            .AnyAsync(
                c => c.Id == cropId &&
                     c.Farm.UserId == userId,
                cancellationToken);

        if (!cropExists)
            throw new KeyNotFoundException("Crop not found.");

        var query = _context.SensorReadings
            .Where(r =>
                r.Sensor.CropId == cropId &&
                r.Sensor.Crop.Farm.UserId == userId);

        if (from.HasValue)
            query = query.Where(r => r.RecordedAt >= from.Value);

        if (to.HasValue)
            query = query.Where(r => r.RecordedAt <= to.Value);

        var readings = await query
            .Include(r => r.Sensor)
            .OrderByDescending(r => r.RecordedAt)
            .ToListAsync(cancellationToken);

        return readings
            .Select(r => Map(r, r.Sensor))
            .ToList();
    }

    private static SensorReadingResponse Map(
        SensorReading reading,
        Sensor sensor)
    {
        return new SensorReadingResponse(
            reading.Id,
            sensor.Id,
            sensor.CropId,
            sensor.Type,
            sensor.Unit,
            reading.Value,
            reading.RecordedAt);
    }





}