namespace HydroNex.Application.Common.Files;

// Abstraction over "where uploaded files physically live".
// PlantImageService depends only on this - swapping local disk for
// Azure Blob / S3 / Cloudinary later requires a new implementation only,
// no changes to business logic. See handoff section 41.
public interface IFileStorageService
{
    /// <summary>
    /// Saves the given content stream and returns a relative URL/path
    /// that can be persisted on the entity (e.g. PlantImage.ImageUrl)
    /// and served back to clients.
    /// </summary>
    Task<string> SaveAsync(
        Stream content,
        string fileName,
        string contentType,
        CancellationToken cancellationToken = default);

    /// <summary>
    /// Opens a previously-saved file for reading, given the relative
    /// path/URL that SaveAsync returned.
    /// </summary>
    Task<Stream> OpenReadAsync(
        string relativePath,
        CancellationToken cancellationToken = default);

    Task DeleteAsync(
        string relativePath,
        CancellationToken cancellationToken = default);
}
