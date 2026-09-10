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
    temperature: float
    humidity: float
    ph: float
    ec: float
    light_intensity: float
    water_level: float

SYSTEM_PROMPT = """
You are an autonomous AI Agent managing a hydroponic farm (HydroNex).
Your goal is to maintain optimal growing conditions. 
IMPORTANT: If all parameters are within the optimal range, take NO action (return 0.0 for pumps and "OFF" for switches).

Optimal Ranges strictly based on UI:
- pH: 5.5 - 6.5
- EC: 1.2 - 2.0 mS/cm
- Temperature: 18°C - 28°C
- Humidity: 50% - 70%
- Light Intensity: 200 - 600 mol/m2
- Water Level: 60% - 85%

Rules:
- If pH > 6.5, dispense pump_ph_down_ml (max 5ml per cycle).
- If pH < 5.5, dispense pump_ph_up_ml (max 5ml per cycle).
- If EC < 1.2, dispense pump_nutrient_ml (max 10.0ml).
- If Light Intensity < 200.0, set light_switch to "ON" to provide artificial light.
- If Water Level < 60.0, set water_pump_status to "ON" to refill the tank.

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
