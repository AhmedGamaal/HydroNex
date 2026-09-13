namespace HydroNex.Application.Common.Exceptions;

// Thrown by AI client implementations (Infrastructure/AI) when the external
// Python service is unreachable, times out, or returns an unexpected result.
// Controllers catch this and return a clean 503 without leaking internal
// exception details / stack traces (handoff section 39).
public class AiServiceUnavailableException : Exception
{
    public AiServiceUnavailableException()
        : base("AI service unavailable. Please try again later.")
    {
    }

    public AiServiceUnavailableException(string message)
        : base(message)
    {
    }

    public AiServiceUnavailableException(string message, Exception innerException)
        : base(message, innerException)
    {
    }
}
