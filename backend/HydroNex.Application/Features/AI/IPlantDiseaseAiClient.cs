using HydroNex.Application.Features.AI.DTOs;

namespace HydroNex.Application.Features.AI;

// Boundary to the external Python disease-detection service.
// ASP.NET Core never runs model inference itself (handoff Rule 5) -
// this interface is the only door into that service. Implemented in
// Infrastructure/AI/PlantDiseaseAiClient.cs using IHttpClientFactory.
public interface IPlantDiseaseAiClient
{
    Task<DiseaseDetectionAiResult> AnalyzeAsync(
        Stream imageContent,
        string fileName,
        string contentType,
        CancellationToken cancellationToken = default);
}
