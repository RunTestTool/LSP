# Synology NAS Deployment Guide

This guide shows how to run the LSP Calculator on Synology NAS for both:

- DSM 7.x with **Container Manager**
- DSM 6.x with the legacy **Docker** package

## What is included

This repository now includes:

- `Dockerfile`
- `docker-compose.synology.yml`
- `.streamlit/config.toml`
- `.dockerignore`

That means you can deploy either by:

1. building directly on the NAS from this folder, or
2. building elsewhere and importing/pulling the image later.

## Recommended approach

For most Synology users, the simplest method is:

- copy the whole project to a shared folder on the NAS
- create a **Project** in Container Manager
- use `docker-compose.synology.yml`

## Before you start

### DSM requirements

- DSM 7.x with Container Manager, or DSM 6.x with Docker package
- Enough RAM for a small Python web app
- LAN access from your PC/tablet/phone to the NAS

### Suggested NAS folder

Create or use a shared folder such as:

```text
/volume1/docker/lsp-calculator
```

Copy this whole project into that folder.

## DSM 7.x: Option A — Deploy with Container Manager Project (recommended)

### 1. Copy project files to NAS

Copy the repository contents into:

```text
/volume1/docker/lsp-calculator
```

The folder should contain at least:

- `app.py`
- `requirements.txt`
- `Dockerfile`
- `docker-compose.synology.yml`
- `.streamlit/config.toml`

### 2. Create the project in DSM

In DSM:

1. Open **Container Manager**
2. Go to **Project**
3. Click **Create**
4. Choose **Create project from existing docker-compose file**
5. Select the folder containing `docker-compose.synology.yml`
6. Give the project a name, for example `lsp-calculator`
7. Deploy the project

Container Manager will build the image from the local `Dockerfile`.

### 3. Open the app

After the container is running, open:

```text
http://<NAS-IP>:8501
```

Example:

```text
http://192.168.1.20:8501
```

## DSM 7.x: Option B — Build image manually, then create container

If you prefer using **Image** / **Container** screens instead of a Project:

1. Build the image from the project folder
2. Create a container from that image
3. Map container port `8501` to NAS port `8501`
4. Set restart policy to `unless-stopped`

This works too, but the Project approach is easier to maintain.

## DSM 6.x: Deploy with Docker package (legacy app)

DSM 6 uses the **Docker** package (not Container Manager Projects).

### 1. Prepare image source

Use one of these approaches:

1. Build image on another machine and push to a registry, then pull on NAS, or
2. Build and save image tar elsewhere, then import to NAS Docker package.

This repository provides `Dockerfile` for building image `lsp-calculator:1.0`.

### 2. Create container in DSM 6 Docker UI

In DSM 6:

1. Open **Docker** package
2. Go to **Image** and pull/import your image
3. Select image `lsp-calculator:1.0` and click **Launch**
4. In container settings:
   - enable auto-restart (equivalent to `unless-stopped` behavior)
   - map local port `8501` to container port `8501`
5. Start the container

Open app at:

```text
http://<NAS-IP>:8501
```

### 3. Update on DSM 6

Because DSM 6 Docker package is container/image driven, update as follows:

1. Import/pull new image tag (example `lsp-calculator:1.1`)
2. Stop old container
3. Create and start new container from new image
4. Reuse same port mapping (`8501:8501`)
5. Verify app and smoke test

### 4. Rollback on DSM 6

If update fails:

1. Stop/remove new container
2. Relaunch container from previous known-good image tag
3. Re-verify app URL and key calculation flow

## Recommended settings for Synology

### Port mapping

- Container port: `8501`
- Local NAS port: `8501` or another unused port such as `18501`

If you use a different local port, open:

```text
http://<NAS-IP>:<YOUR-PORT>
```

### Restart policy

Use:

```text
unless-stopped
```

### Volumes

This app does **not** require a persistent data volume for normal use because:

- uploaded CSV/XLSX files are supplied through the browser session
- generated Excel files are downloaded by the browser
- no database is used

Optional volume use cases:

- storing custom Streamlit config
- storing logs if you later add file-based logging

### Environment

The container already sets safe defaults for Streamlit:

- headless mode enabled
- usage stats disabled

## Reverse proxy on Synology (optional but recommended)

If you want a nicer URL or HTTPS on your LAN:

1. Open **Control Panel** → **Login Portal** → **Advanced** → **Reverse Proxy**
2. Add a rule such as:
   - Source: `https://lsp.yournas.local`
   - Destination: `http://127.0.0.1:8501`
3. Attach a certificate if you use HTTPS

This is recommended if multiple users inside your office will access the app.

## Security guidance

Recommended:

- keep it on the LAN only, or behind Synology reverse proxy
- require DSM / reverse-proxy authentication if used by multiple staff
- do not publish port `8501` directly to the internet
- use HTTPS if accessed outside the trusted LAN

## Updating the app on Synology

Use this runbook whenever you change code, dependencies, or Docker settings.

> This section is primarily for DSM 7 Project-based deployments.
> For DSM 6 image/container updates, follow **DSM 6.x: Deploy with Docker package (legacy app)** above.

### Recommended release layout

Keep versioned folders on NAS so rollback is fast:

```text
/volume1/docker/lsp-calculator/releases/2026-04-27
/volume1/docker/lsp-calculator/releases/2026-05-10
```

Point your Container Manager Project to the current release folder.

### Standard update procedure (Project-based)

1. **Prepare new release folder**
   - Copy new source files into a new folder (do not overwrite old release yet).
   - Ensure the folder contains:
     - `app.py`
     - `requirements.txt`
     - `Dockerfile`
     - `docker-compose.synology.yml`
     - `.streamlit/config.toml`
2. **Backup current release**
   - Keep the previous release folder unchanged.
   - This becomes your rollback target.
3. **Redeploy from new folder**
   - Open **Container Manager** → **Project**.
   - Edit or recreate the project to use the new release folder.
   - Deploy (this rebuilds image from `Dockerfile`).
4. **Wait for healthy status**
   - Confirm project/container status is `running`.
   - Confirm container health is healthy (if shown by DSM).

### Post-update verification checklist

After deployment, verify:

1. App opens: `http://<NAS-IP>:8501`
2. Home page renders without error
3. Upload a small sample CSV/XLSX
4. Click calculate and confirm result table appears
5. Download Excel output successfully
6. (Optional) confirm health endpoint:

```text
http://<NAS-IP>:8501/_stcore/health
```

Expected response is typically `ok`.

### Rollback procedure (if update fails)

1. Stop the newly deployed project/container.
2. Switch the project path back to the previous release folder.
3. Redeploy from the previous release.
4. Re-check app access and calculations.

Because this app is single-service, brief downtime is expected during update/rollback.

### Optional low-downtime strategy (advanced)

If you need reduced interruption:

1. Run a second project on a different port (for example `18501`).
2. Verify the new version on that port.
3. Switch Synology reverse proxy destination from old port to new port.
4. Stop old project after successful cutover.

This is a blue/green-style deployment pattern for Synology.

## Troubleshooting

### The build is slow

This is normal on lower-power NAS models. The added `.dockerignore` reduces unnecessary build context.

### The container starts but the page does not open

Check:

- container status is `running`
- port mapping includes `8501`
- NAS firewall allows the selected local port
- you are using `http://<NAS-IP>:8501`

### The app opens but HKMA yield fetch fails

The app includes a fallback discount rate, so it should still load. Check NAS outbound internet access if you want live rates.

### Synology NAS is ARM-based

If your NAS uses ARM, building from source on the NAS is usually the safest choice. If you later publish a registry image, make sure it is multi-architecture.

## Quick reference

- General deployment: [`DEPLOYMENT.md`](DEPLOYMENT.md)
- Main usage guide: [`README.md`](README.md)
- Docker project file: [`docker-compose.synology.yml`](docker-compose.synology.yml)
- One-page update runbook: [`UPDATE_CHECKLIST.md`](UPDATE_CHECKLIST.md)
- Build/import image guide: [`NAS_IMAGE_IMPORT.md`](NAS_IMAGE_IMPORT.md)
- Windows helper script: [`build_nas_image.bat`](build_nas_image.bat)
- DSM6欄位對照表: [`DSM6_DOCKER_FIELD_MAPPING.md`](DSM6_DOCKER_FIELD_MAPPING.md)
