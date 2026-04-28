# Synology NAS Update Checklist (Container Manager)

Use this one-page checklist for routine updates of the `lsp-calculator` project on Synology DSM.

> This checklist targets DSM 7 Project-based deployments.
> If you are on DSM 6 Docker package, use the DSM 6 section in [`SYNOLOGY_NAS.md`](SYNOLOGY_NAS.md).

## 1) Pre-Update Preparation

- [ ] Confirm maintenance window and expected brief downtime
- [ ] Confirm current app URL is reachable: `http://<NAS-IP>:8501`
- [ ] Confirm current project/container is healthy in DSM Container Manager
- [ ] Confirm rollback source exists (previous release folder)
- [ ] Decide new release folder name (example: `/volume1/docker/lsp-calculator/releases/2026-05-10`)

## 2) Copy New Release

- [ ] Copy updated project files to the new release folder
- [ ] Verify required files exist in the new folder:
  - [ ] `app.py`
  - [ ] `requirements.txt`
  - [ ] `Dockerfile`
  - [ ] `docker-compose.synology.yml`
  - [ ] `.streamlit/config.toml`
- [ ] Keep previous release folder unchanged for rollback

## 3) Deploy New Release

- [ ] Open DSM **Container Manager** -> **Project**
- [ ] Select project `lsp-calculator`
- [ ] Edit/recreate project to point to the new release folder
- [ ] Deploy / rebuild project
- [ ] Wait until project status is `running`

## 4) Post-Deploy Verification

- [ ] Open app: `http://<NAS-IP>:8501`
- [ ] Confirm page renders without server error
- [ ] Upload a small test file (CSV/XLSX)
- [ ] Run calculation and confirm results table appears
- [ ] Download Excel output successfully
- [ ] Optional health endpoint check: `http://<NAS-IP>:8501/_stcore/health` (expect `ok`)

## 5) Rollback Trigger

Rollback immediately if any of these occurs:

- [ ] App URL not reachable after deploy
- [ ] Container fails to stay `running`
- [ ] Health endpoint fails repeatedly
- [ ] Critical calculation/export flow fails in smoke test

## 6) Rollback Steps

- [ ] Stop current failed project/container
- [ ] Switch project path back to previous release folder
- [ ] Redeploy previous release
- [ ] Re-verify app URL and smoke test
- [ ] Record failed release folder/version for investigation

## 7) Close-Out Notes

- [ ] Record deployed release path/date
- [ ] Record operator name and time completed
- [ ] Record whether rollback was needed
- [ ] Archive update notes / issues found

## Optional Low-Downtime Method (Advanced)

- [ ] Deploy new release as second project on another port (example `18501`)
- [ ] Verify new version on the alternate port
- [ ] Switch Synology Reverse Proxy destination to new port
- [ ] Stop old project after successful cutover
