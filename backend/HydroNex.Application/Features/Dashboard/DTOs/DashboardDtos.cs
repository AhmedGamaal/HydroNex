namespace HydroNex.Application.Features.Dashboard.DTOs;

public record DashboardCropResponse(
    int Id,
    string Name,
    string CropType,
    string BatchId,
    int CurrentDay,
    int CycleDuration,
    int ProgressPercentage,
    string GrowthStage,
    string Status
);

public record DashboardResponse(
    int FarmCount,
    int CropCount,
    int ActiveCropCount,
    int OpenAlertCount,
    int OnlineSensorCount,
    List<DashboardCropResponse> Crops
);