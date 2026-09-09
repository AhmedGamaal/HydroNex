using HydroNex.Application.Features.Dashboard.DTOs;

namespace HydroNex.Application.Features.Dashboard;

public interface IDashboardService
{
    Task<DashboardResponse> GetAsync(string userId);
}