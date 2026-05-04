@echo off
chcp 65001 >nul
call "%~dp0utils.bat"

echo ⛔ Cancel merge (MERGE --ABORT)
echo =================================
echo.

:: Check if merge process is active
git status 2>nul | find "merging" >nul
if errorlevel 1 (
    echo %YELLOW%⚠ There is no active merge process at the moment%RESET%
    echo.
    set /p "force_abort=Force reset state? (y/n): "
    if /i "!force_abort!"=="y" (
        echo.
        echo ⏳ Running git merge --abort...
        git merge --abort 2>&1
        if errorlevel 1 (
            echo %YELLOW%⚠ Command not executed. Might not have active merge%RESET%
        ) else (
            echo %GREEN%✅ Merge cancelled%RESET%
        )
    ) else (
        echo %YELLOW%❌ Cancelled%RESET%
    )
    pause
    exit /b
)

echo %RED%⚠ Active merge process detected!%RESET%
echo.
echo %YELLOW%Running git merge --abort will cancel the current merge%RESET%
echo %YELLOW%and return the repository to state before merge.%RESET%
echo.
set /p "confirm=Confirm merge cancellation? (y/n): "

if /i not "!confirm!"=="y" (
    echo %YELLOW%❌ Merge cancellation cancelled%RESET%
    pause
    exit /b
)

echo.
echo ⏳ Running git merge --abort...
git merge --abort 2>&1

if errorlevel 1 (
    echo %RED%❌ Error cancelling merge!%RESET%
    echo %YELLOW%📋 Possible causes:%RESET%
    echo   - No active merge
    echo   - Permission issues
) else (
    echo %GREEN%✅ Merge successfully cancelled!%RESET%
    echo %GREEN%📁 Repository restored to original state%RESET%
)

echo.
pause
