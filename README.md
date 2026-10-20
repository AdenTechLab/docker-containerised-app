# Containerised Flask Application | Docker & DevSecOps

A containerised Flask web application built with Docker and Docker Compose, featuring automated testing, continuous integration and security scanning through GitHub Actions.

This project demonstrates practical DevOps and DevSecOps skills, including containerisation, CI/CD automation, vulnerability management and container hardening.

## Project Overview

The goal of this project was to build, containerise and secure a Python web application while implementing an automated pipeline to test the application and scan its dependencies and Docker image.

The application uses Flask for the web framework and Gunicorn as the production application server. Docker packages the application and its dependencies into a container, while Docker Compose simplifies running the service locally.

## Architecture

```text
Developer
    |
    v
GitHub Repository
    |
    v
GitHub Actions CI Pipeline
    |
    +----> Python application tests (pytest)
    |
    +----> Docker image build
    |
    +----> Static security analysis (Bandit)
    |
    +----> Dependency vulnerability audit (pip-audit)
    |
    +----> Container vulnerability scan (Trivy)
    |
    v
Docker Image
    |
    v
Docker Compose
    |
    v
Gunicorn
    |
    v
Flask Application
    |
    +----> GET /
    |
    +----> GET /health
```

## Technology Stack

| Technology | Purpose |
|---|---|
| Python | Application programming language |
| Flask | Web application framework |
| Gunicorn | Production WSGI application server |
| Docker | Application containerisation |
| Docker Compose | Container configuration and lifecycle management |
| pytest | Automated application testing |
| GitHub Actions | Continuous integration and automated checks |
| Bandit | Python static security analysis |
| pip-audit | Python dependency vulnerability scanning |
| Trivy | Container image vulnerability scanning |
| Git and GitHub | Version control and source code hosting |

## Application Endpoints

| Endpoint | Description |
|---|---|
| `/` | Application homepage |
| `/health` | Health check endpoint used to verify application availability |

Example health check response:

```json
{
  "status": "healthy"
}
```

## Getting Started

### Prerequisites

Install the following tools:

- Git
- Docker Engine or Docker Desktop
- Docker Compose

### 1. Clone the repository

```bash
git clone https://github.com/AdenTechLab/docker-containerised-app.git
cd docker-containerised-app
```

### 2. Build and start the application

```bash
docker compose up --build -d
```

This builds the Docker image and starts the application in the background.

### 3. Check container status

```bash
docker compose ps
```

The application container should be running. After its startup period, its health status should report as healthy.

### 4. Test the application

Open the homepage in your browser:

http://localhost:5000

Check the health endpoint:

```bash
curl -i http://localhost:5000/health
```

Expected response:

```json
{
  "status": "healthy"
}
```

### 5. View application logs

```bash
docker compose logs -f web
```

### 6. Stop the application

```bash
docker compose down
```

## Running Tests Locally

Create and activate a Python virtual environment if you want to run the tests outside Docker.

```bash
python -m venv .venv
```

On Linux or macOS:

```bash
source .venv/bin/activate
```

Install the dependencies:

```bash
python -m pip install -r requirements.txt
```

Run the test suite:

```bash
python -m pytest -v
```

The tests validate the application's endpoints and expected responses.

## CI/CD Pipeline

The project uses GitHub Actions to automate application testing, image building and security checks.

The workflow runs on relevant pushes and pull requests targeting the `main` branch.

### Pipeline stages

1. **Application testing:** Installs Python dependencies and runs pytest.
2. **Docker image build:** Builds the application container image.
3. **Static analysis:** Runs Bandit against the Python application code.
4. **Dependency auditing:** Uses pip-audit to identify known vulnerabilities in Python dependencies.
5. **Container security:** Uses Trivy to scan the built image for operating-system and library vulnerabilities.

The security workflow is configured to fail when applicable HIGH or CRITICAL vulnerabilities are detected. Unfixed vulnerabilities are handled according to the configured Trivy policy.

These automated checks help identify issues before changes