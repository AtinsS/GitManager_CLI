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
  
  echo %repo_name%;%full_path% >> "%CONFIG_FILE%"
  echo %GREEN%  ✅ Репозиторий успешно клонирован и добавлен в список!%RESET%
  
  :: Спрашиваем про группу
  echo.
  echo %BOLD%%WHITE%  Добавление в группу:%RESET%
  set /p "add_to_group=%YELLOW%    Добавить репозиторий в группу? [y/n]: %RESET%"
  
  if /i "!add_to_group!"=="y" call "%MAIN_SCRIPTS_DIR%\groups.bat" ADD_REPO_TO_GROUP "%repo_name%"
  
  pause
  exit /b 0
