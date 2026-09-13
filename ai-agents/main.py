from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from openai import AzureOpenAI
import json

app = FastAPI(title="HydroNex AI Agent")

AZURE_OPENAI_ENDPOINT = "https://moham-mtsp1iqi-eastus2.cognitiveservices.azure.com/"
AZURE_OPENAI_KEY = "D6RcMHWVej5TsSSX5wiEZyMf2M3ev2NgCmEkGA86c7SgaV3cWHCNJQQJ99CIACHYHv6XJ3w3AAAAACOGcyxs"
DEPLOYMENT_NAME = "gpt-4o" 

client = AzureOpenAI(
    azure_endpoint=AZURE_OPENAI_ENDPOINT,
    api_key=AZURE_OPENAI_KEY,
    api_version="2025-01-01-preview"
)

class SensorData(BaseModel):
    ph: float
    ec: float
    water_temperature: float
    air_temperature: float
    humidity: float
    water_level: float
    co2: int
    light: int

SYSTEM_PROMPT = """
You are an autonomous AI Agent managing a hydroponic farm (HydroNex).
Your goal is to maintain optimal growing conditions based on standard ranges (for Lettuce/Basil):

Optimal Ranges strictly based on UI/Backend:
- pH: 5.5 - 6.5
- EC: 1.0 - 2.0 mS/cm
- Water Temperature: 18.0°C - 26.0°C
- Air Temperature: 18.0°C - 28.0°C
- Humidity: 50% - 80%
- Water Level: 50% - 100%
- CO2: 400 - 1000 ppm
- Light: 5000 - 20000 lux

Rules:
- If pH > 6.5, dispense pump_ph_down_ml (max 5ml per cycle).
- If pH < 5.5, dispense pump_ph_up_ml (max 5ml per cycle).
- If EC < 1.0, dispense pump_nutrient_ml (max 10.0ml).
- If Light < 5000, set light_switch to "ON" to provide artificial light.
- If Water Level < 50.0, set water_pump_status to "ON" to refill the tank.

You MUST respond ONLY with a valid JSON object in the following format:
{
    "reasoning": "Brief explanation of actions, or confirm that everything is optimal.",
    "pump_ph_up_ml": 0.0,
    "pump_ph_down_ml": 0.0,
    "pump_nutrient_ml": 0.0,
    "light_switch": "OFF",
    "water_pump_status": "OFF"
}
"""

@app.post("/decision")
async def get_farm_decision(data: SensorData):
    try:
        current_data_str = json.dumps(data.model_dump())
        
        response = client.chat.completions.create(
            model=DEPLOYMENT_NAME,
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": f"Current Farm Data: {current_data_str}"}
            ],
            response_format={"type": "json_object"}, 
            temperature=0.2 
        )
        
        ai_decision = json.loads(response.choices[0].message.content)
        return ai_decision

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
