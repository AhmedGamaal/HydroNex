# ⚙️ HydroNex Backend

ASP.NET Core Web API powering the HydroNex platform — handles authentication, farm/crop management, sensor telemetry, alerts, and integration with the AI microservices (disease detection, recommendations, chat assistant).

---

## 📂 Structure

Built with a Clean Architecture layout, split across four projects:

```
backend/
├── HydroNex.Api/               # Controllers, SignalR hubs, app entry point
├── HydroNex.Application/       # Interfaces, DTOs, feature contracts
├── HydroNex.Domain/             # Entities, enums, core domain models
└── HydroNex.Infrastructure/    # Service implementations, EF Core, AI clients

```

- **Domain** — no dependencies on other layers; pure entities and enums (`Crop`, `Sensor`, `Farm`, `OtpVerification`, etc.)
- **Application** — defines service interfaces and DTOs per feature (`Features/Auth`, `Features/Crops`, `Features/Telemetry`, `Features/AI`, etc.)
- **Infrastructure** — implements those interfaces: EF Core persistence, email service, AI HTTP clients, file storage
- **Api** — exposes everything via REST controllers and a SignalR hub for real-time updates

---

## 🛠️ Tech Stack

- ASP.NET Core (.NET 8)
- Entity Framework Core + SQL Server
- SignalR (real-time telemetry push)
- MailKit (email/OTP delivery)
- JWT authentication

---

## 🚀 Getting Started

### Prerequisites
- [.NET SDK 8.0+](https://dotnet.microsoft.com/download)
- SQL Server (or LocalDB for local development)

### Run locally
```bash
cd HydroNex.Api
dotnet restore
dotnet run
```

The API will start on the port configured in `Properties/launchSettings.json`. Swagger UI is available at `/swagger` in development.

### Apply database migrations
```bash
cd HydroNex.Infrastructure
dotnet ef database update --startup-project ../HydroNex.Api
```

### Configuration
Update `HydroNex.Api/appsettings.json` (or use `appsettings.Development.json` / environment variables for secrets) with:
- SQL Server connection string
- JWT signing key
- SMTP settings (for OTP emails)
- AI service URLs (`AI:DiseaseApiUrl`, `AI:RecommendationApiUrl`, `AI:ChatApiUrl`)

> Never commit real secrets to `appsettings.json` — use `appsettings.Development.json` locally (gitignored) or environment variables in production.

---

## 📡 API Overview

| Controller | Responsibility |
|---|---|
| `AuthController` | Registration, login, OTP verification |
| `FarmsController` | Farm CRUD |
| `CropsController` | Crop CRUD and lifecycle |
| `SensorsController` | Sensor registration and management |
| `TelemetryController` | Sensor reading ingestion |
| `AlertsController` | Threshold-based alerts |
| `ActionsController` | Logged control actions (pumps, fans, dosing) |
| `DashboardController` | Aggregated farm overview data |
| `DiseaseAnalysisController` | Plant image upload and disease classification |
| `RecommendationsController` | AI-generated agronomic recommendations |
| `ChatController` | Conversational assistant |
| `PlantImagesController` | Plant image storage and retrieval |

Real-time sensor updates are pushed via `MonitoringHub` (SignalR).

Full endpoint documentation is available via Swagger when running in development mode.

---

## 🤖 AI Service Integration

The backend calls out to three independent Python AI services (see [`ai-agents/README.md`](../ai-agents/README.md)):

| Client | Purpose |
|---|---|
| `IChatAiClient` | Conversational assistant |
| `IRecommendationAiClient` | Agronomic recommendations |
| `IPlantDiseaseAiClient` | Disease detection from leaf images |

If an AI service is unreachable, the backend throws `AiServiceUnavailableException` rather than failing silently, so the API can return a clear error to the client.

---

## 🗃️ Database Migrations

Migrations live in `HydroNex.Infrastructure/Migrations/`. To add a new migration after modifying entities:

```bash
cd HydroNex.Infrastructure
dotnet ef migrations add <MigrationName> --startup-project ../HydroNex.Api
```


---

## 📄 Related Documentation

- [Main project README](../README.md)
- [AI Agents README](../ai-agents/README.md)
