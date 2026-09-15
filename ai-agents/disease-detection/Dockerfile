FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# Set HF_TOKEN at deploy time (Azure Container Apps: add as a secret/env var),
# never bake a real token into the image.
ENV HF_TOKEN=""

EXPOSE 9001
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "9001"]
