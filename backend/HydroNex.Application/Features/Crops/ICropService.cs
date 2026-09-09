using HydroNex.Application.Features.Crops.DTOs;

namespace HydroNex.Application.Features.Crops;

public interface ICropService
{
    Task<CropDetailsResponse> CreateAsync(
        string userId,
        CreateCropRequest request);

    Task<List<CropListResponse>> GetMyCropsAsync(
        string userId);

    Task<CropDetailsResponse?> GetByIdAsync(
        string userId,
        int cropId);

    Task<CropDetailsResponse> UpdateAsync(
        string userId,
        int cropId,
        UpdateCropRequest request);

    Task DeleteAsync(
        string userId,
        int cropId);
}