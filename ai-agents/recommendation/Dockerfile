FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY main.py .

# Set these at deploy time (Azure Container Apps: add as secrets), never bake
# real values into the image:
ENV AZURE_OPENAI_ENDPOINT=""
ENV AZURE_OPENAI_KEY=""
ENV AZURE_OPENAI_DEPLOYMENT="gpt-4o"
ENV RECOMMENDATION_API_KEY=""

EXPOSE 9002
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "9002"]
