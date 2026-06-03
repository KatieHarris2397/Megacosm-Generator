FROM mirror.gcr.io/library/python:3.13-slim

WORKDIR /app

# Install system dependencies needed for some requirements
RUN apt-get update && apt-get install -y --no-install-recommends gcc python3-dev && rm -rf /var/lib/apt/lists/*

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Ensure the app directory is in the python path for imports to work
ENV PYTHONPATH=/app
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

EXPOSE 8000

# Based on the file listing, run.py is the entry point. 
# In Flask apps, typically the Flask instance is named 'app'.
# We bind to 0.0.0.0:8000 as required by Nexlayer.
CMD ["gunicorn", "run:app", "--bind", "0.0.0.0:8000", "--workers", "4", "--timeout", "120"]