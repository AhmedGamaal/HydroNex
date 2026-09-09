using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.SignalR;

namespace HydroNex.Api.Hubs;

[Authorize]
public class MonitoringHub : Hub
{
    public async Task JoinCrop(int cropId)
    {
        await Groups.AddToGroupAsync(
            Context.ConnectionId,
            $"crop-{cropId}");
    }

    public async Task LeaveCrop(int cropId)
    {
        await Groups.RemoveFromGroupAsync(
            Context.ConnectionId,
            $"crop-{cropId}");
    }
}