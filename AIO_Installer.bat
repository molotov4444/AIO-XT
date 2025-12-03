@echo off
title AIO Installer - Google Drive Large File
cls

:: ===============================
:: 1. Set your Google Drive File ID
:: ===============================
set "FILEID=1yZY7r2HUljhmuVS4WnuQvdyOdSFYYxlX"
set "ZIPFILE=AIO.zip"
set "EXTRACT_DIR=AIO"
set "DESKTOP=%USERPROFILE%\Desktop"

echo ===========================================
echo   Downloading AIO.zip from Google Drive
echo ===========================================

:: ===============================
:: 2. Download using PowerShell (bypass virus warning)
:: ===============================
powershell -Command "$url='https://drive.google.com/uc?export=download&id=%FILEID%'; $wc = New-Object System.Net.WebClient; $wc.Headers.Add('user-agent','Mozilla/5.0'); $html = $wc.DownloadString($url); if ($html -match 'confirm=([0-9A-Za-z_]+)') { $confirm=$matches[1]; $url='https://drive.google.com/uc?export=download&confirm='+$confirm+'&id=%FILEID%'}; Write-Host 'Downloading...'; $wc.DownloadFile($url,'%ZIPFILE%')"

if not exist "%ZIPFILE%" (
    echo ERROR: Download failed!
    pause
    exit
)

echo.
echo ===========================================
echo   Download Complete!
echo ===========================================
echo.

:: ===============================
:: 3. Extract ZIP with simple animation
:: ===============================
echo Extracting files...

set chars=\|/- 
for /l %%a in (1,1,15) do (
    for %%b in (%chars%) do (
        <nul set /p "=Extracting %%b `r"
        timeout /t 1 >nul
    )
)

powershell -Command "Expand-Archive -Force '%ZIPFILE%' '%EXTRACT_DIR%'"

echo.
echo ===========================================
echo   Extraction Completed!
echo ===========================================
echo.

:: ===============================
:: 4. Move folders to Desktop
:: ===============================
echo Moving folders to Desktop...

for /d %%D in ("%EXTRACT_DIR%\*") do (
    echo Moving folder: %%~nxD
    move /Y "%%D" "%DESKTOP%" >nul
)

echo.
echo ===========================================
echo   Folders moved successfully!
echo ===========================================
echo.

:: ===============================
:: 5. Run all EXE files (no wait, 3s delay)
:: ===============================
echo Launching all installers...

for %%F in ("%EXTRACT_DIR%\*.exe") do (
    echo Running: %%~nxF
    start "" "%%F"
    timeout /t 3 >nul
)

echo.
echo ===========================================
echo   ALL INSTALLERS STARTED
echo ===========================================
pause
exit
