using HydroNex.Api.Hubs;
using HydroNex.Application.Features.Telemetry;
using Microsoft.AspNetCore.SignalR;

namespace HydroNex.Api.Services;

public class TelemetryHubPublisher : ITelemetryHubPublisher
{
    private readonly IHubContext<MonitoringHub> _hubContext;

    public TelemetryHubPublisher(
        IHubContext<MonitoringHub> hubContext)
    {
        _hubContext = hubContext;
    }

    public async Task PublishReadingAsync(
        int cropId,
        object reading)
    {
        await _hubContext
            .Clients
            .Group($"crop-{cropId}")
            .SendAsync(
                "SensorReadingReceived",
                reading);
    }

    public async Task PublishAlertAsync(
        int cropId,
        object alert)
    {
        await _hubContext
            .Clients
            .Group($"crop-{cropId}")
            .SendAsync(
                "AlertCreated",
                alert);
    }
}