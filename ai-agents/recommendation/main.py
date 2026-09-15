"""
HydroNex Recommendation AI Service
Wraps an Azure OpenAI agent behind the exact contract HydroNex.Infrastructure's
RecommendationAiClient already expects: POST /generate, body = CropContextDto
(crop info + current sensor list + history + past analyses/recommendations),
response = {title, description, riskLevel, actionType}.

Setup:
    1. Set these as environment variables before running (never hardcode them):
         AZURE_OPENAI_ENDPOINT, AZURE_OPENAI_KEY, AZURE_OPENAI_DEPLOYMENT
         RECOMMENDATION_API_KEY  (a secret you invent - the .NET side must
         send this back as a header so randoms on the internet can't burn
         your OpenAI credits by hitting this endpoint directly)
    2. pip install -r requirements.txt
    3. uvicorn main:app --port 9002
"""
import os
import json
import logging
from typing import Optional, Union, Any
from fastapi import FastAPI, HTTPException, Header, Request
from fastapi.exceptions import RequestValidationError
from fastapi.responses import JSONResponse
from pydantic import BaseModel, field_validator
from openai import AzureOpenAI

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("hydronex-recommendation")

app = FastAPI(title="HydroNex Recommendation AI Service")


def _stringify(v: Any) -> str:
    return str(v)


@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    body = await request.body()
    logger.error("422 on %s - errors: %s - raw body: %s", request.url.path, exc.errors(), body.decode(errors="replace"))
    return JSONResponse(
        status_code=422,
        content={"detail": exc.errors(), "raw_body_received": body.decode(errors="replace")},
    )

AZURE_OPENAI_ENDPOINT = os.environ.get("AZURE_OPENAI_ENDPOINT")
AZURE_OPENAI_KEY = os.environ.get("AZURE_OPENAI_KEY")
DEPLOYMENT_NAME = os.environ.get("AZURE_OPENAI_DEPLOYMENT", "gpt-4o")
SERVICE_API_KEY = os.environ.get("RECOMMENDATION_API_KEY")

client = (
    AzureOpenAI(
        azure_endpoint=AZURE_OPENAI_ENDPOINT,
        api_key=AZURE_OPENAI_KEY,
        api_version="2025-01-01-preview",
    )
    if AZURE_OPENAI_ENDPOINT and AZURE_OPENAI_KEY
    else None
)


SYSTEM_PROMPT = """
You are an AI agronomist for HydroNex, an autonomous hydroponic farm system.
You are given the current state of one crop: its type/growth stage, its
current sensor readings, recent sensor history, recent disease analyses, and
recent past recommendations. Decide what single, most important recommendation
to make right now.

Optimal ranges (must match the backend's alert thresholds):
- pH: 5.5 - 6.5
- EC: 1.0 - 3.0 mS/cm
- Water Temperature: 18 - 24 C
- Air Temperature: 18 - 30 C
- Humidity: 40 - 80 %
- Water Level: 20 - 100 %
- CO2: 400 - 1500 ppm
- Light: 1000 - 30000 lux

You MUST respond ONLY with a valid JSON object in exactly this shape:
{
    "title": "Short summary, e.g. 'Lower pH using pH- solution'",
    "description": "1-3 sentences explaining the issue and the recommended fix.",
    "riskLevel": "Low" | "Medium" | "High" | "Critical",
    "actionType": "Irrigation" | "AdjustPH" | "AdjustEC" | "ReduceHumidity" | "IncreaseVentilation" | "ApplyTreatment" | "ContinueMonitoring"
}
If everything is within range, return riskLevel "Low" and actionType "ContinueMonitoring".
"""


class SensorReading(BaseModel):
    sensorId: int
    sensorType: Union[str, int]
    unit: str = ""
    value: float
    recordedAt: Union[str, None] = None

    @field_validator("sensorType", mode="before")
    @classmethod
    def _coerce_sensor_type(cls, v):
        return _stringify(v)


class CropContext(BaseModel):
    cropId: int
    cropName: str = ""
    cropType: str = ""
    growthStage: Union[str, int] = ""
    status: Union[str, int] = ""
    currentSensors: list[SensorReading] = []
    recentHistory: list[dict] = []
    recentDiseaseAnalyses: list[dict] = []
    recentRecommendations: list[dict] = []

    @field_validator("growthStage", "status", mode="before")
    @classmethod
    def _coerce_enum_fields(cls, v):
        return _stringify(v)


@app.get("/health")
def health():
    return {"status": "ok", "model_configured": client is not None}


def _check_auth(x_api_key: Optional[str]):
    if SERVICE_API_KEY and x_api_key != SERVICE_API_KEY:
        raise HTTPException(status_code=401, detail="Invalid or missing X-Api-Key.")


@app.post("/generate")
async def generate(context: CropContext, x_api_key: Optional[str] = Header(default=None)):
    _check_auth(x_api_key)

    if client is None:
        raise HTTPException(status_code=500, detail="Azure OpenAI is not configured.")

    payload = context.model_dump()

    try:
        response = client.chat.completions.create(
            model=DEPLOYMENT_NAME,
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": f"Crop context: {json.dumps(payload)}"},
            ],
            response_format={"type": "json_object"},
            temperature=0.2,
        )
        result = json.loads(response.choices[0].message.content)
    except Exception as ex:
        raise HTTPException(status_code=502, detail=f"Azure OpenAI error: {ex}")

    required = {"title", "description", "riskLevel", "actionType"}
    if not required.issubset(result.keys()):
        raise HTTPException(status_code=502, detail=f"Model returned unexpected shape: {result}")

    return result
