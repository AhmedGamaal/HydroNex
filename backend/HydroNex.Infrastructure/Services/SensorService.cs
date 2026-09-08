using HydroNex.Application.Features.Sensors;
using HydroNex.Application.Features.Sensors.DTOs;
using HydroNex.Domain.Entities;
using HydroNex.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace HydroNex.Infrastructure.Services;

public class SensorService : ISensorService
{
    private readonly ApplicationDbContext _context;

    public SensorService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<SensorResponse> CreateAsync(
        string userId,
        CreateSensorRequest request,
        CancellationToken cancellationToken = default)
    {
        var cropExists = await _context.Crops
            .AnyAsync(
                c => c.Id == request.CropId &&
                     c.Farm.UserId == userId,
                cancellationToken);

        if (!cropExists)
            throw new KeyNotFoundException("Crop not found.");

        var sensor = new Sensor
        {
            CropId = request.CropId,
            Type = request.Type,
            Unit = request.Unit,
            Name = request.Name,
            Location = request.Location,
            Status = Domain.Enums.SensorStatus.Active
        };

        _context.Sensors.Add(sensor);
        await _context.SaveChangesAsync(cancellationToken);

        return Map(sensor);
    }

    public async Task<List<SensorResponse>> GetByCropAsync(
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
            .Where(s => s.CropId == cropId &&
                        s.Crop.Farm.UserId == userId)
            .OrderBy(s => s.Type)
            .ToListAsync(cancellationToken);

        return sensors.Select(Map).ToList();
    }

    public async Task<SensorResponse?> GetByIdAsync(
        string userId,
        int sensorId,
        CancellationToken cancellationToken = default)
    {
        var sensor = await _context.Sensors
            .FirstOrDefaultAsync(
                s => s.Id == sensorId &&
                     s.Crop.Farm.UserId == userId,
                cancellationToken);

        return sensor is null ? null : Map(sensor);
    }

    public async Task<SensorResponse?> UpdateAsync(
        string userId,
        int sensorId,
        UpdateSensorRequest request,
        CancellationToken cancellationToken = default)
    {
        var sensor = await _context.Sensors
            .FirstOrDefaultAsync(
                s => s.Id == sensorId &&
                     s.Crop.Farm.UserId == userId,
                cancellationToken);

        if (sensor is null)
            return null;

        sensor.Type = request.Type;
        sensor.Unit = request.Unit;
        sensor.Name = request.Name;
        sensor.Location = request.Location;
        sensor.Status = request.Status;

        await _context.SaveChangesAsync(cancellationToken);

        return Map(sensor);
    }

    public async Task<bool> DeleteAsync(
        string userId,
        int sensorId,
        CancellationToken cancellationToken = default)
    {
        var sensor = await _context.Sensors
            .FirstOrDefaultAsync(
                s => s.Id == sensorId &&
                     s.Crop.Farm.UserId == userId,
                cancellationToken);

        if (sensor is null)
            return false;

        _context.Sensors.Remove(sensor);
        await _context.SaveChangesAsync(cancellationToken);

        return true;
    }

    private static SensorResponse Map(Sensor sensor)
    {
        return new SensorResponse(
            sensor.Id,
            sensor.CropId,
            sensor.Type,
            sensor.Unit,
            sensor.Name,
            sensor.Location,
            sensor.Status,
            sensor.LastSeenAt,
            sensor.CreatedAt);
    }
}