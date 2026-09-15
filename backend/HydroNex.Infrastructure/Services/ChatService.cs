using HydroNex.Application.Features.AI;
using HydroNex.Application.Features.Chat;
using HydroNex.Application.Features.Chat.DTOs;
using HydroNex.Application.Features.CropContext;

namespace HydroNex.Infrastructure.Services;

public class ChatService : IChatService
{
    private readonly ICropContextService _cropContextService;
    private readonly IChatAiClient _chatAiClient;

    public ChatService(
        ICropContextService cropContextService,
        IChatAiClient chatAiClient)
    {
        _cropContextService = cropContextService;
        _chatAiClient = chatAiClient;
    }

    public async Task<ChatResponse> AskAsync(
        string userId,
        ChatRequest request,
        CancellationToken cancellationToken = default)
    {
        if (string.IsNullOrWhiteSpace(request.Message))
            throw new InvalidOperationException("Message cannot be empty.");

        // Ownership is enforced inside BuildContextAsync - the chatbot
        // never queries the database directly (handoff section 32).
        var context = await _cropContextService.BuildContextAsync(
            userId,
            request.CropId,
            cancellationToken);

        var aiResult = await _chatAiClient.AskAsync(
            request.Message,
            context,
            cancellationToken);

        return new ChatResponse(aiResult.Reply);
    }
}
