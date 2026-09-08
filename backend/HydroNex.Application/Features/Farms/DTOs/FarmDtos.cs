namespace HydroNex.Application.Features.Farms.DTOs;

public record CreateFarmRequest(
    string Name,
    string? Location,
    string? Description
);

public record UpdateFarmRequest(
    string Name,
    string? Location,
    string? Description
);

public record FarmResponse(
    int Id,
    string Name,
    string? Location,
    string? Description,
    int CropCount,
    DateTime CreatedAt
);