
FROM python:3.14-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# Apply available Debian security updates
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Upgrade Python packaging tools and vulnerable packages
RUN python -m pip install --no-cache-dir --upgrade \
    pip setuptools urllib3 msgpack

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

RUN useradd --create-home appuser

COPY app.py .

USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:5000/health', timeout=2)" || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
