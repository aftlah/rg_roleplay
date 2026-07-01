@echo off
setlocal EnableExtensions

set "ROOT=%~dp0"
set "TXHOST_DATA_PATH=%ROOT%txData"

cd /d "%ROOT%artifacts"

echo.
echo ==========================================
echo   RG Roleplay - txAdmin
echo   Panel web: http://localhost:40120
echo ==========================================
echo.
echo Pastikan tidak ada FXServer lain yang masih jalan.
echo Start server dari panel txAdmin, jangan pakai start_server.bat.
echo.

.\FXServer.exe +set serverProfile default

endlocal
