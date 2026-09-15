"""
HydroNex Chat AI microservice.

This replaces the Chainlit prototype with a small FastAPI service that speaks
the exact contract HydroNex.Infrastructure.AI.ChatAiClient already expects:

    POST /chat
    body: {"message": "<user text>", "context": { ...CropContextDto... }}
    response: {"reply": "<assistant text>"}

Run it on port 9003 (matches appsettings.json -> AI:ChatApiUrl).
"""

import os
import json
from typing import Any

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from openai import AzureOpenAI

# --- Azure OpenAI configuration -------------------------------------------
# Never hardcode the key. Set these as environment variables before starting
# the service, e.g.:
#   export AZURE_OPENAI_ENDPOINT="https://moham-mtsp1iqi-eastus2.cognitiveservices.azure.com/"
#   export AZURE_OPENAI_KEY="..."
#   export AZURE_OPENAI_DEPLOYMENT="gpt-4o"
AZURE_OPENAI_ENDPOINT = os.environ["AZURE_OPENAI_ENDPOINT"]
AZURE_OPENAI_KEY = os.environ["AZURE_OPENAI_KEY"]
DEPLOYMENT_NAME = os.environ.get("AZURE_OPENAI_DEPLOYMENT", "gpt-4o")

client = AzureOpenAI(
    azure_endpoint=AZURE_OPENAI_ENDPOINT,
    api_key=AZURE_OPENAI_KEY,
    api_version="2025-01-01-preview",
)

CHATBOT_SYSTEM_PROMPT = """
You are the Conversational Agronomic Assistant for the HydroNex Smart Hydroponic System.
Your core mission is to give the grower real-time hydroponic diagnostics, explain automated
hardware actuations, and interpret telemetry.

System target ranges for farm parameters:
- pH: 5.5 - 6.5
- EC: 1.2 - 2.0 mS/cm
- Temperature: 18C - 28C
- Humidity: 50% - 70%
- Light Intensity: 200 - 600 umol/m2
- Water Level: 60% - 85%

Core instructions:
1. Grounding: base your diagnostic and status answers strictly on the crop/sensor context
   provided with each request (current sensors, recent history, recent disease analyses,
   recent recommendations). Do not invent readings that are not in the context.
2. Explainability: when asked why a pump, light, or dosing event occurred, correlate the
   action with the relevant sensor threshold deviation from the context.
3. Domain guardrail: if the user asks about topics outside of hydroponics, farm telemetry,
   plant health, agriculture, or the HydroNex system (general chit-chat, politics, sports,
   unrelated coding help, trivia, etc.), decline politely and steer back to the farm.
4. Language: always reply in the same language the user wrote in (Arabic, English, or
   otherwise). Keep technical terms (pH, EC, sensors, actuators, dosing pumps) clear and
   accurate regardless of language. Do not default to any single language.
5. Tone: professional, supportive, and knowledgeable.
"""


class ChatAiRequest(BaseModel):
    message: str
    context: dict[str, Any] | None = None


class ChatAiResponse(BaseModel):
    reply: str


app = FastAPI(title="HydroNex Chat AI Service")


@app.get("/health")
def health() -> dict[str, str]:
    return {"status": "ok"}


@app.post("/chat", response_model=ChatAiResponse)
def chat(request: ChatAiRequest) -> ChatAiResponse:
    if not request.message or not request.message.strip():
        raise HTTPException(status_code=400, detail="message cannot be empty.")

    context_str = (
        json.dumps(request.context, ensure_ascii=False)
        if request.context
        else "No crop context was provided."
    )

    messages = [
        {"role": "system", "content": CHATBOT_SYSTEM_PROMPT},
        {
            "role": "user",
            "content": f"{request.message}\n\n[Crop/Farm Context]: {context_str}",
        },
    ]

    try:
        response = client.chat.completions.create(
            model=DEPLOYMENT_NAME,
            messages=messages,
            temperature=0.3,
        )
    except Exception as exc:  # noqa: BLE001 - surface as 502 to the backend
        raise HTTPException(status_code=502, detail=f"AI provider error: {exc}") from exc

    reply = response.choices[0].message.content or ""
    return ChatAiResponse(reply=reply)