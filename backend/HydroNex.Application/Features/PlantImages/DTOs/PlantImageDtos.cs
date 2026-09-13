namespace HydroNex.Application.Features.PlantImages.DTOs;

public record PlantImageResponse(
    int Id,
    int CropId,
    string ImageUrl,
    DateTime CapturedAt,
    DateTime CreatedAt
);
