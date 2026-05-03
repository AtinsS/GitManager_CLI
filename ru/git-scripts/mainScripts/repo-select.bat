@echo off
setlocal enabledelayedexpansion
<<<<<<< HEAD

:: Сохраняем переданное имя репозитория
set "repo_name=%~1"

:: Если имя не передано, пытаемся получить из временного файла
if "%repo_name%"=="" if exist "%TEMP%\repo_index.tmp" (
    set /p repo_name=<"%TEMP%\repo_index.tmp"
)

:: Проверяем валидность имени
if "%repo_name%"=="" (
    echo %RED%  ❌ Ошибка: Не указано имя репозитория%RESET%
    pause
    goto :eof
)

:: Получаем путь и хостинг по имени из конфига
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
echo %BOLD%%WHITE%  Выбран репозиторий:%RESET% %GREEN%📁 !repo_name!%RESET%
echo %BOLD%%WHITE%  Путь:%RESET% %CYAN%📌 !REPO_PATH!%RESET%

:: Сохраняем имя во временный файл для дочерних процессов
echo !repo_name!>"%TEMP%\repo_index.tmp"

:: Проверяем существует ли папка
if not exist "!REPO_PATH!" (
=======
set "repo_index=%~1"
  :: Получаем имя и путь по индексу
  set "REPO_NAME=!repo_name_%repo_index%!"
  set "REPO_PATH=!repo_path_%repo_index%!"
  
  echo.
  echo %BOLD%%WHITE%  Выбран репозиторий:%RESET% %GREEN%📁 %REPO_NAME%%RESET%
  echo %BOLD%%WHITE%  Путь:%RESET% %CYAN%📌 %REPO_PATH%%RESET%
  
  :: Проверяем существует ли папка
  if not exist "%REPO_PATH%" (
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
    echo.
    echo %RED%  ⚠ ПРЕДУПРЕЖДЕНИЕ: Папка не найдена!%RESET%
    echo.
    echo %GREEN%  1.%RESET% Клонировать заново
    echo %YELLOW%  2.%RESET% Указать новый путь
    echo %RED%  3.%RESET% Вернуться в меню
    echo.
    set /p "fix=%BOLD%%WHITE%    Выберите действие: %RESET%"
    
    if "!fix!"=="1" (
<<<<<<< HEAD
        call "%MAIN_SCRIPTS_DIR%\repo-maintenance.bat" CLONE_REPO_EXISTING "!repo_name!" "!REPO_PATH!"
        :: После клонирования передаём имя дальше
        call "%~f0" "!repo_name!"
        goto :eof
    ) else if "!fix!"=="2" (
        set /p "new_path=%YELLOW%    Новый путь: %RESET%"
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

:: Проверяем что перешли успешно
if errorlevel 1 (
    echo %RED%  ❌ Ошибка: Не могу перейти в папку!%RESET%
    del "%TEMP%\repo_index.tmp" 2>nul
    pause
    goto :eof
)

:: Проверяем что это git репозиторий
git status >nul 2>&1
if errorlevel 1 (
    echo %RED%  ❌ Ошибка: Папка не является git репозиторием!%RESET%
    del "%TEMP%\repo_index.tmp" 2>nul
    pause
    goto :eof
)

:: Передаём имя в меню репозитория
call "%MAIN_SCRIPTS_DIR%\repo-menu.bat" "!repo_name!" "!REPO_HOSTING!"

:: Очищаем временный файл после завершения
del "%TEMP%\repo_index.tmp" 2>nul

goto :eof
=======
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
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
