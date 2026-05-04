@echo off
setlocal enabledelayedexpansion enableextensions
set "ORIG_DIR=%CD%"

REM Force clear potentially conflicting variables
if defined GH_TOKEN (
  echo %YELLOW%Warning: GH_TOKEN variable will be cleared%RESET%
  set "GH_TOKEN="
)
if defined GITHUB_TOKEN (
  echo %YELLOW%Warning: GITHUB_TOKEN variable will be cleared%RESET%
  set "GITHUB_TOKEN="
)
if defined GLAB_TOKEN (
  echo %YELLOW%Warning: GLAB_TOKEN variable will be cleared%RESET%
  set "GLAB_TOKEN="
)

:ADD_REPO_MENU
cls
echo %BOLD%%CYAN%  📂 ADD REPOSITORY%RESET%
echo.
echo %WHITE%  Select type:%RESET%
echo  [1] Add existing git repository
echo  [2] Create new git repository (git init)
echo  [3] GitHub / GitLab Authorization
echo  [4] Back to main menu
echo.
choice /c 1234 /n /m "%YELLOW%    Your choice: %RESET%"

if errorlevel 4 exit /b 0
if errorlevel 3 goto AUTH_MENU
if errorlevel 2 goto ADD_NEW
if errorlevel 1 goto ADD_EXISTING

:ADD_EXISTING
cls
echo %BOLD%%CYAN%  📦 ADD EXISTING REPOSITORY%RESET%
echo.
set /p "repo_path=%YELLOW%    Path to git repository: %RESET%"
set "repo_path=!repo_path:"=!"

if "!repo_path!"=="" (
  echo %RED%  ❌ Path cannot be empty!%RESET%
  pause
  goto ADD_REPO_MENU
)

if not exist "!repo_path!" (
  echo %RED%  ❌ Folder not found!%RESET%
  pause
  goto ADD_REPO_MENU
)

pushd "!repo_path!" 2>nul || (
  echo %RED%  ❌ Access error to folder!%RESET%
  pause
  goto ADD_REPO_MENU
)

git status >nul 2>&1 && (
  set "remote_url="
  for /f "delims=" %%u in ('git config --get remote.origin.url 2^>nul') do set "remote_url=%%u"
  call :DETECT_HOSTING
  for %%I in ("!repo_path!") do set "repo_name=%%~nxI"
  popd
  set /p "repo_name_input=%GREEN%    Name in Git Manager [!repo_name!]: %RESET%"
  if not "!repo_name_input!"=="" set "repo_name=!repo_name_input!"
  findstr /b /c:"!repo_name!;" "%CONFIG_FILE%" >nul 2>&1 && (
    echo %YELLOW%  Repository with this name already in list%RESET%
    pause
    exit /b 0
  )
  >> "%CONFIG_FILE%" echo(!repo_name!;!repo_path!;!remote_url!;!hosting!
  echo %GREEN%  ✅ Repository added!%RESET%
  set /p "add_to_group=%YELLOW%    Add to group? [y/n]: %RESET%"
  if /i "!add_to_group!"=="y" call "%MAIN_SCRIPTS_DIR%\groups.bat" ADD_REPO_TO_GROUP "!repo_name!"
  pause
  exit /b 0
) || (
  popd
  echo %RED%  ❌ This is not a git repository!%RESET%
  pause
  goto ADD_REPO_MENU
)

:ADD_NEW
cls
echo %BOLD%%CYAN%  🆕 CREATE NEW REPOSITORY%RESET%
echo.
set /p "repo_name=%GREEN%    Repository name: %RESET%"
if "!repo_name!"=="" (
  echo %RED%  ❌ Name cannot be empty!%RESET%
  pause
  goto ADD_REPO_MENU
)

set /p "parent_path=%YELLOW%    Parent folder: %RESET%"
if "!parent_path!"=="" (
  echo %RED%  ❌ Folder cannot be empty!%RESET%
  pause
  goto ADD_REPO_MENU
)

if not exist "!parent_path!" mkdir "!parent_path!" 2>nul

set "repo_path=!parent_path!\!repo_name!"
mkdir "!repo_path!" 2>nul
cd /d "!repo_path!" 2>nul

git init
set "hosting=Local"
>> "%CONFIG_FILE%" echo(!repo_name!;!repo_path!;;!hosting!
echo %GREEN%  ✅ Repository created!%RESET%
pause
goto ADD_REPO_MENU

:AUTH_MENU
cls
echo %BOLD%%CYAN%  🔑 AUTHORIZATION%RESET%
echo.
echo %WHITE%  Platform:%RESET%
echo  [1] GitHub
echo  [2] GitLab
echo  [0] Back
echo.
choice /c 120 /n /m "%YELLOW%    Your choice: %RESET%"
if errorlevel 3 goto ADD_REPO_MENU
if errorlevel 2 goto AUTH_GITLAB
if errorlevel 1 goto AUTH_GITHUB

:AUTH_GITHUB
where gh >nul 2>&1 || (
  echo %RED%❌ GitHub CLI not found%RESET%
  pause
  goto AUTH_MENU
)
gh auth login
goto AUTH_MENU

:AUTH_GITLAB
where glab >nul 2>&1 || (
  echo %RED%❌ GitLab CLI not found%RESET%
  pause
  goto AUTH_MENU
)
glab auth login
goto AUTH_MENU

:DETECT_HOSTING
set "hosting=Local"
if not defined remote_url exit /b 0
if /i not "!remote_url:github=!"=="!remote_url!" set "hosting=GitHub"
if /i not "!remote_url:gitlab=!"=="!remote_url!" set "hosting=GitLab"
if /i not "!remote_url:bitbucket=!"=="!remote_url!" set "hosting=Bitbucket"
exit /b 0
