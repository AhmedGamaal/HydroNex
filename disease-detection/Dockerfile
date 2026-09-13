FROM python:3.11-slim

WORKDIR /app

# torch CPU build is much smaller/faster to pull than the CUDA one - fine for
# this model's size and your traffic (a few images at a time, not video).
RUN pip install --no-cache-dir torch==2.4.1 --index-url https://download.pytorch.org/whl/cpu

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt --extra-index-url https://download.pytorch.org/whl/cpu

COPY main.py .

# Bake the model into the image at build time so the container doesn't hit
# HuggingFace on every cold start (slow + costs egress on Azure).
RUN python -c "from transformers import pipeline; pipeline('image-classification', model='linkanjarad/mobilenet_v2_1.0_224-plant-disease-identification')"

EXPOSE 9001
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "9001"]
