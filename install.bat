@echo off
setlocal enabledelayedexpansion

:: Path to the folder with this script
set "INSTALL_DIR=%~dp0"
if "%INSTALL_DIR:~-1%"=="\" set "INSTALL_DIR=%INSTALL_DIR:~0,-1%"

cls
echo.
echo   ============================================================
echo         GitManager CLI - Command Installation
echo   ============================================================
echo.
echo   Location: %INSTALL_DIR%
echo.

:: Check for gitmanager.bat
if not exist "%INSTALL_DIR%\gitmanager.bat" (
    echo   [ERROR] gitmanager.bat not found in this folder!
    echo.
    pause
    exit /b 1
)

:: Read current PATH from registry
set "CURRENT_PATH="
for /f "tokens=2*" %%a in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "CURRENT_PATH=%%b"

:: Check if our path already exists
if defined CURRENT_PATH (
    echo "!CURRENT_PATH!" | findstr /i /c:"!INSTALL_DIR!" >nul 2>&1
    if not errorlevel 1 (
        echo   [OK] Already installed!
        echo.
        echo   Usage: gitmanager
        echo.
        pause
        exit /b 0
    )
)

:: Add via setx
echo   Adding to PATH...
echo.

if defined CURRENT_PATH (
    setx PATH "!CURRENT_PATH!;!INSTALL_DIR!" >nul 2>&1
) else (
    setx PATH "!INSTALL_DIR!" >nul 2>&1
)

if errorlevel 1 (
    echo   [ERROR] Failed! Try running as administrator.
    echo.
    pause
    exit /b 1
)

echo   [SUCCESS] Installation complete!
echo.
echo   +----------------------------------------+
echo   ^| Open a new terminal and run:           ^|
echo   ^| gitmanager                             ^|
echo   +----------------------------------------+
echo.
pause
exit /b 0