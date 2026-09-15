namespace HydroNex.Application.Features.Chat.DTOs;

public record ChatRequest(
    int CropId,
    string Message
);

public record ChatResponse(
    string Reply
);
