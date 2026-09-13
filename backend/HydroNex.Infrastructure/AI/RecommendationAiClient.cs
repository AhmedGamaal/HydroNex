using System.Net.Http.Json;
using HydroNex.Application.Common.Exceptions;
using HydroNex.Application.Features.AI;
using HydroNex.Application.Features.AI.DTOs;
using HydroNex.Application.Features.CropContext.DTOs;
using HydroNex.Domain.Enums;

namespace HydroNex.Infrastructure.AI;

// INTEGRATION POINT (handoff Rule 7/8): real Python recommendation-AI
// contract not confirmed yet. Sends CropContextDto as JSON and expects a
// single recommendation back - update the request/response shape here
// once the actual contract exists. Nothing outside this class changes.
public class RecommendationAiClient : IRecommendationAiClient
{
    private readonly HttpClient _httpClient;

    public RecommendationAiClient(IHttpClientFactory httpClientFactory)
    {
        _httpClient = httpClientFactory.CreateClient("RecommendationAI");
    }

    public async Task<RecommendationAiResult> GenerateAsync(
        CropContextDto context,
        CancellationToken cancellationToken = default)
    {
        try
        {
            using var response = await _httpClient.PostAsJsonAsync(
                "generate",
                context,
                cancellationToken);

            response.EnsureSuccessStatusCode();

            var result = await response.Content
                .ReadFromJsonAsync<RecommendationAiResponseDto>(cancellationToken);

            if (result is null)
                throw new AiServiceUnavailableException();

            return new RecommendationAiResult(
                result.Title,
                result.Description,
                result.RiskLevel,
                result.ActionType);
        }
        catch (Exception ex) when (
            ex is HttpRequestException or
            TaskCanceledException or
            NotSupportedException)
        {
            throw new AiServiceUnavailableException(
                "Recommendation AI service unavailable.", ex);
        }
    }

    // Placeholder response shape - see class-level comment.
    private record RecommendationAiResponseDto(
        string Title,
        string Description,
        RiskLevel RiskLevel,
        RecommendationActionType ActionType);
}
