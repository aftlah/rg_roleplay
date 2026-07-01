@echo off
setlocal EnableExtensions

echo.
echo [INFO] start_server.bat dinonaktifkan agar txAdmin bisa mengontrol server.
echo [INFO] Menjalankan start_txadmin.bat ...
echo.

call "%~dp0start_txadmin.bat"

endlocal
