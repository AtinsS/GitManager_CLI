@echo off
setlocal enabledelayedexpansion

set "option=%~1"

:MAINTENANCE_MENU
if "%option%"=="" (
  cls
  echo %BOLD%%CYAN%  🔧 REPOSITORY MAINTENANCE%RESET%
  echo.
  echo  [1] Update repository
  echo  [2] Delete repository
  echo  [3] Settings
  echo  [0] Back
  echo.
  set /p "choice=%YELLOW%    Your choice: %RESET%"
  
  if "%choice%"=="1" set "option=UPDATE_ALL"
  if "%choice%"=="2" set "option=DELETE_REPO"
  if "%choice%"=="3" set "option=SETTINGS"
  if "%choice%"=="0" exit /b 0
)

if /i "%option%"=="UPDATE_ALL" (
  cls
  echo %BOLD%%CYAN%  ⏳ UPDATING ALL REPOSITORIES%RESET%
  echo.
  
  if exist "%CONFIG_FILE%" (
    for /f "usebackq tokens=1,2 delims=;" %%a in ("%CONFIG_FILE%") do (
      if exist "%%b" (
        echo Updating %%a...
        cd /d "%%b" 2>nul && git pull >nul 2>&1
        if errorlevel 1 (
          echo %RED%  ❌ Error in %%a%RESET%
        ) else (
          echo %GREEN%  ✅ Updated %%a%RESET%
        )
      )
    )
  )
  
  echo %GREEN%✅ Update complete!%RESET%
  pause
  exit /b 0
)

if /i "%option%"=="DELETE_REPO" (
  cls
  echo %BOLD%%CYAN%  🗑 DELETE REPOSITORY%RESET%
  echo.
  set /p "repo_name=%WHITE%  Repository name: %RESET%"
  
  if "!repo_name!"=="" exit /b 0
  
  findstr /b /c:"!repo_name!;" "%CONFIG_FILE%" >nul 2>&1 || (
    echo %RED%❌ Repository not found!%RESET%
    pause
    exit /b 0
  )
  
  set /p "confirm=%YELLOW%  Delete (from manager only)? [y/n]: %RESET%"
  if /i not "!confirm!"=="y" exit /b 0
  
  for /f "tokens=*" %%a in ('type "%CONFIG_FILE%"') do (
    if not "%%a"=="!repo_name!;" >> "%CONFIG_FILE%.tmp" echo %%a
  )
  move /y "%CONFIG_FILE%.tmp" "%CONFIG_FILE%" >nul
  echo %GREEN%✅ Repository removed!%RESET%
  pause
  exit /b 0
)

if /i "%option%"=="SETTINGS" (
  cls
  echo %BOLD%%CYAN%  ⚙ SETTINGS%RESET%
  echo.
  echo  [1] Git config
  echo  [0] Back
  echo.
  set /p "choice=%YELLOW%    Your choice: %RESET%"
  
  if "%choice%"=="1" (
    git config --global user.name
    git config --global user.email
  )
  exit /b 0
)

echo %RED%❌ Unknown option: %option%%RESET%
pause
