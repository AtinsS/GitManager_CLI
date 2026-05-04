@echo off
chcp 65001 >nul
call "%~dp0utils.bat"

echo ⬇️ Git Pull for repository: %~1
echo ================================
git pull
if errorlevel 1 (
  echo %RED%❌ Error during update!%RESET%
  ) else (
  echo %GREEN%✅ Repository successfully updated!%RESET%
)
echo.
pause
