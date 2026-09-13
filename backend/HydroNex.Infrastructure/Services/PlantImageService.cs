using HydroNex.Application.Common.Files;
using HydroNex.Application.Features.PlantImages;
using HydroNex.Application.Features.PlantImages.DTOs;
using HydroNex.Domain.Entities;
using HydroNex.Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace HydroNex.Infrastructure.Services;

public class PlantImageService : IPlantImageService
{
    // Business rule, explicit rather than implied: 8 MB per image is
    // generous for a phone photo of a leaf while keeping uploads fast.
    private const long MaxFileSizeBytes = 8 * 1024 * 1024;

    private static readonly string[] AllowedContentTypes =
    {
        "image/jpeg",
        "image/png",
        "image/webp"
    };

    private readonly ApplicationDbContext _db;
    private readonly IFileStorageService _fileStorage;

    public PlantImageService(
        ApplicationDbContext db,
        IFileStorageService fileStorage)
    {
        _db = db;
        _fileStorage = fileStorage;
    }

    public async Task<PlantImageResponse> UploadAsync(
        string userId,
        int cropId,
        Stream content,
        string fileName,
        string contentType,
        long length,
        CancellationToken cancellationToken = default)
    {
        var cropExists = await _db.Crops
            .AnyAsync(
                c => c.Id == cropId && c.Farm.UserId == userId,
                cancellationToken);

        if (!cropExists)
            throw new InvalidOperationException("Crop not found.");

        if (length <= 0)
            throw new InvalidOperationException("Empty file.");

        if (length > MaxFileSizeBytes)
            throw new InvalidOperationException(
                "Image exceeds the 8 MB size limit.");

        if (!AllowedContentTypes.Contains(contentType.ToLowerInvariant()))
            throw new InvalidOperationException(
                "Unsupported file type. Allowed: JPEG, PNG, WEBP.");

        var imageUrl = await _fileStorage.SaveAsync(
            content,
            fileName,
            contentType,
            cancellationToken);

        var plantImage = new PlantImage
        {
            CropId = cropId,
            ImageUrl = imageUrl,
            CapturedAt = DateTime.UtcNow
        };

        _db.PlantImages.Add(plantImage);

        await _db.SaveChangesAsync(cancellationToken);

        return Map(plantImage);
    }

    public async Task<List<PlantImageResponse>> GetByCropAsync(
        string userId,
        int cropId,
        CancellationToken cancellationToken = default)
    {
        return await _db.PlantImages
            .Where(p =>
                p.CropId == cropId &&
                p.Crop.Farm.UserId == userId)
            .OrderByDescending(p => p.CapturedAt)
            .Select(p => new PlantImageResponse(
                p.Id,
                p.CropId,
                p.ImageUrl,
                p.CapturedAt,
                p.CreatedAt))
            .ToListAsync(cancellationToken);
    }

    public async Task<PlantImageResponse?> GetByIdAsync(
        string userId,
        int imageId,
        CancellationToken cancellationToken = default)
    {
        var image = await _db.PlantImages
            .FirstOrDefaultAsync(
                p => p.Id == imageId && p.Crop.Farm.UserId == userId,
                cancellationToken);

        return image is null ? null : Map(image);
    }

    public async Task DeleteAsync(
        string userId,
        int imageId,
        CancellationToken cancellationToken = default)
    {
        var image = await _db.PlantImages
            .FirstOrDefaultAsync(
                p => p.Id == imageId && p.Crop.Farm.UserId == userId,
                cancellationToken);

        if (image is null)
            throw new InvalidOperationException("Plant image not found.");

        await _fileStorage.DeleteAsync(image.ImageUrl, cancellationToken);

        _db.PlantImages.Remove(image);

        await _db.SaveChangesAsync(cancellationToken);
    }

    private static PlantImageResponse Map(PlantImage image)
    {
        return new PlantImageResponse(
            image.Id,
            image.CropId,
            image.ImageUrl,
            image.CapturedAt,
            image.CreatedAt);
    }
}
