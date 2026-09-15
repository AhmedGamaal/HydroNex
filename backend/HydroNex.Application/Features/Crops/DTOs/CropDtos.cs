using HydroNex.Domain.Enums;

namespace HydroNex.Application.Features.Crops.DTOs;

public record CreateCropRequest(
    int FarmId,
    string CropType,
    string BatchId,
    string? Location,
    string? Notes,
    string? Variety,
    DateTime PlantingDate,
    int CycleDuration
);

public record UpdateCropRequest(
    string CropType,
    string BatchId,
    string? Location,
    string? Notes,
    string? Variety,
    DateTime PlantingDate,
    int CycleDuration,
    GrowthStage GrowthStage,
    CropStatus Status
);

public record CropListResponse(
    int Id,
    string Name,
    string CropType,
    string BatchId,
    string? Location,
    GrowthStage GrowthStage,
    CropStatus Status,
    DateTime PlantingDate,
    int CycleDuration,
    int CurrentDay,
    int ProgressPercentage
);

public record CropDetailsResponse(
    int Id,
    string Name,
    string CropType,
    string BatchId,
    string? Location,
    string? Notes,
    string? Variety,
    DateTime PlantingDate,
    int CycleDuration,
    DateTime? ExpectedHarvestDate,
    GrowthStage GrowthStage,
    CropStatus Status,
    int CurrentDay,
    int ProgressPercentage
);