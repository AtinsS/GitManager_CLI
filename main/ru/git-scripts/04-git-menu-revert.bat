@echo off
setlocal enabledelayedexpansion

:: Получаем путь к папке с батником
set "SCRIPT_DIR=%~dp0"

:: Цвета
for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "CYAN=%ESC%[96m"
set "WHITE=%ESC%[97m"
set "BOLD=%ESC%[1m"
set "RESET=%ESC%[0m"

:MENU_LOOP
cls
echo %BOLD%%CYAN%    ════════════════════════════════════════════════════════════%RESET%
echo %BOLD%%CYAN%    🔄 МЕНЮ ОТКАТА ИЗМЕНЕНИЙ%RESET%
echo %BOLD%%CYAN%    ════════════════════════════════════════════════════════════%RESET%
echo.
echo %GREEN%  1.%RESET% Git reset (откат на коммит назад)
echo %GREEN%  2.%RESET% Git revert (отмена коммита с сохранением истории)
echo %RED%  0.%RESET% Вернуться в главное меню	
echo.
set /p "reset_action=%BOLD%%WHITE%    ⚡ Выберите действие: %RESET%"

if "%reset_action%"=="1" (
    if exist "%SCRIPT_DIR%12-git-reset.bat" (
        call "%SCRIPT_DIR%12-git-reset.bat"
    ) else (
        echo %RED%    ❌ Скрипт 12-git-reset.bat не найден%RESET%
        echo %WHITE%    Нажмите любую клавишу...%RESET%
        pause >nul
    )
    goto MENU_LOOP
)

if "%reset_action%"=="2" (
    if exist "%SCRIPT_DIR%13-git-revert.bat" (
        call "%SCRIPT_DIR%13-git-revert.bat"
    ) else (
        echo %RED%    ❌ Скрипт 13-git-revert.bat не найден%RESET%
        echo %WHITE%    Нажмите любую клавишу...%RESET%
        pause >nul
    )
    goto MENU_LOOP
)

if "%reset_action%"=="0" exit /b

echo %RED%❌ Неверный выбор!%RESET%
echo %WHITE%Нажмите любую клавишу...%RESET%
pause >nul
goto MENU_LOOP