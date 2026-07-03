@echo off
setlocal enabledelayedexpansion
  cls
  echo %BOLD%%CYAN%  📥 CLONE REPOSITORY%RESET%
  echo.
  set /p "repo_name=%GREEN%    📦 Repository name: %RESET%"
  set /p "repo_url=%YELLOW%    🔗 Repository URL: %RESET%"
  set /p "clone_path=%BLUE%    📁 Clone path (Enter - current folder): %RESET%"
  
  if "!clone_path!"=="" set "clone_path=%cd%"
  if not exist "!clone_path!" mkdir "!clone_path!" 2>nul
  
  set "full_path=!clone_path!\!repo_name!"
  
  echo.
  echo %BOLD%  ⏳ Cloning %repo_name% from %repo_url% to %full_path%...%RESET%
  git clone "%repo_url%" "%full_path%"
  
  if errorlevel 1 (
    echo %RED%  ❌ Clone error!%RESET%
    pause
    exit /b 0
  )
  
  call :DETECT_HOSTING
  >> "%CONFIG_FILE%" echo(!repo_name!;!full_path!;!repo_url!;!hosting!
  echo %GREEN%  ✅ Repository successfully cloned and added to list!%RESET%
  
  :: Ask about group
  echo.
  echo %BOLD%%WHITE%  Adding to group:%RESET%
  set /p "add_to_group=%YELLOW%    Add repository to group? [y/n]: %RESET%"
  
  if /i "!add_to_group!"=="y" call "%MAIN_SCRIPTS_DIR%\groups.bat" ADD_REPO_TO_GROUP "%repo_name%"
  
  pause
  exit /b 0

:DETECT_HOSTING
set "hosting=Local"
if not defined repo_url exit /b 0
if /i not "!repo_url:github=!"=="!repo_url!" set "hosting=GitHub"
if /i not "!repo_url:gitlab=!"=="!repo_url!" set "hosting=GitLab"
if /i not "!repo_url:bitbucket=!"=="!repo_url!" set "hosting=Bitbucket"
if /i not "!repo_url:dev.azure.com=!"=="!repo_url!" set "hosting=Azure DevOps"
if /i not "!repo_url:visualstudio.com=!"=="!repo_url!" set "hosting=Azure DevOps"
if /i not "!repo_url:codeberg=!"=="!repo_url!" set "hosting=Codeberg"
if /i not "!repo_url:gitea=!"=="!repo_url!" set "hosting=Gitea"
if /i not "!repo_url:gitee=!"=="!repo_url!" set "hosting=Gitea"
if "!hosting!"=="Local" set "hosting=Other"
exit /b 0
