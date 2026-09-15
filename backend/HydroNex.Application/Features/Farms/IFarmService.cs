using HydroNex.Application.Features.Farms.DTOs;

namespace HydroNex.Application.Features.Farms;

public interface IFarmService
{
    Task<FarmResponse> CreateAsync(
        string userId,
        CreateFarmRequest request);

    Task<List<FarmResponse>> GetMyFarmsAsync(
        string userId);

    Task<FarmResponse?> GetByIdAsync(
        string userId,
        int farmId);

    Task<FarmResponse> UpdateAsync(
        string userId,
        int farmId,
        UpdateFarmRequest request);

    Task DeleteAsync(
        string userId,
        int farmId);
}