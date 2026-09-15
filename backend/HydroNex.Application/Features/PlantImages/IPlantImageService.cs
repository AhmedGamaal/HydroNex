using HydroNex.Application.Features.PlantImages.DTOs;

namespace HydroNex.Application.Features.PlantImages;

public interface IPlantImageService
{
    /// <summary>
    /// Validates ownership/file type/size, stores the file, and persists
    /// a PlantImage record. Intentionally takes a raw stream rather than
    /// IFormFile so Application stays free of ASP.NET Core web types -
    /// the controller extracts these values from the uploaded file.
    /// </summary>
    Task<PlantImageResponse> UploadAsync(
        string userId,
        int cropId,
        Stream content,
        string fileName,
        string contentType,
        long length,
        CancellationToken cancellationToken = default);

    Task<List<PlantImageResponse>> GetByCropAsync(
        string userId,
        int cropId,
        CancellationToken cancellationToken = default);

    Task<PlantImageResponse?> GetByIdAsync(
        string userId,
        int imageId,
        CancellationToken cancellationToken = default);

    Task DeleteAsync(
        string userId,
        int imageId,
        CancellationToken cancellationToken = default);
}
