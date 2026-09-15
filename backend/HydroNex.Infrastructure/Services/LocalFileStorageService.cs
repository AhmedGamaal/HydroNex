using HydroNex.Application.Common.Files;
using Microsoft.Extensions.Configuration;

namespace HydroNex.Infrastructure.Services;

// Local-disk implementation. Configured via "FileStorage:RootPath" so the
// physical location can move without touching PlantImageService. Files are
// served back through app.UseStaticFiles() from wwwroot (Program.cs), so
// the relative path returned here doubles as the public URL.
public class LocalFileStorageService : IFileStorageService
{
    private static readonly string[] AllowedExtensions = { ".jpg", ".jpeg", ".png", ".webp" };

    private readonly string _rootPath;
    private readonly string _publicPrefix;

    public LocalFileStorageService(IConfiguration configuration)
    {
        var configuredRoot = configuration["FileStorage:RootPath"]
            ?? "wwwroot/uploads/plant-images";

        _rootPath = Path.Combine(
            Directory.GetCurrentDirectory(),
            configuredRoot);

        Directory.CreateDirectory(_rootPath);

        // Public URL prefix mirrors the folder structure under wwwroot.
        _publicPrefix = "/uploads/plant-images";
    }

    public async Task<string> SaveAsync(
        Stream content,
        string fileName,
        string contentType,
        CancellationToken cancellationToken = default)
    {
        var extension = Path.GetExtension(fileName).ToLowerInvariant();

        if (string.IsNullOrWhiteSpace(extension) ||
            !AllowedExtensions.Contains(extension))
        {
            throw new InvalidOperationException(
                "Unsupported file type.");
        }

        // Never trust the caller's filename/path (handoff section 21) -
        // always generate a fresh name on our own storage root.
        var storedFileName = $"{Guid.NewGuid():N}{extension}";
        var absolutePath = Path.Combine(_rootPath, storedFileName);

        await using (var fileStream = new FileStream(
            absolutePath,
            FileMode.CreateNew,
            FileAccess.Write))
        {
            await content.CopyToAsync(fileStream, cancellationToken);
        }

        return $"{_publicPrefix}/{storedFileName}";
    }

    public Task<Stream> OpenReadAsync(
        string relativePath,
        CancellationToken cancellationToken = default)
    {
        var fileName = Path.GetFileName(relativePath);
        var absolutePath = Path.Combine(_rootPath, fileName);

        if (!File.Exists(absolutePath))
            throw new FileNotFoundException("Stored image not found.", fileName);

        Stream stream = new FileStream(
            absolutePath,
            FileMode.Open,
            FileAccess.Read);

        return Task.FromResult(stream);
    }

    public Task DeleteAsync(
        string relativePath,
        CancellationToken cancellationToken = default)
    {
        var fileName = Path.GetFileName(relativePath);
        var absolutePath = Path.Combine(_rootPath, fileName);

        if (File.Exists(absolutePath))
            File.Delete(absolutePath);

        return Task.CompletedTask;
    }
}
