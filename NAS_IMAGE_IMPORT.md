# Build and Import Docker Image to Synology NAS

This guide is for creating a Docker image tar on Windows and importing it into Synology.

## 1) Build image artifact on Windows

Run from the project folder:

```bat
cd c:\Users\Kevin\Documents\LSP
build_nas_image.bat
```

Optional custom version/tag:

```bat
cd c:\Users\Kevin\Documents\LSP
build_nas_image.bat 1.1
```

Optional full custom parameters:

```bat
cd c:\Users\Kevin\Documents\LSP
build_nas_image.bat 1.1 lsp-calculator dist
```

Output files:

- `dist\lsp-calculator_1.1.tar` (or your chosen tag)
- `dist\lsp-calculator_1.1.tar.sha256.txt`

## 2) Copy artifact to NAS

Copy the `.tar` file to a NAS shared folder (for example `\\<NAS>\docker\imports`).

Example with `cmd.exe`:

```bat
copy c:\Users\Kevin\Documents\LSP\dist\lsp-calculator_1.1.tar \\<NAS>\docker\imports\
```

## 3) Import on Synology DSM 6 (Docker app)

1. Open **Docker** package
2. Go to **Image**
3. Click **Add** -> **Add from file**
4. Select `lsp-calculator_1.1.tar`
5. Wait for import
6. Launch container from imported image
7. Map local port `8501` to container port `8501`
8. Enable auto-restart

Open:

```text
http://<NAS-IP>:8501
```

## 4) Import on Synology DSM 7 (Container Manager)

1. Open **Container Manager**
2. Go to **Image**
3. Click **Add** -> **Add from file**
4. Select `lsp-calculator_1.1.tar`
5. Wait for import
6. Create container (or project) from the image
7. Map local port `8501` to container port `8501`

Open:

```text
http://<NAS-IP>:8501
```

## 5) Quick validation after launch

- Page loads successfully
- Upload sample CSV/XLSX works
- Calculation result table appears
- Excel export downloads successfully

Optional health endpoint:

```text
http://<NAS-IP>:8501/_stcore/health
```

## 6) Update/rollback tip

- Keep old image tag (example `1.0`) until new version is verified.
- If new version fails, relaunch container from previous image tag.

Related docs:

- `SYNOLOGY_NAS.md`
- `UPDATE_CHECKLIST.md`
