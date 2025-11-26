# Multi-stage build for smaller final image
FROM python:3.11-slim AS build

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential gcc && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Install dependencies into wheels
COPY app/requirements.txt .
RUN pip install --upgrade pip
RUN pip wheel --no-cache-dir --no-deps -r requirements.txt -w /wheels

# Final runtime image
FROM python:3.11-slim AS runtime

WORKDIR /app

COPY --from=build /wheels /wheels
RUN pip install --no-cache /wheels/*

# Copy app source code
COPY app /app

# Create non-root user
RUN groupadd -r appuser && \
    useradd -r -g appuser appuser && \
    chown -R appuser:appuser /app
USER appuser

ENV PORT=8000
EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
