@echo off
chcp 65001 >nul
call "%~dp0utils.bat"

echo 📋 Branches for merge
echo ====================
echo.

:: Get current branch
for /f "tokens=*" %%b in ('git branch --show-current 2^>nul') do set "current_branch=%%b"
if "!current_branch!"=="" (
    for /f "tokens=2" %%b in ('git branch 2^>nul ^| find "*"') do set "current_branch=%%b"
)
if "!current_branch!"=="" set "current_branch=unknown"

echo %GREEN%Current branch: !current_branch!%RESET%
echo.
echo %WHITE%All branches (can merge any into current):%RESET%
echo ------------------------------------------------

:: Show branches with additional information
for /f "tokens=*" %%b in ('git branch -v 2^>nul') do (
    echo %%b | find "*" >nul && (
        echo %GREEN%  %%b%RESET%
    ) || (
        echo %YELLOW%  %%b%RESET%
    )
)

echo.
echo %WHITE%Remote branches:%RESET%
echo ------------------------------------------------
git branch -r 2>nul | findstr /v "HEAD" | findstr /v "->"

echo.
echo %WHITE%💡 Tip:%RESET%
echo   To merge a branch into current use option "6" in main menu
echo   or run: git merge ^<branch_name^>
echo.
pause
