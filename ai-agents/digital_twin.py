import time
import requests
import random
from datetime import datetime

AGENT_URL = "http://127.0.0.1:8000/decision"

def run_realtime_iot_service():
    print("🌱 Starting HydroNex Real-Time 24/7 Monitoring Service...\n")
    print("⏳ System will send sensors data every 5 minutes.\n")
    
    current_farm_state = {
        "temperature": 25.6,     
        "ph": 5.8,               
        "ec": 1.6,               
        "humidity": 62.0,        
        "light_intensity": 320.0, 
        "water_level": 78.0      
    }
    
    cycle = 1
    try:
        while True: 
            now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            print(f"--- 🔄 Real-Time Reading | Cycle: {cycle} | Time: {now} ---")
            print(f"📊 Sending Data: {current_farm_state}")
            
            response = requests.post(AGENT_URL, json=current_farm_state)
            
            if response.status_code == 200:
                decision = response.json()
                print("🤖 Agent Decision Received:")
                print(f"   -> Reasoning: {decision.get('reasoning')}")
                
                ph_up = decision.get('pump_ph_up_ml', 0)
                ph_down = decision.get('pump_ph_down_ml', 0)
                nutrients = decision.get('pump_nutrient_ml', 0)
                light = decision.get('light_switch', 'OFF')
                water_pump = decision.get('water_pump_status', 'OFF')
                
                print(f"   -> [Actions]: pH+={ph_up} | pH-={ph_down} | Nutrients={nutrients} | Light={light} | WaterPump={water_pump}")
                
                if ph_down > 0:
                    current_farm_state["ph"] -= (ph_down * 0.1)
                if ph_up > 0:
                    current_farm_state["ph"] += (ph_up * 0.1)
                if nutrients > 0:
                    current_farm_state["ec"] += (nutrients * 0.1)
                if light == "ON":
                    current_farm_state["light_intensity"] = min(600.0, current_farm_state["light_intensity"] + 100.0)
                if water_pump == "ON":
                    current_farm_state["water_level"] = min(85.0, current_farm_state["water_level"] + 15.0)
                
                current_farm_state["temperature"] += random.uniform(-0.2, 0.2)
                current_farm_state["humidity"] += random.uniform(-0.5, 0.5)
                current_farm_state["light_intensity"] -= random.uniform(5.0, 10.0) 
                current_farm_state["water_level"] -= random.uniform(0.5, 2.0)       

                for key in ["temperature", "humidity", "ph", "ec", "light_intensity", "water_level"]:
                    current_farm_state[key] = round(current_farm_state[key], 1)
                
            else:
                print(f"❌ Error: {response.status_code} - {response.text}")
                
            print("\n" + "="*65 + "\n")
            
            time.sleep(30) 
            cycle += 1
            
    except KeyboardInterrupt:
        print("\n🛑 Real-Time Monitoring Service Stopped by User.")

if __name__ == "__main__":
    run_realtime_iot_service()
