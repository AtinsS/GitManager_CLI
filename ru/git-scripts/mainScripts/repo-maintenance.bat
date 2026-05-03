@echo off
setlocal enabledelayedexpansion
if "%~1"=="" goto :eof
set "__MAIN_SCRIPT_ACTION=%~1"
shift /1
goto :%__MAIN_SCRIPT_ACTION%
:UPDATE_ALL
cls
echo %BOLD%%CYAN%=== ОБНОВЛЕНИЕ ВСЕХ РЕПОЗИТОРИЕВ ===%RESET%
echo.

if not exist "%CONFIG_FILE%" (
    echo %RED%Нет сохраненных репозиториев!%RESET%
    pause
    exit /b 0
)

for /f "usebackq tokens=1,2 delims=;" %%a in ("%CONFIG_FILE%") do (
    echo.
    echo %BOLD%%BLUE%===== Обработка:%RESET% %GREEN%%%a%RESET% %BLUE%=====%RESET%
    if exist "%%b" (
        pushd "%%b" 2>nul
        if not errorlevel 1 (
            echo %YELLOW%Обновление...%RESET%
            git pull
            popd
        ) else (
            echo %RED%⚠ Не могу перейти в папку%RESET%
        )
    ) else (
        echo %RED%⚠ Папка не найдена: %%b%RESET%
    )
)

echo.
echo %GREEN%Обновление завершено!%RESET%
pause
exit /b 0

:DELETE_REPO
cls
echo %BOLD%%CYAN%=== УДАЛЕНИЕ РЕПОЗИТОРИЯ ИЗ СПИСКА ===%RESET%
echo.

if not exist "%CONFIG_FILE%" (
    echo %RED%Нет репозиториев для удаления!%RESET%
    pause
    exit /b 0
)

set idx=1
for /f "usebackq tokens=1,2 delims=;" %%a in ("%CONFIG_FILE%") do (
    echo %GREEN%!idx!.%RESET% %%a - %CYAN%%%b%RESET%
    set /a idx+=1
)

echo.
set /p "del_num=%BOLD%%RED%Номер репозитория для удаления: %RESET%"

set skip_line=%del_num%
set current=0
type nul > "%TEMP_FILE%"
if exist "%CONFIG_FILE%" (
<<<<<<< HEAD
    for /f "usebackq tokens=1,2,* delims=;" %%a in ("%CONFIG_FILE%") do (
        set /a current+=1
        if not !current!==%skip_line% (
            >> "%TEMP_FILE%" echo(%%a;%%b;%%c
=======
    for /f "usebackq tokens=1,2 delims=;" %%a in ("%CONFIG_FILE%") do (
        set /a current+=1
        if not !current!==%skip_line% (
            echo %%a;%%b >> "%TEMP_FILE%"
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
        ) else (
            set "deleted_repo=%%a"
        )
    )
    move /y "%TEMP_FILE%" "%CONFIG_FILE%" >nul 2>nul
)

if defined deleted_repo if exist "%GROUPS_FILE%" (
    set "temp_groups=%TEMP%\groups.tmp"
    type nul > "!temp_groups!"
    for /f "usebackq tokens=1,* delims=;" %%a in ("%GROUPS_FILE%") do (
        set "new_repo_list="
        set "first_repo=1"
        if not "%%b"=="" (
            for %%r in (%%b) do (
                if not "%%r"=="!deleted_repo!" (
                    if !first_repo!==1 (
                        set "new_repo_list=%%r"
                        set "first_repo=0"
                    ) else (
                        set "new_repo_list=!new_repo_list!;%%r"
                    )
                )
            )
        )
        echo %%a;!new_repo_list!>> "!temp_groups!"
    )
    move /y "!temp_groups!" "%GROUPS_FILE%" >nul 2>nul
)

echo %GREEN%Repository removed from list and groups!%RESET%
pause
exit /b 0

:SETTINGS
cls
echo %BOLD%%CYAN%=== НАСТРОЙКИ ===%RESET%
echo.
echo %GREEN%1.%RESET% Показать все репозитории
echo %YELLOW%2.%RESET% Очистить список
echo %BLUE%3.%RESET% Редактировать пути вручную
echo %MAGENTA%4.%RESET% Авто-исправление конфигов
echo %RED%5.%RESET% Назад
echo.
set /p "sett=%BOLD%%WHITE%Выберите: %RESET%"

if "%sett%"=="1" (
    cls
    echo %BOLD%%WHITE%Список репозиториев:%RESET%
    echo %BLUE%===================%RESET%
    if exist "%CONFIG_FILE%" (
        for /f "usebackq tokens=1,2 delims=;" %%a in ("%CONFIG_FILE%") do (
            echo %GREEN%%%a%RESET% - %CYAN%%%b%RESET%
        )
    ) else (
        echo %YELLOW%Список пуст%RESET%
    )
    echo.
    pause
    goto SETTINGS
)

if "%sett%"=="2" (
    del "%CONFIG_FILE%" 2>nul
    del "%GROUPS_FILE%" 2>nul
    echo %GREEN%Списки очищены!%RESET%
    pause
    goto SETTINGS
)

if "%sett%"=="3" (
    if exist "%CONFIG_FILE%" (
        notepad "%CONFIG_FILE%"
    ) else (
        echo %RED%Список пуст, нечего редактировать%RESET%
        pause
    )
    goto SETTINGS
)

if "%sett%"=="4" (
    call "%MAIN_SCRIPTS_DIR%\repo-maintenance.bat" AUTO_REPAIR_CONFIGS
    exit /b 0
)

exit /b 0

:CLONE_REPO_EXISTING
set "repo_name=%~1"
set "repo_path=%~2"
set "repo_dir=%repo_path%"

echo.
echo %YELLOW%Введите URL для клонирования %repo_name%:%RESET%
set /p "repo_url=%BOLD%URL: %RESET%"

echo %BOLD%Клонирование %repo_name%...%RESET%
if exist "%repo_dir%" (
    rd /s /q "%repo_dir%" 2>nul
)
git clone "%repo_url%" "%repo_dir%"
if errorlevel 1 (
    echo %RED%Ошибка клонирования!%RESET%
) else (
    echo %GREEN%Готово!%RESET%
    findstr /b /c:"%repo_name%;" "%CONFIG_FILE%" >nul 2>&1
    if errorlevel 1 (
<<<<<<< HEAD
        call :DETECT_HOSTING
        >> "%CONFIG_FILE%" echo(%repo_name%;%repo_dir%;!repo_url!;!hosting!
=======
        echo %repo_name%;%repo_dir% >> "%CONFIG_FILE%"
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
        echo %GREEN%Repository added to the list!%RESET%
    ) else (
        echo %YELLOW%Repository is already in the list%RESET%
    )
)
echo.
pause
goto :eof

<<<<<<< HEAD
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

=======
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
:UPDATE_REPO_PATH
set "repo_name=%~1"
set "new_path=%~2"

type nul > "%TEMP_FILE%"
if exist "%CONFIG_FILE%" (
<<<<<<< HEAD
    for /f "usebackq tokens=1,2,* delims=;" %%a in ("%CONFIG_FILE%") do (
        if "%%a"=="%repo_name%" (
            >> "%TEMP_FILE%" echo(%%a;%new_path%;%%c
        ) else (
            >> "%TEMP_FILE%" echo(%%a;%%b;%%c
=======
    for /f "usebackq tokens=1,2 delims=;" %%a in ("%CONFIG_FILE%") do (
        if "%%a"=="%repo_name%" (
            echo %%a;%new_path% >> "%TEMP_FILE%"
        ) else (
            echo %%a;%%b >> "%TEMP_FILE%"
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
        )
    )
    move /y "%TEMP_FILE%" "%CONFIG_FILE%" >nul 2>nul
)
goto :eof

:AUTO_REPAIR_CONFIGS
echo %BOLD%%YELLOW%Автоматическое исправление конфигураций...%RESET%

:: Исправляем git_repos.cfg
if exist "%CONFIG_FILE%" (
    set "temp_cfg=%TEMP%\git_repos_fixed.cfg"
    type nul > "!temp_cfg!"
<<<<<<< HEAD
    for /f "usebackq tokens=1,2,* delims=;" %%a in ("%CONFIG_FILE%") do (
=======
    for /f "usebackq tokens=1,* delims=;" %%a in ("%CONFIG_FILE%") do (
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
        :: Очищаем имя - берем только первое слово
        for /f "tokens=1" %%n in ("%%a") do set "clean_name=%%n"
        :: Очищаем путь - убираем лишние слова в конце
        set "clean_path=%%b"
<<<<<<< HEAD
        >> "!temp_cfg!" echo(!clean_name!;!clean_path!;%%c
=======
        echo !clean_name!;!clean_path!>> "!temp_cfg!"
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
    )
    move /y "!temp_cfg!" "%CONFIG_FILE%" >nul 2>nul
    echo %GREEN%git_repos.cfg исправлен%RESET%
)

:: Исправляем groups.cfg
if exist "%GROUPS_FILE%" (
    set "temp_groups=%TEMP%\groups_fixed.cfg"
    type nul > "!temp_groups!"
    for /f "usebackq tokens=1,* delims=;" %%a in ("%GROUPS_FILE%") do (
        set "new_repo_list="
        for %%r in (%%b) do (
            :: Очищаем имя репозитория от дубликатов
            for /f "tokens=1" %%n in ("%%r") do set "clean_repo=%%n"
            set "new_repo_list=!new_repo_list! !clean_repo!"
        )
        echo %%a;!new_repo_list!>> "!temp_groups!"
    )
    move /y "!temp_groups!" "%GROUPS_FILE%" >nul 2>nul
    echo %GREEN%groups.cfg исправлен%RESET%
)

echo.
echo %GREEN%Исправление завершено! Запустите программу заново.%RESET%
pause
exit /b

