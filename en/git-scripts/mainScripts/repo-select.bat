@echo off
setlocal enabledelayedexpansion

:: Save passed repository name
set "repo_name=%~1"

:: If name not passed, try to get from temp file
if "%repo_name%"=="" if exist "%TEMP%\repo_index.tmp" (
    set /p repo_name=<"%TEMP%\repo_index.tmp"
)

:: Check name validity
if "%repo_name%"=="" (
    echo %RED%  ❌ Error: Repository name not specified%RESET%
    pause
    goto :eof
)

:: Get path and hosting by name from config
set "REPO_PATH="
set "REPO_HOSTING="

if defined CONFIG_FILE if exist "%CONFIG_FILE%" (
    for /f "usebackq tokens=1,2,3,4 delims=;" %%a in ("%CONFIG_FILE%") do (
        if /i "%%a"=="!repo_name!" (
            set "REPO_PATH=%%b"
            set "REPO_HOSTING=%%d"
        )
    )
)

if "!REPO_HOSTING!"=="" set "REPO_HOSTING=Local"

echo.
echo %BOLD%%WHITE%  Selected repository:%RESET% %GREEN%📁 !repo_name!%RESET%
echo %BOLD%%WHITE%  Path:%RESET% %CYAN%📌 !REPO_PATH!%RESET%

:: Save name to temp file for child processes
echo !repo_name!>"%TEMP%\repo_index.tmp"

:: Check if folder exists
if not exist "!REPO_PATH!" (
    echo.
    echo %RED%  ⚠ WARNING: Folder not found!%RESET%
    echo.
    echo %GREEN%  1.%RESET% Clone again
    echo %YELLOW%  2.%RESET% Specify new path
    echo %RED%  3.%RESET% Return to menu
    echo.
    set /p "fix=%BOLD%%WHITE%    Select action: %RESET%"
    
    if "!fix!"=="1" (
        call "%MAIN_SCRIPTS_DIR%\repo-maintenance.bat" CLONE_REPO_EXISTING "!repo_name!" "!REPO_PATH!"
        :: After cloning pass name forward
        call "%~f0" "!repo_name!"
        goto :eof
    ) else if "!fix!"=="2" (
        set /p "new_path=%YELLOW%    New path: %RESET%"
        call "%MAIN_SCRIPTS_DIR%\repo-maintenance.bat" UPDATE_REPO_PATH "!repo_name!" "!new_path!"
        set "REPO_PATH=!new_path!"
        cd /d "!REPO_PATH!" 2>nul
    ) else (
        del "%TEMP%\repo_index.tmp" 2>nul
        goto :eof
    )
) else (
    cd /d "!REPO_PATH!" 2>nul
)

:: Check if we changed directory successfully
if errorlevel 1 (
    echo %RED%  ❌ Error: Cannot change to folder!%RESET%
    del "%TEMP%\repo_index.tmp" 2>nul
    pause
    goto :eof
)

:: Check if it's a git repository
git status >nul 2>&1
if errorlevel 1 (
    echo %RED%  ❌ Error: Folder is not a git repository!%RESET%
    del "%TEMP%\repo_index.tmp" 2>nul
    pause
    goto :eof
)

:: Pass name to repository menu
call "%MAIN_SCRIPTS_DIR%\repo-menu.bat" "!repo_name!" "!REPO_HOSTING!"

:: Clean temp file after completion
del "%TEMP%\repo_index.tmp" 2>nul

goto :eof
