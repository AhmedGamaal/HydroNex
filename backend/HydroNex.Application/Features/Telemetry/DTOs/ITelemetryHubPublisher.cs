namespace HydroNex.Application.Features.Telemetry;

public interface ITelemetryHubPublisher
{
    Task PublishReadingAsync(
        int cropId,
        object reading);

    Task PublishAlertAsync(
        int cropId,
        object alert);
}