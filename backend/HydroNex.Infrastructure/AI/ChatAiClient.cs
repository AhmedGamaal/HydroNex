using System.Net.Http.Json;
using HydroNex.Application.Common.Exceptions;
using HydroNex.Application.Features.AI;
using HydroNex.Application.Features.AI.DTOs;
using HydroNex.Application.Features.CropContext.DTOs;

namespace HydroNex.Infrastructure.AI;

// INTEGRATION POINT (handoff Rule 7/8): real Python chat-AI contract not
// confirmed yet. Sends {message, context} as JSON, expects {reply} back -
// update the request/response shape here once the actual contract exists.
public class ChatAiClient : IChatAiClient
{
    private readonly HttpClient _httpClient;

    public ChatAiClient(IHttpClientFactory httpClientFactory)
    {
        _httpClient = httpClientFactory.CreateClient("ChatAI");
    }

    public async Task<ChatAiResult> AskAsync(
        string message,
        CropContextDto context,
        CancellationToken cancellationToken = default)
    {
        try
        {
            using var response = await _httpClient.PostAsJsonAsync(
                "chat",
                new ChatAiRequestDto(message, context),
                cancellationToken);

            response.EnsureSuccessStatusCode();

            var result = await response.Content
                .ReadFromJsonAsync<ChatAiResponseDto>(cancellationToken);

            if (result is null)
                throw new AiServiceUnavailableException();

            return new ChatAiResult(result.Reply);
        }
        catch (Exception ex) when (
            ex is HttpRequestException or
            TaskCanceledException or
            NotSupportedException)
        {
            throw new AiServiceUnavailableException(
                "Chat AI service unavailable.", ex);
        }
    }

    // Placeholder request/response shape - see class-level comment.
    private record ChatAiRequestDto(string Message, CropContextDto Context);
    private record ChatAiResponseDto(string Reply);
}
