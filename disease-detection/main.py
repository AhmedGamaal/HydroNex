"""
HydroNex Disease Detection Service
Wraps linkanjarad/mobilenet_v2_1.0_224-plant-disease-identification behind a
small REST API the .NET backend calls after a plant image is uploaded.

Run locally:
    pip install -r requirements.txt
    uvicorn main:app --host 0.0.0.0 --port 9001

Run in Docker (see Dockerfile) - this is what you deploy to Azure.
"""
from fastapi import FastAPI, File, UploadFile, HTTPException
from PIL import Image
import io
from transformers import pipeline

app = FastAPI(title="HydroNex Disease Detection Service")

MODEL_NAME = "linkanjarad/mobilenet_v2_1.0_224-plant-disease-identification"

# Loaded once at startup - keep this a module-level singleton, not per-request,
# or every request will reload the model from disk.
classifier = None


@app.on_event("startup")
def load_model():
    global classifier
    classifier = pipeline("image-classification", model=MODEL_NAME)


@app.get("/health")
def health():
    return {"status": "ok", "model_loaded": classifier is not None}


@app.post("/analyze")
async def analyze(image: UploadFile = File(...)):
    if classifier is None:
        raise HTTPException(status_code=503, detail="Model not loaded yet.")

    if not image.content_type or not image.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image.")

    contents = await image.read()
    try:
        pil_image = Image.open(io.BytesIO(contents)).convert("RGB")
    except Exception:
        raise HTTPException(status_code=400, detail="Could not read image file.")

    results = classifier(pil_image, top_k=3)
    top = results[0]

    # Matches DiseaseDetectionAiResult exactly: DiseaseName, Confidence, AnalysisResult
    return {
        "diseaseName": top["label"],
        "confidence": round(top["score"], 4),
        "analysisResult": ", ".join(f"{r['label']}:{r['score']:.0%}" for r in results),
    }
