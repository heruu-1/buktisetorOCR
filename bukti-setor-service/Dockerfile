# Railway Dockerfile - Python 3.12 with distutils fix for OCR
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies for Python 3.12 + OCR packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.12-venv \
    python3.12-dev \
    python3.12-distutils \
    python3-pip \
    python3-setuptools \
    build-essential \
    pkg-config \
    poppler-utils \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libgomp1 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgthread-2.0-0 \
    curl \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Fix setuptools/distutils for Python 3.12
RUN pip install --upgrade pip setuptools wheel

# Copy dependencies file
COPY deps.txt .

# Install Python dependencies with OCR support
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r deps.txt

# Copy application code
COPY . .

# Create uploads directory
RUN mkdir -p /app/uploads && chmod 755 /app/uploads

# Expose port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Start command - full OCR app with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "1", "--timeout", "180", "--worker-class", "sync", "app_bukti_setor:app"]
