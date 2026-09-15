using Microsoft.AspNetCore.SignalR.Client;
using Microsoft.AspNetCore.Http.Connections;

var token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIyOGM2YWNiYy1hMTNkLTRiNzQtOWM4Mi1iY2IxNjliMTQ2NDMiLCJlbWFpbCI6Imhtb3gwMEBnbWFpbC5jb20iLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6IjI4YzZhY2JjLWExM2QtNGI3NC05YzgyLWJjYjE2OWIxNDY0MyIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI6Imhtb3gwMEBnbWFpbC5jb20iLCJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1lIjoiTW9obWFlZCBCYWlvdW15IiwiZXhwIjoxNzg5MzM4MTk4LCJpc3MiOiJIeWRyb05leC5BcGkiLCJhdWQiOiJIeWRyb05leC5Nb2JpbGUifQ.3XMn15wtoRzeTWmc7QvHNAyxXmfOehYJHdy9-bWVZ8E";

var connection = new HubConnectionBuilder()
    .WithUrl(
        "https://localhost:7001/hubs/monitoring",
        options =>
        {
            options.AccessTokenProvider = () =>
                Task.FromResult(token)!;
        })
    .WithAutomaticReconnect()
    .Build();

connection.On<object>(
    "SensorReadingReceived",
    reading =>
    {
        Console.WriteLine("=== SENSOR READING ===");
        Console.WriteLine(reading);
    });

connection.On<object>(
    "AlertCreated",
    alert =>
    {
        Console.WriteLine("=== ALERT CREATED ===");
        Console.WriteLine(alert);
    });

await connection.StartAsync();

Console.WriteLine("Connected.");
await connection.InvokeAsync("JoinCrop", 6);

Console.WriteLine("Joined Crop 6.");
Console.WriteLine("Waiting for live events...");

await Task.Delay(Timeout.Infinite);