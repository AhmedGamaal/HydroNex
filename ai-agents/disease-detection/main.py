"""
HydroNex Disease Detection Service
Thin proxy to HuggingFace's hosted Inference Providers running
linkanjarad/mobilenet_v2_1.0_224-plant-disease-identification via the
official huggingface_hub client - no local model loading, no torch install.

Setup:
    1. Get a free token: https://huggingface.co/settings/tokens (read access is enough)
    2. Set it as an environment variable before running:
         Windows (PowerShell):  $env:HF_TOKEN="hf_xxxxxxxx"
    3. pip install -r requirements.txt
    4. uvicorn main:app --port 9001
"""
import os
import tempfile
from fastapi import FastAPI, File, UploadFile, HTTPException
from huggingface_hub import InferenceClient
from huggingface_hub.errors import HfHubHTTPError

app = FastAPI(title="HydroNex Disease Detection Service")

MODEL_ID = "linkanjarad/mobilenet_v2_1.0_224-plant-disease-identification"
HF_TOKEN = os.environ.get("HF_TOKEN")

client = InferenceClient(provider="hf-inference", api_key=HF_TOKEN) if HF_TOKEN else None


@app.get("/health")
def health():
    return {"status": "ok", "hf_token_configured": HF_TOKEN is not None}


@app.post("/analyze")
async def analyze(image: UploadFile = File(...)):
    if client is None:
        raise HTTPException(status_code=500, detail="HF_TOKEN environment variable is not set.")

    if not image.content_type or not image.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image.")

    contents = await image.read()


    suffix = os.path.splitext(image.filename or "upload.jpg")[1] or ".jpg"
    with tempfile.NamedTemporaryFile(suffix=suffix, delete=False) as tmp:
        tmp.write(contents)
        tmp_path = tmp.name

    try:
        results = client.image_classification(tmp_path, model=MODEL_ID)
    except HfHubHTTPError as ex:
        raise HTTPException(status_code=502, detail=f"HuggingFace API error: {ex}")
    finally:
        os.remove(tmp_path)

    if not results:
        raise HTTPException(status_code=502, detail="No predictions returned from HuggingFace.")

    top = results[0]

    return {
        "diseaseName": top.label,
        "confidence": round(top.score, 4),
        "analysisResult": ", ".join(f"{r.label}:{r.score:.0%}" for r in results[:3]),
    }
