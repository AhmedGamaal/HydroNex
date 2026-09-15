using HydroNex.Application.Features.AI.DTOs;
using HydroNex.Application.Features.CropContext.DTOs;

namespace HydroNex.Application.Features.AI;

// Boundary to the external Python chatbot-intelligence service.
public interface IChatAiClient
{
    Task<ChatAiResult> AskAsync(
        string message,
        CropContextDto context,
        CancellationToken cancellationToken = default);
}
