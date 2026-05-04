@echo off
setlocal enabledelayedexpansion

cls
echo %BOLD%%CYAN%  👥 MANAGE GROUPS%RESET%
echo.

if not exist "%GROUPS_FILE%" (
  echo %YELLOW%  No groups created yet%RESET%
  echo.
  set /p "create=%YELLOW%  Create first group? [y/n]: %RESET%"
  if /i "!create!"=="y" goto ADD_GROUP
  exit /b 0
)

:GROUPS_MENU
cls
echo %BOLD%%CYAN%  👥 MANAGE GROUPS%RESET%
echo.
echo %GREEN%  Current groups:%RESET%
echo  ─────────────────────
type "%GROUPS_FILE%" | find /c ";" >nul
if errorlevel 1 (
  echo %YELLOW%  No groups%RESET%
) else (
  for /f "tokens=1 delims=;" %%a in ('type "%GROUPS_FILE%"') do (
    echo  • %%a
  )
)
echo.
echo  [1] Add group
echo  [2] Delete group
echo  [3] Manage group members
echo  [0] Back
echo.
set /p "choice=%YELLOW%    Your choice: %RESET%"

if "%choice%"=="1" goto ADD_GROUP
if "%choice%"=="2" goto DELETE_GROUP
if "%choice%"=="3" goto MANAGE_GROUP
if "%choice%"=="0" exit /b 0

echo %RED%❌ Invalid choice!%RESET%
timeout /t 1 >nul
goto GROUPS_MENU

:ADD_GROUP
echo.
set /p "new_group=%WHITE%  Group name: %RESET%"
if "!new_group!"=="" (
  echo %RED%❌ Name cannot be empty!%RESET%
  pause
  goto GROUPS_MENU
)

findstr /b /c:"!new_group!;" "%GROUPS_FILE%" >nul 2>&1 && (
  echo %YELLOW%  Group already exists!%RESET%
  pause
  goto GROUPS_MENU
)

>> "%GROUPS_FILE%" echo !new_group!;
echo %GREEN%✅ Group created!%RESET%
pause
goto GROUPS_MENU

:DELETE_GROUP
echo.
set /p "del_group=%WHITE%  Group to delete: %RESET%"
findstr /b /c:"!del_group!;" "%GROUPS_FILE%" >nul 2>&1 || (
  echo %RED%❌ Group not found!%RESET%
  pause
  goto GROUPS_MENU
)

set /p "confirm=%YELLOW%  Confirm deletion? [y/n]: %RESET%"
if /i not "!confirm!"=="y" (
  echo %YELLOW%  Cancelled%RESET%
  pause
  goto GROUPS_MENU
)

for /f "tokens=*" %%a in ('type "%GROUPS_FILE%"') do (
  if not "%%a"=="!del_group!;" >> "%GROUPS_FILE%.tmp" echo %%a
)
move /y "%GROUPS_FILE%.tmp" "%GROUPS_FILE%" >nul
echo %GREEN%✅ Group deleted!%RESET%
pause
goto GROUPS_MENU

:MANAGE_GROUP
echo.
set /p "manage_group=%WHITE%  Group to manage: %RESET%"
echo %GREEN%✅ Function available in full version%RESET%
pause
goto GROUPS_MENU
