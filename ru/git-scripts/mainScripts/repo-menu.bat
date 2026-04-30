@echo off
setlocal enabledelayedexpansion
  set "current_repo=%~1"
  
  :REPO_MENU
  set "current_repo=%~1"
  
  :REPO_LOOP
  cls
  :: Получаем текущую ветку для отображения
  set "current_branch="
  for /f "tokens=*" %%b in ('git branch --show-current 2^>nul') do set "current_branch=%%b"
  if "!current_branch!"=="" (
    for /f "tokens=2" %%b in ('git branch 2^>nul ^| find "*"') do set "current_branch=%%b"
  )
  if "!current_branch!"=="" set "current_branch=неизвестно"
  
  :: Получаем статус
  git status --porcelain | findstr . >nul 2>&1
  if errorlevel 1 (
    set "repo_status=%GREEN%✅ чисто%RESET%"
    ) else (
    set "repo_status=%YELLOW%⚠ есть изменения%RESET%
  )
  
  echo %CYAN%  ════════════════════════════════════════════════════════════%RESET%
  echo %BOLD%%WHITE%  Репозиторий:%RESET% %GREEN%%current_repo%%RESET%  %BOLD%%WHITE%Ветка:%RESET% %BLUE%!current_branch!%RESET%
  echo %BOLD%%WHITE%  Статус:%RESET% !repo_status!
  echo %CYAN%  ════════════════════════════════════════════════════════════%RESET%
  echo.
  echo %GREEN%  1.%RESET% Git status (проверить состояние)
  echo %GREEN%  2.%RESET% Git pull (обновить)
  echo %GREEN%  3.%RESET% Git add + commit + push (с комментарием)
  echo %GREEN%  4.%RESET% Перейти в меню отмены изменений
  echo %GREEN%  5.%RESET% Просмотр истории (git log)
  echo %GREEN%  6.%RESET% Git merge (слияние веток)
  echo %GREEN%  7.%RESET% Git merge --abort (отменить слияние)
  echo %GREEN%  8.%RESET% Показать ветки для слияния
  echo %GREEN%  9.%RESET% Создать ветку
  echo %GREEN%  10.%RESET% Переключить ветку
  echo %GREEN%  11.%RESET% Авто-коммиты (каждые N минут)
  echo %RED%  0.%RESET% Вернуться в главное меню
  echo.
  set /p "repo_action=%BOLD%%WHITE% → %RESET%"
  
  :: Проверяем существование папки со скриптами
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
      set /p "commit_msg=%YELLOW%  Комментарий: %RESET%
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
      echo %RED%  ❌ Скрипт меню отката не найден%RESET%
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
      echo %RED%  ❌ Скрипт слияния не найден%RESET%
      pause
    )
    goto REPO_LOOP
  )
  
  if "%repo_action%"=="7" (
    cls
    if exist "%SCRIPT_DIR%\git-scripts\07-git-merge-abort.bat" (
      call "%SCRIPT_DIR%\git-scripts\07-git-merge-abort.bat" "%current_repo%"
      ) else (
      echo %RED%  ❌ Скрипт отмены слияния не найден%RESET%
      pause
    )
    goto REPO_LOOP
  )
  
  if "%repo_action%"=="8" (
    cls
    if exist "%SCRIPT_DIR%\git-scripts\08-git-merge-list.bat" (
      call "%SCRIPT_DIR%\git-scripts\08-git-merge-list.bat" "%current_repo%"
      ) else (
      echo %RED%  ❌ Скрипт просмотра веток не найден%RESET%
      pause
    )
    goto REPO_LOOP
  )
  
  if "%repo_action%"=="9" (
    cls
    if exist "%SCRIPT_DIR%\git-scripts\09-git-create-branch.bat" (
      call "%SCRIPT_DIR%\git-scripts\09-git-create-branch.bat" "%current_repo%"
      ) else (
      echo %BOLD%%CYAN%  === СОЗДАНИЕ ВЕТКИ ===%RESET%
      echo.
      set /p "branch_name=%YELLOW%  Имя ветки: %RESET%
      git branch "!branch_name!"
      echo %GREEN%  ✅ Ветка создана%RESET%
      pause
    )
    goto REPO_LOOP
  )
  
  if "%repo_action%"=="10" (
    cls
    if exist "%SCRIPT_DIR%\git-scripts\10-git-switch-branch.bat" (
      call "%SCRIPT_DIR%\git-scripts\10-git-switch-branch.bat" "%current_repo%"
      ) else (
      echo %BOLD%%CYAN%  === ПЕРЕКЛЮЧЕНИЕ ВЕТКИ ===%RESET%
      echo.
      git branch
      echo.
      set /p "branch_name=%YELLOW%  Ветка для переключения: %RESET%
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
      echo %RED%  ❌ Скрипт авто-коммитов не найден%RESET%
      pause
    )
    goto REPO_LOOP
  )
  
  if "%repo_action%"=="0" exit /b 0
  
  echo %RED%  ❌ Неверный выбор!%RESET%
  pause
  goto REPO_LOOP
