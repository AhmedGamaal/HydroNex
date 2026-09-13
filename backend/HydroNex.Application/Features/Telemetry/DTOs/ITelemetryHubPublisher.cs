namespace HydroNex.Application.Features.Telemetry;

public interface ITelemetryHubPublisher
{
    Task PublishReadingAsync(
        int cropId,
        object reading);

    Task PublishAlertAsync(
        int cropId,
        object alert);

    // Additive events for Developer 3 (handoff section 35). Existing
    // SensorReadingReceived/AlertCreated events and their call sites are
    // untouched - mobile monitoring keeps working exactly as before.
    Task PublishDiseaseDetectedAsync(
        int cropId,
        object diseaseAnalysis);

    Task PublishRecommendationCreatedAsync(
        int cropId,
        object recommendation);
}