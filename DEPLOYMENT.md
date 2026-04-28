# Deployment Guide

## Prerequisites

- Python 3.9+ (local) or Docker (containerized)
- Internet connection (for HKMA live yield fetch)

---

## Local Deployment

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Run the Application

```bash
streamlit run app.py
```

The app will start at `http://localhost:8501` and open in your default browser.

### 3. Configuration (Optional)

Create a `.streamlit/config.toml` file for custom settings:

```toml
[theme]
primaryColor = "#1F4E79"
backgroundColor = "#FFFFFF"
secondaryBackgroundColor = "#F0F2F6"
textColor = "#262730"
font = "sans serif"

[server]
port = 8501
headless = true
runOnSave = true

[client]
showErrorDetails = false
```

---

## Docker Deployment

### 1. Build Image

```bash
docker build -t lsp-calculator:1.0 .
```

### 2. Run Container (Local Development)

```bash
docker run -p 8501:8501 lsp-calculator:1.0
```

Access at `http://localhost:8501`

### 3. Run Container (Production with Volume Mount)

```bash
docker run -d \
  --name lsp-calc \
  -p 8501:8501 \
  -v /path/to/data:/app/data \
  lsp-calculator:1.0
```

### 4. Docker Compose (Optional)

Create `docker-compose.yml`:

```yaml
version: '3.8'

services:
  lsp-calculator:
    build: .
    container_name: lsp-calculator
    ports:
      - "8501:8501"
    environment:
      - STREAMLIT_SERVER_HEADLESS=true
      - STREAMLIT_SERVER_RUNONSAVE=true
    volumes:
      - ./data:/app/data
    restart: unless-stopped
```

Run with:
```bash
docker-compose up -d
```

---

## Synology NAS Deployment

Synology is supported in two modes:

- DSM 7.x: **Container Manager** (recommended)
- DSM 6.x: legacy **Docker** package

The easiest DSM 7 route is to use `docker-compose.synology.yml` in Container Manager.

### Recommended approach

1. Copy this project to a Synology shared folder, for example:
   `/volume1/docker/lsp-calculator`
2. Open **Container Manager** → **Project** → **Create**
3. Select **Create project from existing docker-compose file**
4. Choose `docker-compose.synology.yml`
5. Deploy the project
6. Open the app on your LAN:
   `http://<NAS-IP>:8501`

### Notes for Synology

- No persistent application data volume is required for normal use.
- Uploaded files are provided through the browser session.
- Downloaded Excel files are generated on demand and saved by the browser.
- If your NAS uses ARM, building on the NAS is often simpler than relying on a prebuilt image.
- Prefer LAN-only access or a Synology reverse proxy with HTTPS.

See also: [`SYNOLOGY_NAS.md`](SYNOLOGY_NAS.md)

For update and rollback steps, see **Updating the app on Synology** in [`SYNOLOGY_NAS.md`](SYNOLOGY_NAS.md).

For DSM 6 specifically, use **DSM 6.x: Deploy with Docker package (legacy app)** in [`SYNOLOGY_NAS.md`](SYNOLOGY_NAS.md).

For a one-page operational version, use [`UPDATE_CHECKLIST.md`](UPDATE_CHECKLIST.md).

If you prefer image import (tar) workflow, see [`NAS_IMAGE_IMPORT.md`](NAS_IMAGE_IMPORT.md).

For DSM6 Docker UI field-by-field values, see [`DSM6_DOCKER_FIELD_MAPPING.md`](DSM6_DOCKER_FIELD_MAPPING.md).

---

## Cloud Deployment

### Streamlit Cloud (Free)

1. Push repository to GitHub
2. Go to https://streamlit.io/cloud
3. Click "New app" → select repository
4. Configure GitHub secret if needed
5. App deployed automatically at `https://<username>-<repo>-<branch>.streamlit.app`

### AWS / Azure / GCP

#### Example: AWS ECS

1. Build image and push to ECR:
   ```bash
   aws ecr create-repository --repository-name lsp-calculator
   docker tag lsp-calculator:1.0 <aws-account>.dkr.ecr.<region>.amazonaws.com/lsp-calculator:1.0
   docker push <aws-account>.dkr.ecr.<region>.amazonaws.com/lsp-calculator:1.0
   ```

2. Create ECS task definition with:
   - Image: ECR URI
   - Port: 8501
   - Memory: 512 MB minimum
   - CPU: 256 units minimum

3. Create ECS service and connect to load balancer

#### Example: Heroku

1. Install Heroku CLI
2. Create `Procfile`:
   ```
   web: streamlit run app.py --server.port=$PORT --server.address=0.0.0.0
   ```

3. Deploy:
   ```bash
   heroku create lsp-calculator
   git push heroku main
   ```

---

## Reverse Proxy Setup

### Nginx

```nginx
server {
    listen 80;
    server_name lsp-calculator.example.com;

    location / {
        proxy_pass http://localhost:8501;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Apache

```apache
ProxyPreserveHost On
ProxyPass / http://localhost:8501/
ProxyPassReverse / http://localhost:8501/
```

---

## Environment Variables (Optional)

If deploying with secrets management:

```bash
# .env file (development only)
HKMA_API_TIMEOUT=5
STREAMLIT_SERVER_PORT=8501
STREAMLIT_LOGGER_LEVEL=info
```

Load with `python-dotenv`:
```bash
pip install python-dotenv
```

---

## Health Check

Monitor deployment with periodic test requests:

```bash
# Check if running
curl http://localhost:8501/_stcore/health

# Example health check for Docker
curl --fail http://localhost:8501/ || exit 1
```

---

## Logging & Monitoring

### Streamlit Logs

Default logs go to `~/.streamlit/logs/`

Redirect to file:
```bash
streamlit run app.py > app.log 2>&1 &
```

### Docker Logs

```bash
docker logs -f lsp-calculator
```

### Production Monitoring

Integrate with:
- **Datadog**: Streamlit Datadog integration
- **ELK Stack**: Ship logs to Elasticsearch
- **New Relic**: APM monitoring
- **CloudWatch**: AWS native monitoring

---

## Security Recommendations

✅ **Already Implemented:**
- Local-only computation (no server data transmission)
- HTTPS-ready (use reverse proxy with SSL/TLS)
- No sensitive data storage

✅ **Additional Steps:**
- Use HTTPS/TLS in production
- Enable authentication if on internal network
- Restrict file uploads (size & format)
- Regular dependency updates (`pip list --outdated`)
- Security scanning (`pip install safety && safety check`)

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Port already in use | `streamlit run app.py --server.port=8502` |
| HKMA API timeout | Check internet; increase timeout in `app.py` line 16 |
| Missing dependencies | `pip install -r requirements.txt` |
| Docker build fails | Ensure `requirements.txt` present in same directory |
| File upload not working | Check file size (<200MB) and format (xlsx/csv) |

---

## Maintenance

### Update Dependencies

```bash
pip install --upgrade -r requirements.txt
```

### Test After Updates

```bash
streamlit run app.py
# Verify UI loads, calculations work, HKMA fetch succeeds
```

### Backup Data

```bash
cp -r /app/data /backup/lsp-data-$(date +%Y%m%d)
```

---

**Last Updated**: April 2026
