@echo off
setlocal enabledelayedexpansion

:: Path to the folder with this script
set "INSTALL_DIR=%~dp0"
if "%INSTALL_DIR:~-1%"=="\" set "INSTALL_DIR=%INSTALL_DIR:~0,-1%"

cls
echo.
echo   ============================================================
echo         GitManager CLI - Command Uninstallation
echo   ============================================================
echo.
echo   Location: %INSTALL_DIR%
echo.

:: Read current PATH from registry
set "CURRENT_PATH="
for /f "tokens=2*" %%a in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "CURRENT_PATH=%%b"

:: Check if our path exists
if defined CURRENT_PATH (
    echo "!CURRENT_PATH!" | findstr /i /c:"!INSTALL_DIR!" >nul 2>&1
    if errorlevel 1 (
        echo   [INFO] GitManager CLI is not installed. Nothing to remove.
        echo.
        pause
        exit /b 0
    )
) else (
    echo   [INFO] PATH is empty. Nothing to remove.
    echo.
    pause
    exit /b 0
)

echo   Removing from PATH...
echo.

:: Remove the directory from PATH
set "NEW_PATH=!CURRENT_PATH:%INSTALL_DIR%;=!"
set "NEW_PATH=!NEW_PATH:;%INSTALL_DIR%=!"
set "NEW_PATH=!NEW_PATH:%INSTALL_DIR%=!"

:: Clean up double semicolons
set "NEW_PATH=!NEW_PATH:;;=;!"
if "!NEW_PATH:~0,1!"==";" set "NEW_PATH=!NEW_PATH:~1!"
if "!NEW_PATH:~-1!"==";" set "NEW_PATH=!NEW_PATH:~0,-1!"

:: Apply new PATH
if defined NEW_PATH (
    setx PATH "!NEW_PATH!" >nul 2>&1
) else (
    setx PATH "" >nul 2>&1
)

if errorlevel 1 (
    echo   [ERROR] Failed to update PATH!
    echo   Try running as administrator.
    echo.
    pause
    exit /b 1
)

echo   [SUCCESS] Uninstallation complete!
echo.
echo   +----------------------------------------+
echo   ^| GitManager CLI removed from PATH           ^|
echo   ^| Open a new terminal to apply changes   ^|
echo   +----------------------------------------+
echo.
pause
exit /b 0