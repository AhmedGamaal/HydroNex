using HydroNex.Application.Features.Chat.DTOs;

namespace HydroNex.Application.Features.Chat;

public interface IChatService
{
    /// <summary>
    /// Verifies crop ownership, builds full crop/sensor/disease/recommendation
    /// context via ICropContextService, and forwards to the Python chat AI.
    /// The chatbot never queries the database directly (handoff section 32).
    /// </summary>
    Task<ChatResponse> AskAsync(
        string userId,
        ChatRequest request,
        CancellationToken cancellationToken = default);
}
