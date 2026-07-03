@echo off
setlocal enabledelayedexpansion
  cls
  echo %BOLD%%CYAN%  📥 КЛОНИРОВАНИЕ РЕПОЗИТОРИЯ%RESET%
  echo.
  set /p "repo_name=%GREEN%    📦 Имя репозитория: %RESET%"
  set /p "repo_url=%YELLOW%    🔗 URL репозитория: %RESET%"
  set /p "clone_path=%BLUE%    📁 Путь для клонирования (Enter - текущая папка): %RESET%"
  
  if "!clone_path!"=="" set "clone_path=%cd%"
  if not exist "!clone_path!" mkdir "!clone_path!" 2>nul
  
  set "full_path=!clone_path!\!repo_name!"
  
  echo.
  echo %BOLD%  ⏳ Клонирование %repo_name% из %repo_url% в %full_path%...%RESET%
  git clone "%repo_url%" "%full_path%"
  
  if errorlevel 1 (
    echo %RED%  ❌ Ошибка клонирования!%RESET%
    pause
    exit /b 0
  )
  
  call :DETECT_HOSTING
  >> "%CONFIG_FILE%" echo(!repo_name!;!full_path!;!repo_url!;!hosting!
  echo %GREEN%  ✅ Репозиторий успешно клонирован и добавлен в список!%RESET%
  
  :: Спрашиваем про группу
  echo.
  echo %BOLD%%WHITE%  Добавление в группу:%RESET%
  set /p "add_to_group=%YELLOW%    Добавить репозиторий в группу? [y/n]: %RESET%"
  
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
