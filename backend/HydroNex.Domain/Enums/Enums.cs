namespace HydroNex.Domain.Enums;

public enum SensorType
{
    PH,
    EC,
    WaterTemperature,
    AirTemperature,
    Humidity,
    WaterLevel,
    CO2,
    Light
}

public enum SensorStatus
{
    Active,
    Inactive,
    Faulty
}

public enum CropStatus
{
    Active,
    Harvested,
    Failed
}

public enum GrowthStage
{
    Seedling,
    Vegetative,
    Flowering,
    Harvest
}

public enum RiskLevel
{
    Low,
    Medium,
    High,
    Critical
}

// Recommended action from the AI recommendation pipeline
public enum RecommendationActionType
{
    Irrigation,
    AdjustPH,
    AdjustEC,
    ReduceHumidity,
    IncreaseVentilation,
    ApplyTreatment,
    ContinueMonitoring
}

public enum RecommendationStatus
{
    Pending,
    Applied,
    Dismissed
}

// What triggered the alert
public enum AlertType
{
    SensorThreshold,
    DiseaseDetected,
    AIRecommendation,
    System
}

public enum AlertSeverity
{
    Info,
    Warning,
    Critical
}

public enum AlertStatus
{
    Open,
    Resolved
}

// The simulated actuator command executed for an ActionLog entry
public enum ActuatorActionType
{
    PH_UP,
    PH_DOWN,
    EC_ADJUST,
    IRRIGATION_ON,
    IRRIGATION_OFF,
    VENTILATION_ON,
    VENTILATION_OFF,
    LIGHT_ON,
    LIGHT_OFF
}

public enum ActionStatus
{
    Pending,
    Executed,
    Failed,
    Cancelled
}
