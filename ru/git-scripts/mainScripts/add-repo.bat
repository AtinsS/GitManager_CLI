@echo off
setlocal enabledelayedexpansion enableextensions
set "ORIG_DIR=%CD%"

REM Принудительная очистка потенциально конфликтующих переменных
if defined GH_TOKEN (
  echo %YELLOW%Предупреждение: Переменная GH_TOKEN будет очищена%RESET%
  set "GH_TOKEN="
)
if defined GITHUB_TOKEN (
  echo %YELLOW%Предупреждение: Переменная GITHUB_TOKEN будет очищена%RESET%
  set "GITHUB_TOKEN="
)
if defined GLAB_TOKEN (
  echo %YELLOW%Предупреждение: Переменная GLAB_TOKEN будет очищена%RESET%
  set "GLAB_TOKEN="
)

:ADD_REPO_MENU
cls
echo %BOLD%%CYAN%  📂 ДОБАВЛЕНИЕ РЕПОЗИТОРИЯ%RESET%
echo.
echo %WHITE%  Выберите тип:%RESET%
echo  [1] Добавить существующий git-репозиторий
echo  [2] Создать новый git-репозиторий (git init^)
echo  [3] Авторизация GitHub / GitLab
echo  [4] Вернуться в главное меню
echo.
choice /c 1234 /n /m "%YELLOW%    Ваш выбор: %RESET%"

if errorlevel 4 exit /b 0
if errorlevel 3 goto AUTH_MENU
if errorlevel 2 goto ADD_NEW
if errorlevel 1 goto ADD_EXISTING

:ADD_EXISTING
cls
echo %BOLD%%CYAN%  📦 ДОБАВЛЕНИЕ СУЩЕСТВУЮЩЕГО РЕПОЗИТОРИЯ%RESET%
echo.
set /p "repo_path=%YELLOW%    Путь к git-репозиторию: %RESET%"
set "repo_path=!repo_path:"=!"

if "!repo_path!"=="" (
  echo %RED%  ❌ Путь не может быть пустым!%RESET%
  pause
  goto ADD_REPO_MENU
)

if not exist "!repo_path!" (
  echo %RED%  ❌ Папка не найдена!%RESET%
  pause
  goto ADD_REPO_MENU
)

pushd "!repo_path!" 2>nul || (
  echo %RED%  ❌ Ошибка доступа к папке!%RESET%
  pause
  goto ADD_REPO_MENU
)

git status >nul 2>&1 && (
  for %%I in ("!repo_path!") do set "repo_name=%%~nxI"
  popd
  set /p "repo_name_input=%GREEN%    Имя в Git Manager [!repo_name!]: %RESET%"
  if not "!repo_name_input!"=="" set "repo_name=!repo_name_input!"
  findstr /b /c:"!repo_name!;" "%CONFIG_FILE%" >nul 2>&1 && (
    echo %YELLOW%  Репозиторий с этим именем уже в списке%RESET%
    pause
    exit /b 0
  )
  echo !repo_name!;!repo_path! >> "%CONFIG_FILE%"
  echo %GREEN%  ✅ Репозиторий добавлен!%RESET%
  set /p "add_to_group=%YELLOW%    Добавить в группу? [y/n]: %RESET%"
  if /i "!add_to_group!"=="y" call "%MAIN_SCRIPTS_DIR%\groups.bat" ADD_REPO_TO_GROUP "!repo_name!"
  pause
  exit /b 0
) || (
  popd
  echo %RED%  ❌ Это не git-репозиторий!%RESET%
  pause
  goto ADD_REPO_MENU
)

:ADD_NEW
cls
echo %BOLD%%CYAN%  🆕 СОЗДАНИЕ НОВОГО РЕПОЗИТОРИЯ%RESET%
echo.

call :CHECK_CLI_TOOLS
call :CHECK_ALL_AUTH

echo.
echo %BOLD%%WHITE%  📊 Статус инструментов:%RESET%
if "!gh_available!"=="1" (
  echo %GREEN%  ✅ GitHub CLI готов%RESET%
  if "!gh_auth_ok!"=="1" (
    echo %GREEN%     └─ Авторизован%RESET%
  ) else (
    echo %YELLOW%     └─ Не авторизован%RESET%
  )
) else (
  echo %RED%  ❌ GitHub CLI не найден%RESET%
)

if "!glab_available!"=="1" (
  echo %GREEN%  ✅ GitLab CLI готов%RESET%
  if "!glab_auth_ok!"=="1" (
    echo %GREEN%     └─ Авторизован%RESET%
  ) else (
    echo %YELLOW%     └─ Не авторизован%RESET%
  )
) else (
  echo %RED%  ❌ GitLab CLI не найден%RESET%
)

if "!gh_available!"=="0" if "!glab_available!"=="0" (
  echo.
  echo %YELLOW%  CLI-инструменты не найдены%RESET%
  
  where winget >nul 2>&1 && (
    echo.
    echo %BOLD%%WHITE%  🚀 Установка через winget:%RESET%
    echo  [1] Установить GitHub и GitLab CLI
    echo  [2] Продолжить без них
    echo  [3] Выйти
    choice /c 123 /n /m "%YELLOW%    Ваш выбор: %RESET%"
    set "install_choice=!errorlevel!"
    if "!install_choice!"=="3" exit /b 0
    if "!install_choice!"=="1" (
      winget install GitHub.cli --silent --accept-source-agreements 2>&1
      winget install GitLab.GitLabCLI --silent --accept-source-agreements 2>&1 || winget install glab.glab --silent --accept-source-agreements 2>&1
      echo %GREEN%  ✅ Установка завершена%RESET%
      pause
      echo %WHITE%  Перезапустите Git Manager для применения изменений.%RESET%
      pause
      exit /b 0
    )
  ) || (
    echo.
    echo %WHITE%  Установите вручную:%RESET%
    echo %CYAN%  GitHub CLI: https://cli.github.com/%RESET%
    echo %CYAN%  GitLab CLI: https://gitlab.com/gitlab-org/cli/-/releases%RESET%
    pause
  )
)

:PLATFORM_CHOICE
cls
echo %GREEN%  ✅ Введите данные репозитория%RESET%
echo.

set /p "repo_name=%GREEN%    📦 Имя: %RESET%"
if "!repo_name!"=="" (
  echo %RED%  ❌ Имя не может быть пустым!%RESET%
  pause
  goto PLATFORM_CHOICE
)

set /p "parent_path=%YELLOW%    📁 Папка-родитель: %RESET%"
set "parent_path=!parent_path:"=!"

if "!parent_path!"=="" (
  echo %RED%  ❌ Папка не может быть пустой!%RESET%
  pause
  goto PLATFORM_CHOICE
)

if not exist "!parent_path!" (
  mkdir "!parent_path!" 2>nul || (
    echo %RED%  ❌ Не удалось создать папку!%RESET%
    pause
    goto PLATFORM_CHOICE
  )
)

set "repo_path=!parent_path!\!repo_name!"

echo.
echo %BOLD%%WHITE%  🌐 Платформа:%RESET%
echo  [1] GitHub
echo  [2] GitLab
echo  [3] Только локально
echo  [4] Назад
echo.
choice /c 1234 /n /m "%YELLOW%    Ваш выбор: %RESET%"
set "platform_choice=!errorlevel!"

if "!platform_choice!"=="4" goto PLATFORM_CHOICE
if "!platform_choice!"=="3" goto LOCAL_ONLY
if "!platform_choice!"=="2" (
  if "!glab_available!"=="1" (
    if "!glab_auth_ok!"=="0" (
      echo %YELLOW%  Требуется авторизация GitLab%RESET%
      call :AUTH_GITLAB
      if "!glab_auth_ok!"=="0" goto PLATFORM_CHOICE
    )
    goto CREATE_GITLAB
  )
  echo %RED%  ❌ GitLab CLI не установлен!%RESET%
  pause
  goto PLATFORM_CHOICE
)
if "!platform_choice!"=="1" (
  if "!gh_available!"=="1" (
    if "!gh_auth_ok!"=="0" (
      echo %YELLOW%  Требуется авторизация GitHub%RESET%
      call :AUTH_GITHUB
      if "!gh_auth_ok!"=="0" goto PLATFORM_CHOICE
    )
    goto CREATE_GITHUB
  )
  echo %RED%  ❌ GitHub CLI не установлен!%RESET%
  pause
  goto PLATFORM_CHOICE
)
goto PLATFORM_CHOICE

:CREATE_GITHUB
echo.
echo %BOLD%%CYAN%  🔷 GITHUB - СОЗДАНИЕ РЕПОЗИТОРИЯ%RESET%

REM Финальная проверка авторизации
call :CHECK_GITHUB_AUTH
if "!gh_auth_ok!"=="0" (
  echo %RED%  ❌ Не авторизован в GitHub%RESET%
  pause
  goto ADD_REPO_MENU
)

echo %GREEN%  ✅ Готов к созданию репозитория%RESET%

echo %WHITE%  Видимость:%RESET%
echo  [1] Публичный ^(по умолчанию^)
echo  [2] Приватный
choice /c 12 /n /m "%YELLOW%    Ваш выбор: %RESET%"
set "visibility=--public"
if errorlevel 2 set "visibility=--private"

call :LOCAL_INIT || goto ADD_REPO_MENU

echo %CYAN%  Создаю на GitHub...%RESET%
gh repo create "!repo_name!" !visibility! --source="!repo_path!" --remote=origin --description="Created with Git Manager" --push 2>&1
set "gh_result=!errorlevel!"

if !gh_result! equ 0 (
  set "platform=github"
  echo %GREEN%  ✅ Репозиторий создан на GitHub!%RESET%
  REM Получаем URL
  for /f "delims=" %%u in ('gh repo view --json url --jq ".url" 2^>nul') do set "remote_url=%%u"
  if defined remote_url echo %WHITE%  URL: %CYAN%!remote_url!%RESET%
) else (
  set "platform=failed_github"
  echo %RED%  ❌ Ошибка создания репозитория%RESET%
  echo %YELLOW%  Возможные причины:%RESET%
  echo %WHITE%  • Токен не имеет права 'repo'^<https://github.com/settings/tokens^>%RESET%
  echo %WHITE%  • Репозиторий уже существует%RESET%
  echo %WHITE%  • Проблемы с сетью%RESET%
  echo %YELLOW%  Локальный репозиторий создан%RESET%
)

goto REMOTE_DONE

:CREATE_GITLAB
echo.
echo %BOLD%%CYAN%  🔶 GITLAB - СОЗДАНИЕ РЕПОЗИТОРИЯ%RESET%

REM Финальная проверка авторизации  
call :CHECK_GITLAB_AUTH
if "!glab_auth_ok!"=="0" (
  echo %RED%  ❌ Не авторизован в GitLab%RESET%
  pause
  goto ADD_REPO_MENU
)

echo %GREEN%  ✅ Готов к созданию репозитория%RESET%

echo %WHITE%  Видимость:%RESET%
echo  [1] Публичный ^(по умолчанию^)
echo  [2] Приватный
choice /c 12 /n /m "%YELLOW%    Ваш выбор: %RESET%"
set "visibility=--public"
if errorlevel 2 set "visibility=--private"

call :LOCAL_INIT || goto ADD_REPO_MENU

echo %CYAN%  Создаю на GitLab...%RESET%
glab repo create "!repo_name!" !visibility! --description="Created with Git Manager" 2>&1
set "glab_result=!errorlevel!"

if !glab_result! equ 0 (
  set "platform=gitlab"
  echo %GREEN%  ✅ Репозиторий создан на GitLab!%RESET%
  
  pushd "!repo_path!"
  
  REM Получаем URL репозитория
  set "remote_url="
  for /f "tokens=*" %%a in ('glab repo view 2^>nul') do (
    echo "%%a" | findstr /c:"HTTP URL:" >nul 2>&1 && (
      for /f "tokens=2 delims=: " %%u in ("%%a") do set "remote_url=%%u"
    )
  )
  
  if defined remote_url (
    git remote add origin "!remote_url!" 2>nul
    for /f "delims=" %%b in ('git branch --show-current 2^>nul') do set "branch=%%b"
    if "!branch!"=="" set "branch=main"
    
    echo %CYAN%  Отправляю код...%RESET%
    git push -u origin "!branch!" 2>&1
    if !errorlevel! equ 0 (
      echo %GREEN%  ✅ Код отправлен!%RESET%
      echo %WHITE%  URL: %CYAN%!remote_url!%RESET%
    ) else (
      echo %YELLOW%  ⚠️ Push не удался, но remote настроен%RESET%
      echo %WHITE%  Выполните вручную: git push -u origin !branch!%RESET%
    )
  ) else (
    echo %YELLOW%  ⚠️ URL не получен, настройте remote вручную%RESET%
  )
  popd
) else (
  set "platform=failed_gitlab"
  echo %RED%  ❌ Ошибка создания репозитория%RESET%
  echo %YELLOW%  Проверьте права токена: api, read_repository, write_repository%RESET%
  echo %YELLOW%  Локальный репозиторий создан%RESET%
)

goto REMOTE_DONE

:LOCAL_ONLY
set "platform=local"
call :LOCAL_INIT || goto ADD_REPO_MENU

echo %BOLD%%WHITE%  🔗 Удалённый репозиторий%RESET%
set /p "add_remote=%YELLOW%    Добавить URL? [y/n]: %RESET%"
if /i "!add_remote!"=="y" (
  set /p "remote_url=%GREEN%    URL: %RESET%"
  if not "!remote_url!"=="" (
    pushd "!repo_path!" 2>nul && (
      git remote add origin "!remote_url!" 2>nul && echo %GREEN%  ✅ Добавлен%RESET% || echo %RED%  ❌ Ошибка%RESET%
      popd
    )
  )
)

:REMOTE_DONE
cd /d "%ORIG_DIR%"

echo !repo_name!;!repo_path! >> "%CONFIG_FILE%"
echo.
echo %BOLD%%WHITE%  ═══════════════════════════════════%RESET%
echo %WHITE%  Репозиторий: %GREEN%!repo_name!%RESET%
echo %WHITE%  Путь: !repo_path!%RESET%
if "!platform!"=="github" echo %WHITE%  Платформа: %CYAN%GitHub%RESET%
if "!platform!"=="gitlab" echo %WHITE%  Платформа: %CYAN%GitLab%RESET%
if "!platform!"=="local" echo %WHITE%  Тип: %YELLOW%Локальный%RESET%
if "!platform!"=="failed_github" echo %WHITE%  Статус: %RED%GitHub ошибка, локальный создан%RESET%
if "!platform!"=="failed_gitlab" echo %WHITE%  Статус: %RED%GitLab ошибка, локальный создан%RESET%
if defined remote_url echo %WHITE%  URL: %CYAN%!remote_url!%RESET%
echo %BOLD%%WHITE%  ═══════════════════════════════════%RESET%
echo.

set /p "add_to_group=%YELLOW%    Добавить в группу? [y/n]: %RESET%"
if /i "!add_to_group!"=="y" call "%MAIN_SCRIPTS_DIR%\groups.bat" ADD_REPO_TO_GROUP "!repo_name!"

echo.
echo %GREEN%  ✅ Готово!%RESET%
pause
goto ADD_REPO_MENU

:AUTH_MENU
cls
echo %BOLD%%CYAN%  🔐 АВТОРИЗАЦИЯ%RESET%
echo.

call :CHECK_CLI_TOOLS
call :CHECK_ALL_AUTH

echo %BOLD%%WHITE%  📊 Текущий статус:%RESET%
echo.
if "!gh_available!"=="1" (
  if "!gh_auth_ok!"=="1" (
    echo %GREEN%  ✅ GitHub: Авторизован%RESET%
  ) else (
    echo %YELLOW%  ⚠️ GitHub: Не авторизован%RESET%
  )
) else (
  echo %RED%  ❌ GitHub CLI не установлен%RESET%
)

if "!glab_available!"=="1" (
  if "!glab_auth_ok!"=="1" (
    echo %GREEN%  ✅ GitLab: Авторизован%RESET%
  ) else (
    echo %YELLOW%  ⚠️ GitLab: Не авторизован%RESET%
  )
) else (
  echo %RED%  ❌ GitLab CLI не установлен%RESET%
)

echo.
echo %WHITE%  Выберите действие:%RESET%
echo  [1] Авторизация GitHub
echo  [2] Авторизация GitLab
echo  [3] Назад
choice /c 123 /n /m "%YELLOW%    Ваш выбор: %RESET%"
if errorlevel 3 goto ADD_REPO_MENU
if errorlevel 2 goto AUTH_GITLAB
if errorlevel 1 goto AUTH_GITHUB

:AUTH_GITHUB
cls
call :CHECK_CLI_TOOLS
if "!gh_available!"=="0" (
  echo %RED%  ❌ GitHub CLI не установлен.%RESET%
  echo %CYAN%  Скачайте: https://cli.github.com/%RESET%
  pause
  goto AUTH_MENU
)

echo %BOLD%%CYAN%  🔷 АВТОРИЗАЦИЯ GITHUB%RESET%
echo.

REM Очищаем переменные окружения
if defined GH_TOKEN (
  echo %YELLOW%  ⚠️ Очищаю GH_TOKEN...%RESET%
  set "GH_TOKEN="
)
if defined GITHUB_TOKEN (
  echo %YELLOW%  ⚠️ Очищаю GITHUB_TOKEN...%RESET%
  set "GITHUB_TOKEN="
)

REM Проверяем текущую авторизацию
call :CHECK_GITHUB_AUTH
if "!gh_auth_ok!"=="1" (
  echo %GREEN%  ✓ Текущая авторизация активна%RESET%
  echo %YELLOW%  Переавторизоваться?%RESET%
  choice /c yn /n /m "%YELLOW%    [y/n]: %RESET%"
  if errorlevel 2 goto AUTH_MENU
  echo %WHITE%  Выход из текущей сессии...%RESET%
  gh auth logout --hostname github.com 2>nul
  set "gh_auth_ok=0"
)

echo.
echo %WHITE%  Способ авторизации:%RESET%
echo  [1] Через браузер ^(рекомендуется^)
echo  [2] Токен вручную
echo  [3] Назад
choice /c 123 /n /m "%YELLOW%    Ваш выбор: %RESET%"
if errorlevel 3 goto AUTH_MENU
if errorlevel 2 (
  echo.
  echo %WHITE%  Инструкция:%RESET%
  echo %CYAN%  1. Откройте https://github.com/settings/tokens%RESET%
  echo %CYAN%  2. Generate new token (classic^)%RESET%
  echo %CYAN%  3. Выберите права: repo, workflow%RESET%
  echo %CYAN%  4. Скопируйте токен%RESET%
  echo.
  set /p "gh_token=%GREEN%    Токен: %RESET%"
  if "!gh_token!"=="" goto AUTH_GITHUB
  
  echo %WHITE%  Выполняю вход...%RESET%
  echo !gh_token! | gh auth login --with-token 2>&1
  set "gh_token="
  
  REM Ждём и проверяем
  timeout /t 2 /nobreak >nul
  call :CHECK_GITHUB_AUTH
) else (
  echo %WHITE%  Открываю браузер для авторизации...%RESET%
  gh auth login --hostname github.com --web 2>&1
  
  REM Ждём завершения
  echo %WHITE%  Ожидание авторизации...%RESET%
  timeout /t 3 /nobreak >nul
  
  REM Несколько попыток проверки
  for /l %%i in (1,1,5) do (
    call :CHECK_GITHUB_AUTH
    if "!gh_auth_ok!"=="1" goto GITHUB_AUTH_OK
    timeout /t 2 /nobreak >nul
  )
)

:GITHUB_AUTH_OK
if "!gh_auth_ok!"=="1" (
  echo %GREEN%  ✅ Авторизация GitHub успешна!%RESET%
) else (
  echo %YELLOW%  ⚠️ Статус авторизации не подтверждён%RESET%
  echo %WHITE%  Проверьте вручную: gh auth status%RESET%
  echo %WHITE%  Если показывает "Logged in" - всё работает%RESET%
  
  REM Проверяем через gh auth status напрямую
  gh auth status >nul 2>&1 && (
    echo %GREEN%  ✓ gh auth status confirmed - авторизация ОК%RESET%
    set "gh_auth_ok=1"
  )
)
pause
goto AUTH_MENU

:AUTH_GITLAB
cls
call :CHECK_CLI_TOOLS
if "!glab_available!"=="0" (
  echo %RED%  ❌ GitLab CLI не установлен.%RESET%
  echo %CYAN%  Скачайте: https://gitlab.com/gitlab-org/cli/-/releases%RESET%
  pause
  goto AUTH_MENU
)

echo %BOLD%%CYAN%  🔶 АВТОРИЗАЦИЯ GITLAB%RESET%
echo.

REM Очищаем переменные окружения
if defined GLAB_TOKEN (
  echo %YELLOW%  ⚠️ Очищаю GLAB_TOKEN...%RESET%
  set "GLAB_TOKEN="
)

REM Проверяем текущую авторизацию
call :CHECK_GITLAB_AUTH
if "!glab_auth_ok!"=="1" (
  echo %GREEN%  ✓ Текущая авторизация активна%RESET%
  echo %YELLOW%  Переавторизоваться?%RESET%
  choice /c yn /n /m "%YELLOW%    [y/n]: %RESET%"
  if errorlevel 2 goto AUTH_MENU
  echo %WHITE%  Выход из текущей сессии...%RESET%
  glab auth logout --hostname gitlab.com 2>nul
  set "glab_auth_ok=0"
)

echo.
echo %WHITE%  Способ авторизации:%RESET%
echo  [1] Через браузер
echo  [2] Токен
echo  [3] Назад
choice /c 123 /n /m "%YELLOW%    Ваш выбор: %RESET%"
if errorlevel 3 goto AUTH_MENU
if errorlevel 2 (
  echo.
  echo %WHITE%  Инструкция:%RESET%
  echo %CYAN%  1. Откройте https://gitlab.com/-/user_settings/personal_access_tokens%RESET%
  echo %CYAN%  2. Создайте токен с правами: api, read_repository, write_repository%RESET%
  echo %CYAN%  3. Скопируйте токен%RESET%
  echo.
  set /p "glab_token=%GREEN%    Токен: %RESET%"
  if "!glab_token!"=="" goto AUTH_GITLAB
  
  echo %WHITE%  Выполняю вход...%RESET%
  echo !glab_token! | glab auth login --stdin --hostname gitlab.com 2>&1
  set "glab_token="
  
  REM Ждём и проверяем
  timeout /t 2 /nobreak >nul
  call :CHECK_GITLAB_AUTH
) else (
  echo %WHITE%  Открываю браузер для авторизации...%RESET%
  glab auth login --hostname gitlab.com 2>&1
  
  REM Ждём завершения
  echo %WHITE%  Ожидание авторизации...%RESET%
  timeout /t 3 /nobreak >nul
  
  REM Несколько попыток проверки
  for /l %%i in (1,1,5) do (
    call :CHECK_GITLAB_AUTH
    if "!glab_auth_ok!"=="1" goto GITLAB_AUTH_OK
    timeout /t 2 /nobreak >nul
  )
)

:GITLAB_AUTH_OK
if "!glab_auth_ok!"=="1" (
  echo %GREEN%  ✅ Авторизация GitLab успешна!%RESET%
) else (
  echo %YELLOW%  ⚠️ Статус авторизации не подтверждён%RESET%
  echo %WHITE%  Проверьте вручную: glab auth status%RESET%
  echo %WHITE%  Если показывает "Logged in" - всё работает%RESET%
  
  REM Проверяем через glab auth status напрямую
  glab auth status >nul 2>&1 && (
    echo %GREEN%  ✓ glab auth status confirmed - авторизация ОК%RESET%
    set "glab_auth_ok=1"
  )
)
pause
goto AUTH_MENU

:CHECK_ALL_AUTH
call :CHECK_GITHUB_AUTH
call :CHECK_GITLAB_AUTH
exit /b 0

:CHECK_GITHUB_AUTH
set "gh_auth_ok=0"
if "!gh_available!"=="0" exit /b 0

REM Простая проверка через gh auth status
gh auth status >nul 2>&1 && set "gh_auth_ok=1"
exit /b 0

:CHECK_GITLAB_AUTH
set "glab_auth_ok=0"
if "!glab_available!"=="0" exit /b 0

REM Проверка через наличие конфига и auth status
if exist "%USERPROFILE%\.config\glab-cli\config.yml" (
  glab auth status >nul 2>&1 && set "glab_auth_ok=1"
)
if exist "%LocalAppData%\glab-cli\config.yml" (
  if "!glab_auth_ok!"=="0" glab auth status >nul 2>&1 && set "glab_auth_ok=1"
)
exit /b 0

:LOCAL_INIT
if exist "!repo_path!" (
  pushd "!repo_path!" 2>nul && git status >nul 2>&1 && (
    popd
    echo %YELLOW%  ⚠️ Папка уже является git-репозиторием%RESET%
    exit /b 0
  ) || (
    popd
    echo %RED%  ❌ Папка существует, но не git-репозиторий%RESET%
    exit /b 1
  )
)

mkdir "!repo_path!" 2>nul || (
  echo %RED%  ❌ Ошибка создания папки!%RESET%
  exit /b 1
)

pushd "!repo_path!" 2>nul || (
  echo %RED%  ❌ Ошибка доступа!%RESET%
  exit /b 1
)

git init 2>nul || (
  popd
  echo %RED%  ❌ Git не работает!%RESET%
  exit /b 1
)

call :MAKE_FIRST_COMMIT
popd
exit /b 0

:MAKE_FIRST_COMMIT
echo # !repo_name! > README.md
git add README.md 2>nul
git commit -m "Initial commit" 2>nul
echo %CYAN%  📝 Первый коммит создан%RESET%
exit /b 0

:CHECK_CLI_TOOLS
set "gh_available=0"
set "glab_available=0"

for %%D in (
  "%ProgramFiles%\GitHub CLI"
  "%LocalAppData%\Programs\GitHub CLI"
  "C:\Program Files\GitHub CLI"
) do if exist "%%~D\gh.exe" (
  set "PATH=%%~D;!PATH!"
  set "gh_available=1"
)

for %%D in (
  "%ProgramFiles%\GitLab CLI"
  "%LocalAppData%\Programs\glab"
  "C:\Program Files\glab"
) do if exist "%%~D\glab.exe" (
  set "PATH=%%~D;!PATH!"
  set "glab_available=1"
)

where gh >nul 2>&1 && set "gh_available=1"
where glab >nul 2>&1 && set "glab_available=1"
exit /b 0

endlocal