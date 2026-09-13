using HydroNex.Application.Features.Actions;
using HydroNex.Application.Features.Actions.DTOs;
using HydroNex.Domain.Entities;
using HydroNex.Domain.Enums;
using HydroNex.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace HydroNex.Infrastructure.Services;

public class ActionService : IActionService
{
    private readonly ApplicationDbContext _db;

    public ActionService(ApplicationDbContext db)
    {
        _db = db;
    }

    public async Task<ActionResponse> CreateAsync(
        string userId,
        CreateActionRequest request,
        CancellationToken cancellationToken = default)
    {
        var cropExists = await _db.Crops
            .AnyAsync(
                c =>
                    c.Id == request.CropId &&
                    c.Farm.UserId == userId,
                cancellationToken);

        if (!cropExists)
            throw new InvalidOperationException(
                "Crop not found.");

        if (request.RecommendationId.HasValue)
        {
            var recommendationExists = await _db.Recommendations
                .AnyAsync(
                    r =>
                        r.Id == request.RecommendationId.Value &&
                        r.CropId == request.CropId,
                        cancellationToken);

            if (!recommendationExists)
                throw new InvalidOperationException(
                    "Recommendation not found.");
        }

        var action = new ActionLog
        {
            CropId = request.CropId,
            RecommendationId = request.RecommendationId,
            ActionType = request.ActionType,
            Description = request.Description?.Trim(),
            Status = ActionStatus.Pending,
            CreatedAt = DateTime.UtcNow
        };

        _db.ActionLogs.Add(action);

        await _db.SaveChangesAsync(cancellationToken);

        return Map(action);
    }

    public async Task<ActionResponse?> ExecuteAsync(
        string userId,
        long actionId,
        CancellationToken cancellationToken = default)
    {
        var action = await _db.ActionLogs
            .Include(a => a.Crop)
                .ThenInclude(c => c.Farm)
            .FirstOrDefaultAsync(
                a =>
                    a.Id == actionId &&
                    a.Crop.Farm.UserId == userId,
                cancellationToken);

        if (action is null)
            return null;

        if (action.Status == ActionStatus.Executed)
            return Map(action);

        if (action.Status == ActionStatus.Cancelled)
            throw new InvalidOperationException(
                "Cancelled action cannot be executed.");

        action.Status = ActionStatus.Executed;
        action.ExecutedAt = DateTime.UtcNow;

        await _db.SaveChangesAsync(cancellationToken);

        return Map(action);
    }

    public async Task<List<ActionResponse>> GetByCropAsync(
        string userId,
        int cropId,
        CancellationToken cancellationToken = default)
    {
        return await _db.ActionLogs
            .Where(
                a =>
                    a.CropId == cropId &&
                    a.Crop.Farm.UserId == userId)
            .OrderByDescending(a => a.CreatedAt)
            .Select(
                a => new ActionResponse(
                    a.Id,
                    a.CropId,
                    a.RecommendationId,
                    a.ActionType,
                    a.Description,
                    a.Status,
                    a.ExecutedAt,
                    a.CreatedAt))
            .ToListAsync(cancellationToken);
    }

    private static ActionResponse Map(ActionLog action)
    {
        return new ActionResponse(
            action.Id,
            action.CropId,
            action.RecommendationId,
            action.ActionType,
            action.Description,
            action.Status,
            action.ExecutedAt,
            action.CreatedAt);
    }
}