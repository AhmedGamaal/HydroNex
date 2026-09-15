using System.Net.Http.Json;
using HydroNex.Application.Common.Exceptions;
using HydroNex.Application.Features.AI;
using HydroNex.Application.Features.AI.DTOs;

namespace HydroNex.Infrastructure.AI;

// INTEGRATION POINT (handoff Rule 7/8): the real Python disease-detection
// contract was not available in the repo/docs at implementation time.
// The request below (multipart form, field name "image") and response
// shape (DiseaseAiResponseDto) are a reasonable placeholder guess only -
// update BOTH when the actual contract is confirmed. Nothing outside this
// class needs to change; callers only see IPlantDiseaseAiClient.
public class PlantDiseaseAiClient : IPlantDiseaseAiClient
{
    private readonly HttpClient _httpClient;

    public PlantDiseaseAiClient(IHttpClientFactory httpClientFactory)
    {
        _httpClient = httpClientFactory.CreateClient("DiseaseAI");
    }

    public async Task<DiseaseDetectionAiResult> AnalyzeAsync(
        Stream imageContent,
        string fileName,
        string contentType,
        CancellationToken cancellationToken = default)
    {
        try
        {
            using var form = new MultipartFormDataContent();
            using var streamContent = new StreamContent(imageContent);
            streamContent.Headers.ContentType =
                new System.Net.Http.Headers.MediaTypeHeaderValue(contentType);

            form.Add(streamContent, "image", fileName);

            using var response = await _httpClient.PostAsync(
                "analyze",
                form,
                cancellationToken);

            response.EnsureSuccessStatusCode();

            var result = await response.Content
                .ReadFromJsonAsync<DiseaseAiResponseDto>(cancellationToken);

            if (result is null)
                throw new AiServiceUnavailableException();

            return new DiseaseDetectionAiResult(
                result.DiseaseName,
                result.Confidence,
                result.AnalysisResult);
        }
        catch (Exception ex) when (
            ex is HttpRequestException or
            TaskCanceledException or
            NotSupportedException)
        {
            throw new AiServiceUnavailableException(
                "Disease detection AI service unavailable.", ex);
        }
    }

    // Placeholder response shape - see class-level comment.
    private record DiseaseAiResponseDto(
        string DiseaseName,
        decimal Confidence,
        string? AnalysisResult);
}
