@echo off
setlocal enabledelayedexpansion
set "repo_index=%~1"
  :: Получаем имя и путь по индексу
  set "REPO_NAME=!repo_name_%repo_index%!"
  set "REPO_PATH=!repo_path_%repo_index%!"
  
  echo.
  echo %BOLD%%WHITE%  Выбран репозиторий:%RESET% %GREEN%📁 %REPO_NAME%%RESET%
  echo %BOLD%%WHITE%  Путь:%RESET% %CYAN%📌 %REPO_PATH%%RESET%
  
  :: Проверяем существует ли папка
  if not exist "%REPO_PATH%" (
    echo.
    echo %RED%  ⚠ ПРЕДУПРЕЖДЕНИЕ: Папка не найдена!%RESET%
    echo.
    echo %GREEN%  1.%RESET% Клонировать заново
    echo %YELLOW%  2.%RESET% Указать новый путь
    echo %RED%  3.%RESET% Вернуться в меню
    echo.
    set /p "fix=%BOLD%%WHITE%    Выберите действие: %RESET%"
    
    if "!fix!"=="1" (
      call "%MAIN_SCRIPTS_DIR%\repo-maintenance.bat" CLONE_REPO_EXISTING "%REPO_NAME%" "%REPO_PATH%"
      goto :eof
      ) else if "!fix!"=="2" (
      set /p "REPO_PATH=%YELLOW%    Новый путь: %RESET%"
      call "%MAIN_SCRIPTS_DIR%\repo-maintenance.bat" UPDATE_REPO_PATH "%REPO_NAME%" "!REPO_PATH!"
      cd /d "!REPO_PATH!" 2>nul
      ) else (
      goto :eof
    )
    ) else (
    cd /d "%REPO_PATH%" 2>nul
  )
  
  :: Проверяем что перешли успешно
  if errorlevel 1 (
    echo %RED%  ❌ Ошибка: Не могу перейти в папку!%RESET%
    pause
    goto :eof
  )
  
  :: Проверяем что это git репозиторий
  git status >nul 2>&1
  if errorlevel 1 (
    echo %RED%  ❌ Ошибка: Папка не является git репозиторием!%RESET%
    pause
    goto :eof
  )
  
  call "%MAIN_SCRIPTS_DIR%\repo-menu.bat" "%REPO_NAME%"
  goto :eof
