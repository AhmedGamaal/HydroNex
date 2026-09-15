# 🤖 HydroNex AI Agents

This directory contains the AI microservices that power HydroNex's plant disease detection, agronomic recommendations, and conversational assistant. Each agent is an independent Python service consumed by the .NET backend over HTTP.

---

## 📂 Structure

```
ai-agents/
├── disease-detection/     # Plant disease classification from leaf images
│   ├── main.py
│   ├── requirements.txt
│   └── Dockerfile
├── recommendation/        # Agronomic recommendation engine
│   ├── main.py
│   ├── requirements.txt
│   └── Dockerfile
├── chat-bot/               # Conversational assistant (farm-data-aware)
│   └── chat_ai_service.py
└── README.md
```

---

## 🔬 Disease Detection Service

Classifies plant leaf images to detect potential diseases, using a pretrained MobileNetV2 model fine-tuned on the PlantVillage dataset.

**Default port:** `9001`

### Run locally
```bash
cd disease-detection
pip install -r requirements.txt
python main.py
```

### Run with Docker
```bash
cd disease-detection
docker build -t hydronex-disease-detection .
docker run -p 9001:9001 hydronex-disease-detection
```

> Configured in the backend via `appsettings.json` → `AI:DiseaseApiUrl`.

---

## 🌿 Recommendation Service

Generates data-grounded agronomic recommendations (e.g. nutrient dosing, environmental adjustments) based on live sensor readings and crop context.

**Default port:** `9002`

### Run locally
```bash
cd recommendation
pip install -r requirements.txt
python main.py
```

### Run with Docker
```bash
cd recommendation
docker build -t hydronex-recommendation .
docker run -p 9002:9002 hydronex-recommendation
```

> Configured in the backend via `appsettings.json` → `AI:RecommendationApiUrl`. Supports an optional `AI:RecommendationApiKey` sent as an `X-Api-Key` header.

---

## 💬 Chat Assistant Service

A conversational agent that answers grower questions using live farm context (sensor data, crop state) alongside an LLM backend.

**Default port:** `9003`

### Run locally
```bash
cd chat-bot
pip install -r requirements.txt
python chat_ai_service.py
```

**Expected request/response contract:**
```json
// POST /chat
// Request
{
  "message": "Why is my pH rising?",
  "context": { /* live crop/sensor context */ }
}

// Response
{
  "reply": "Your pH has risen because..."
}
```

> Configured in the backend via `appsettings.json` → `AI:ChatApiUrl`.

---

## ⚙️ Environment Variables

Each service may require its own `.env` file for API keys (e.g. Gemini/OpenAI credentials) and model paths. See each subfolder for service-specific configuration — none of these values should be committed to the repo.

---

## 🔌 Integration with the Backend

The ASP.NET Core backend calls each of these services as a named `HttpClient`, configured in `HydroNex.Infrastructure/DependencyInjection.cs`. If a service is unreachable, the backend surfaces an `AiServiceUnavailableException` rather than failing silently.

| Backend client | Talks to | Timeout |
|---|---|---|
| `DiseaseAI` | `disease-detection` | 30s |
| `RecommendationAI` | `recommendation` | 15s |
| `ChatAI` | `chat-bot` | 20s |
