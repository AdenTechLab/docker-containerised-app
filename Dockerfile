
FROM python:3.14-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# Apply available Debian security updates
RUN apt-get update \
    && apt-get upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Install updated Python packaging tools
RUN python -m pip install --no-cache-dir --upgrade \
    pip setuptools urllib3 msgpack

# Install application dependencies
COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt

# Remove pip and its bundled dependencies from the runtime image
RUN python -c "import pathlib, shutil, sysconfig; \
site = pathlib.Path(sysconfig.get_paths()['purelib']); \
shutil.rmtree(site / 'pip', ignore_errors=True); \
[shutil.rmtree(p, ignore_errors=True) for p in site.glob('pip-*.dist-info')]; \
[shutil.rmtree(p, ignore_errors=True) for p in site.glob('pip-*.egg-info')]" \
    && rm -f /usr/local/bin/pip /usr/local/bin/pip3 /usr/local/bin/pip3.14

# Create an unprivileged application user
RUN useradd --create-home appuser

COPY app.py .

USER appuser

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://127.0.0.1:5000/health', timeout=2)" || exit 1

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
