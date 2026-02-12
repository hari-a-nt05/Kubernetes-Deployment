# ----------------------------
# Stage 1: Base Python Image
# ----------------------------
FROM python:3.12-slim

# ----------------------------
# Environment Variables
# ----------------------------
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# ----------------------------
# Create non-root user (Security Best Practice)
# ----------------------------
RUN addgroup --system appgroup && adduser --system --group appuser

# ----------------------------
# Set working directory
# ----------------------------
WORKDIR /app

# ----------------------------
# Install system dependencies
# ----------------------------
RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ----------------------------
# Install Python dependencies
# ----------------------------
COPY requirements.txt .
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# ----------------------------
# Copy application code
# ----------------------------
COPY . .

# ----------------------------
# Change ownership to non-root user
# ----------------------------
RUN chown -R appuser:appgroup /app

USER appuser

# ----------------------------
# Expose port
# ----------------------------
EXPOSE 5000

# ----------------------------
# Healthcheck (Docker-level)
# ----------------------------
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD curl -f http://localhost:5000/health || exit 1

# ----------------------------
# Run with Gunicorn (Production)
# ----------------------------
CMD ["gunicorn", \
     "--workers=4", \
     "--threads=2", \
     "--timeout=60", \
     "--bind=0.0.0.0:5000", \
     "--access-logfile=-", \
     "--error-logfile=-", \
     "main:app"]
