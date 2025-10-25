# SecureStack AI Inference System

This project demonstrates a local AI inference setup with containerized components:
- **edge-proxy**: acts as the reverse proxy with TLS termination
- **api-service**: FastAPI app exposing health, readiness, and inference endpoints
- **storage**: Postgres database for audit records
- **prometheus** & **grafana**: monitoring and visualization

## Usage

```bash
cp .env.sample .env
docker compose build
docker compose up -d
```

- Health: `curl -sk https://localhost:9443/health`
- Ready: `curl -sk https://localhost:9443/ready`
- Inference: `curl -sk -X POST https://localhost:9443/infer`

## Stopping
```bash
docker compose down
docker compose down -v
```
