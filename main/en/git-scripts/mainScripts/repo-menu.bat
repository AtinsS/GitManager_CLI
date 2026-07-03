@echo off
setlocal enabledelayedexpansion
set "current_repo=%~1"

:REPO_MENU
set "current_repo=%~1"

:REPO_LOOP
cls
:: Get current branch for display
set "current_branch="
for /f "tokens=*" %%b in ('git branch --show-current 2^>nul') do set "current_branch=%%b"
if "!current_branch!"=="" (
  for /f "tokens=2" %%b in ('git branch 2^>nul ^| find "*"') do set "current_branch=%%b"
)
if "!current_branch!"=="" set "current_branch=unknown"

:: Get status
git status --porcelain | findstr . >nul 2>&1
if errorlevel 1 (
  set "repo_status=%GREEN%✅ clean%RESET%"
  ) else (
  set "repo_status=%YELLOW%⚠ has changes%RESET%"
)
call :SET_HOSTING_LABEL

echo %CYAN%  ════════════════════════════════════════════════════════════%RESET%
echo %BOLD%%WHITE%  Repository:%RESET% %GREEN%%current_repo%%RESET%  %BOLD%%WHITE%Hosting:%RESET% !hosting_label!  %BOLD%%WHITE%Branch:%RESET% %BLUE%!current_branch!%RESET%
echo %BOLD%%WHITE%  Status:%RESET% !repo_status!
echo %CYAN%  ════════════════════════════════════════════════════════════%RESET%
echo   %GREEN%1.%RESET% Git status              %GREEN%6.%RESET% Git merge
echo   %GREEN%2.%RESET% Git pull                %GREEN%7.%RESET% Git merge --abort
echo   %GREEN%3.%RESET% Add + Commit + Push     %GREEN%8.%RESET% Show branches for merge
echo   %GREEN%4.%RESET% Undo changes menu       %GREEN%9.%RESET% Create branch
echo   %GREEN%5.%RESET% View history            %GREEN%10.%RESET% Switch branch
echo                              %GREEN%11.%RESET% Auto-commits (every N minutes)
echo   %RED%0.%RESET% Return to main menu
echo.
set /p "repo_action=%BOLD%%WHITE% → %RESET%"

:: Check if scripts folder exists
if not exist "%SCRIPT_DIR%\git-scripts" (
  mkdir "%SCRIPT_DIR%\git-scripts" 2>nul
)

if "%repo_action%"=="1" (
  cls
  if exist "%SCRIPT_DIR%\git-scripts\01-git-status.bat" (
    call "%SCRIPT_DIR%\git-scripts\01-git-status.bat" "%current_repo%"
    ) else (
    echo %BOLD%%CYAN%  === GIT STATUS ===%RESET%
    echo.
    git status
    pause
  )
  goto REPO_LOOP
)

if "%repo_action%"=="2" (
  cls
  if exist "%SCRIPT_DIR%\git-scripts\02-git-pull.bat" (
    call "%SCRIPT_DIR%\git-scripts\02-git-pull.bat" "%current_repo%"
    ) else (
    echo %BOLD%%CYAN%  === GIT PULL ===%RESET%
    echo.
    git pull
    pause
  )
  goto REPO_LOOP
)

if "%repo_action%"=="3" (
  cls
  if exist "%SCRIPT_DIR%\git-scripts\03-git-commit.bat" (
    call "%SCRIPT_DIR%\git-scripts\03-git-commit.bat" "%current_repo%"
    ) else (
    echo %BOLD%%CYAN%  === GIT COMMIT ===%RESET%
    echo.
    set /p "commit_msg=%YELLOW%  Message: %RESET%
    git add .
    git commit -m "!commit_msg!"
    git push
    pause
  )
  goto REPO_LOOP
)

if "%repo_action%"=="4" (
  cls
  if exist "%SCRIPT_DIR%\git-scripts\04-git-menu-revert.bat" (
    call "%SCRIPT_DIR%\git-scripts\04-git-menu-revert.bat" "%current_repo%"
    ) else (
    echo %RED%  ❌ Undo menu script not found%RESET%
    pause
  )
  goto REPO_LOOP
)

if "%repo_action%"=="5" (
  cls
  if exist "%SCRIPT_DIR%\git-scripts\05-git-log.bat" (
    call "%SCRIPT_DIR%\git-scripts\05-git-log.bat" "%current_repo%"
    ) else (
    echo %BOLD%%CYAN%  === GIT LOG ===%RESET%
    echo.
    git log --oneline --graph --all -n 20
    pause
  )
  goto REPO_LOOP
)

if "%repo_action%"=="6" (
  cls
  if exist "%SCRIPT_DIR%\git-scripts\06-git-merge.bat" (
    call "%SCRIPT_DIR%\git-scripts\06-git-merge.bat" "%current_repo%"
    ) else (
    echo %RED%  ❌ Merge script not found%RESET%
    pause
  )
  goto REPO_LOOP
)

if "%repo_action%"=="7" (
  cls
  if exist "%SCRIPT_DIR%\git-scripts\07-git-merge-abort.bat" (
    call "%SCRIPT_DIR%\git-scripts\07-git-merge-abort.bat" "%current_repo%"
    ) else (
    echo %RED%  ❌ Merge cancel script not found%RESET%
    pause
  )
  goto REPO_LOOP
)

if "%repo_action%"=="8" (
  cls
  if exist "%SCRIPT_DIR%\git-scripts\08-git-merge-list.bat" (
    call "%SCRIPT_DIR%\git-scripts\08-git-merge-list.bat" "%current_repo%"
    ) else (
    echo %RED%  ❌ Branches view script not found%RESET%
    pause
  )
  goto REPO_LOOP
)

if "%repo_action%"=="9" (
  cls
  if exist "%SCRIPT_DIR%\git-scripts\09-git-create-branch.bat" (
    call "%SCRIPT_DIR%\git-scripts\09-git-create-branch.bat" "%current_repo%"
    ) else (
    echo %BOLD%%CYAN%  === CREATE BRANCH ===%RESET%
    echo.
    set /p "branch_name=%YELLOW%  Branch name: %RESET%
    git branch "!branch_name!"
    echo %GREEN%  ✅ Branch created%RESET%
    pause
  )
  goto REPO_LOOP
)

if "%repo_action%"=="10" (
  cls
  if exist "%SCRIPT_DIR%\git-scripts\10-git-switch-branch.bat" (
    call "%SCRIPT_DIR%\git-scripts\10-git-switch-branch.bat" "%current_repo%"
    ) else (
    echo %BOLD%%CYAN%  === SWITCH BRANCH ===%RESET%
    echo.
    git branch
    echo.
    set /p "branch_name=%YELLOW%  Branch to switch to: %RESET%
    git checkout "!branch_name!"
    pause
  )
  goto REPO_LOOP
)

if "%repo_action%"=="11" (
  cls
  if exist "%SCRIPT_DIR%\git-scripts\11-git-auto-commit.bat" (
    call "%SCRIPT_DIR%\git-scripts\11-git-auto-commit.bat" "%current_repo%"
    ) else (
    echo %RED%  ❌ Auto-commit script not found%RESET%
    pause
  )
  goto REPO_LOOP
)

if "%repo_action%"=="0" exit /b 0

echo %RED%  ❌ Invalid choice!%RESET%
pause
goto REPO_LOOP

:SET_HOSTING_LABEL
set "repo_url="
set "repo_hosting="
if defined CONFIG_FILE if exist "%CONFIG_FILE%" (
  for /f "usebackq tokens=1,2,3,4 delims=;" %%a in ("%CONFIG_FILE%") do (
    if /i "%%a"=="%current_repo%" (
      set "repo_url=%%c"
      set "repo_hosting=%%d"
    )
  )
)
if not defined repo_url (
  for /f "delims=" %%u in ('git config --get remote.origin.url 2^>nul') do set "repo_url=%%u"
)
if not defined repo_hosting if defined repo_url set "repo_hosting=Other"
if not defined repo_hosting set "repo_hosting=Local"
if /i "!repo_hosting!"=="Other" call :DETECT_HOSTING_FROM_URL
if /i "!repo_hosting!"=="Local" (
  set "hosting_label=%YELLOW%[Local]%RESET%"
  exit /b 0
)
if /i "!repo_hosting!"=="GitHub" (
  set "hosting_label=%CYAN%[GitHub]%RESET%"
  exit /b 0
)
if /i "!repo_hosting!"=="GitLab" (
  set "hosting_label=%MAGENTA%[GitLab]%RESET%"
  exit /b 0
)
if /i "!repo_hosting!"=="Bitbucket" (
  set "hosting_label=%BLUE%[Bitbucket]%RESET%"
  exit /b 0
)
if /i "!repo_hosting!"=="Azure DevOps" (
  set "hosting_label=%BLUE%[Azure DevOps]%RESET%"
  exit /b 0
)
if /i "!repo_hosting!"=="Codeberg" (
  set "hosting_label=%GREEN%[Codeberg]%RESET%"
  exit /b 0
)
if /i "!repo_hosting!"=="Gitea" (
  set "hosting_label=%GREEN%[Gitea]%RESET%"
  exit /b 0
)
if /i "!repo_hosting!"=="Git" (
  set "hosting_label=%WHITE%[Git]%RESET%"
  exit /b 0
)
set "hosting_label=%WHITE%[!repo_hosting!]%RESET%"
exit /b 0

:DETECT_HOSTING_FROM_URL
if not defined repo_url exit /b 0
if /i not "!repo_url:github=!"=="!repo_url!" set "repo_hosting=GitHub"
if /i not "!repo_url:gitlab=!"=="!repo_url!" set "repo_hosting=GitLab"
if /i not "!repo_url:bitbucket=!"=="!repo_url!" set "repo_hosting=Bitbucket"
if /i not "!repo_url:dev.azure.com=!"=="!repo_url!" set "repo_hosting=Azure DevOps"
if /i not "!repo_url:visualstudio.com=!"=="!repo_url!" set "repo_hosting=Azure DevOps"
if /i not "!repo_url:codeberg=!"=="!repo_url!" set "repo_hosting=Codeberg"
if /i not "!repo_url:gitea=!"=="!repo_url!" set "repo_hosting=Gitea"
if /i not "!repo_url:gitee=!"=="!repo_url!" set "repo_hosting=Gitea"
if /i "!repo_hosting!"=="Other" if /i not "!repo_url:git@=!"=="!repo_url!" set "repo_hosting=Git"
exit /b 0
