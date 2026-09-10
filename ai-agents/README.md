## 🛠️ Setup & Installation

### 1. Create a Virtual Environment (Recommended)
Create and activate a virtual environment to keep dependencies isolated:

**On Windows:**
`python -m venv venv`
`venv\Scripts\activate`

**On Mac/Linux:**
`python3 -m venv venv`
`source venv/bin/activate`

### 2. Install Dependencies
Install all required libraries using the requirements file:

`pip install -r requirements.txt`

---

## ⚙️ How to Run the System

To test the full closed-loop system, you need to run both the API server (the AI Brain) and the Digital Twin simulation (the Farm) simultaneously.

### Step 1: Start the AI Agent (Terminal 1)
In your first terminal window, make sure your virtual environment is active, then run the FastAPI server:

`uvicorn main:app --reload`

*The server will start running on http://127.0.0.1:8000*

### Step 2: Start the Digital Twin Simulation (Terminal 2)
Open a **second** terminal window, activate the virtual environment, and run the simulation file:

`python digital_twin.py`

### 📊 What to Expect:
* The Digital Twin will send real-time sensor data matching our UI constraints (pH, EC, Temperature, Humidity, Light, Water Level) to the AI Agent.
* The AI Agent will respond with an intelligent JSON decision, specifying whether to turn on the water pump, switch on the lights, or adjust nutrients and pH levels based on the current parameters.
