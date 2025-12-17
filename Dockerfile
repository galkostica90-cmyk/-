# Simple Python Dockerfile — adjust as needed for Node projects
FROM python:3.11-slim AS base
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install dependencies if pyproject or requirements exist
COPY pyproject.toml poetry.lock* /app/
RUN pip install --upgrade pip \
    && pip install poetry || true \
    && if [ -f "pyproject.toml" ]; then poetry config virtualenvs.create false && poetry install --no-dev --no-interaction --no-ansi; fi

COPY . /app

# Default command (override as needed)
CMD ["bash", "-lc", "uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}"]
