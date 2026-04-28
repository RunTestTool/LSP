@echo off
setlocal

REM Build and export Docker image for Synology NAS import.
REM Usage:
REM   build_nas_image.bat [tag] [image_name] [output_dir]
REM Example:
REM   build_nas_image.bat 1.1 lsp-calculator dist

set "IMAGE_TAG=1.0"
set "IMAGE_NAME=lsp-calculator"
set "OUTPUT_DIR=dist"

if not "%~1"=="" set "IMAGE_TAG=%~1"
if not "%~2"=="" set "IMAGE_NAME=%~2"
if not "%~3"=="" set "OUTPUT_DIR=%~3"

set "IMAGE_REF=%IMAGE_NAME%:%IMAGE_TAG%"
set "ARTIFACT=%OUTPUT_DIR%\%IMAGE_NAME%_%IMAGE_TAG%.tar"
set "CHECKSUM_FILE=%ARTIFACT%.sha256.txt"

echo [1/4] Checking Docker availability...
docker version >nul 2>&1
if errorlevel 1 (
  echo ERROR: Docker is not available. Start Docker Desktop first.
  exit /b 1
)

echo [2/4] Building image %IMAGE_REF% ...
docker build -t "%IMAGE_REF%" .
if errorlevel 1 (
  echo ERROR: Docker build failed.
  exit /b 1
)

if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo [3/4] Exporting image to %ARTIFACT% ...
docker save -o "%ARTIFACT%" "%IMAGE_REF%"
if errorlevel 1 (
  echo ERROR: Docker save failed.
  exit /b 1
)

echo [4/4] Generating SHA256 checksum...
certutil -hashfile "%ARTIFACT%" SHA256 > "%CHECKSUM_FILE%"
if errorlevel 1 (
  echo WARNING: Checksum generation failed. Artifact is still created.
) else (
  echo Checksum file: %CHECKSUM_FILE%
)

echo.
echo Done.
echo Image ref : %IMAGE_REF%
echo Artifact  : %ARTIFACT%
echo.
echo Next step on Synology:
echo - DSM 6 Docker app: Image ^> Add ^> From File
echo - DSM 7 Container Manager: Image ^> Add ^> From File

exit /b 0
