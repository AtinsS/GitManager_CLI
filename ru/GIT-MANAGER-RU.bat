@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Color scheme
set "ESC="
set "RED=%ESC%[91m"
set "GREEN=%ESC%[92m"
set "YELLOW=%ESC%[93m"
set "BLUE=%ESC%[94m"
set "MAGENTA=%ESC%[95m"
set "CYAN=%ESC%[96m"
set "WHITE=%ESC%[97m"
set "BOLD=%ESC%[1m"
set "RESET=%ESC%[0m"

:: Save script directory
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

:: Parent directory
set "PARENT_DIR=%SCRIPT_DIR%\.."

:: Config directory
set "CONFIG_DIR=%PARENT_DIR%\cfg"

:: Create config directory if it doesn't exist
if not exist "%CONFIG_DIR%" mkdir "%CONFIG_DIR%" 2>nul

:: Config files
set "CONFIG_FILE=%CONFIG_DIR%\git_repos.cfg"
set "GROUPS_FILE=%CONFIG_DIR%\groups.cfg"
set "TEMP_FILE=%CONFIG_DIR%\temp.cfg"

:: Scripts directory
set "SCRIPTS_DIR=%SCRIPT_DIR%\git-scripts"
set "MAIN_SCRIPTS_DIR=%SCRIPTS_DIR%\mainScripts"
if not exist "%MAIN_SCRIPTS_DIR%" mkdir "%MAIN_SCRIPTS_DIR%" 2>nul

:MENU
cls
echo %CYAN%═══════════════════════════════════════════════════════════════════════════════%RESET%
echo   %BLUE%     ███  ███ █████    █   █  ███  █   █  ███   ███  █████ ████  
echo   %BLUE%    █      █    █      ██ ██ █   █ ██  █ █   █ █     █     █   █ 
echo   %BLUE%    █  ██  █    █      █ █ █ █████ █ █ █ █████ █  ██ ████  ████  
echo   %BLUE%    █   █  █    █      █   █ █   █ █  ██ █   █ █   █ █     █  █  
echo   %BLUE%     ███  ███   █      █   █ █   █ █   █ █   █  ███  █████ █   █  %YELLOW%by AtinsS%RESET%
echo %CYAN%══════════════════════════════════════════════════════════════════════════════%RESET%
echo.
set count=0
if exist "%CONFIG_FILE%" (
  echo %BOLD%%WHITE%▸ РЕПОЗИТОРИИ%RESET%
  
  set "MARKED_FILE=%TEMP%\marked_repos_%RANDOM%.tmp"
  type nul > "!MARKED_FILE!"
  
  if exist "%GROUPS_FILE%" (
    for /f "usebackq tokens=1,* delims=;" %%a in ("%GROUPS_FILE%") do (
      echo.
      echo %BOLD%%MAGENTA%  ▸ Группа: %%a%RESET%
      set "group_repos=%%b"
      if not "!group_repos!"=="" (
        set "group_repos=!group_repos: =;!"
        set "group_repos=!group_repos:;;=;!"
        for %%r in (!group_repos!) do (
          >> "!MARKED_FILE!" echo %%~r
          set "repo_found=0"
          for /f "usebackq tokens=1,* delims=;" %%x in ("%CONFIG_FILE%") do (
            if "%%x"=="%%r" (
              set /a count+=1
              set "repo_name_!count!=%%x"
              set "repo_path_!count!=%%y"
              call "%MAIN_SCRIPTS_DIR%\repo-status.bat" "%%y" status_!count!
              
              
              
              :: Формируем имя переменной с иконкой
              set "icon_var=hosting_icon_!count!"
              call set "current_icon=%%!icon_var!%%"
              
              :: Отображение с детальным статусом
              if "!status_icon!"=="%GREEN%[✓]%RESET%" (
                echo  %GREEN%!count!.%RESET% %%x %CYAN%!branch_info!%RESET% %GREEN%  ● чистый%RESET%
                ) else if "!status_icon!"=="%YELLOW%[!]%RESET%" (
                echo  %GREEN%!count!.%RESET% %%x %CYAN%!branch_info!%RESET% %YELLOW%  ● изменения%RESET%
                ) else if "!status_icon!"=="%RED%[✗]%RESET%" (
                echo  %GREEN%!count!.%RESET% %%x %CYAN%!branch_info!%RESET% %RED%  ● ошибка%RESET%
                ) else (
                echo  %GREEN%!count!.%RESET% %%x %RED%  ● не найден%RESET%
              )
              set "repo_found=1"
            )
          )
          if !repo_found!==0 echo  %RED%⚠ %%r%RESET%
        )
        ) else (
        echo  %YELLOW%пусто%RESET%
      )
    )
    
    :: Ищем репозитории без группы
    set "has_ungrouped=0"
    for /f "usebackq tokens=1,* delims=;" %%a in ("%CONFIG_FILE%") do (
      findstr /x /c:"%%a" "!MARKED_FILE!" >nul 2>&1
      if errorlevel 1 set "has_ungrouped=1"
    )
    
    if !has_ungrouped!==1 (
      echo.
      echo %BOLD%%YELLOW%  ▸ Без группы:%RESET%
      for /f "usebackq tokens=1,* delims=;" %%a in ("%CONFIG_FILE%") do (
        findstr /x /c:"%%a" "!MARKED_FILE!" >nul 2>&1
        if errorlevel 1 (
          set /a count+=1
          set "repo_name_!count!=%%a"
          set "repo_path_!count!=%%b"
          call "%MAIN_SCRIPTS_DIR%\repo-status.bat" "%%b" status_!count!
          
          
          :: Формируем имя переменной с иконкой
          set "icon_var=hosting_icon_!count!"
          call set "current_icon=%%!icon_var!%%"
          
          :: Отображение с детальным статусом
          if "!status_icon!"=="%GREEN%[✓]%RESET%" (
            echo  %GREEN%!count!.%RESET% %%a %CYAN%!branch_info!%RESET% %GREEN%     ● чистый%RESET%
            ) else if "!status_icon!"=="%YELLOW%[!]%RESET%" (
            echo  %GREEN%!count!.%RESET% %%a %CYAN%!branch_info!%RESET% %YELLOW%    ● изменения%RESET%
            echo  %GREEN%!count!.%RESET% %%a %CYAN%!branch_info!%RESET% %RED%       ● ошибка%RESET%
            ) else (
            echo  %GREEN%!count!.%RESET% %%a %RED%   ● не найден%RESET%
          )
        )
      )
    )
    
    del "!MARKED_FILE!" 2>nul
    
    ) else (
    :: Нет файла групп — показываем все репозитории без групп
    for /f "usebackq tokens=1,* delims=;" %%a in ("%CONFIG_FILE%") do (
      set /a count+=1
      set "repo_name_!count!=%%a"
      set "repo_path_!count!=%%b"
      call "%MAIN_SCRIPTS_DIR%\repo-status.bat" "%%b" status_!count!
      
      :: Проверка хостинга
      set "hosting_icon_!count!="
      if exist "%%b\.git" (
        pushd "%%b" 2>nul
        if not errorlevel 1 (
          for /f "tokens=*" %%u in ('git remote get-url origin 2^>nul') do set "remote_url=%%u"
          popd
          
          echo !remote_url! | findstr /i "github.com" >nul 2>&1
          if not errorlevel 1 set "hosting_icon_!count!=[GH]"
          
          echo !remote_url! | findstr /i "gitlab.com" >nul 2>&1
          if not errorlevel 1 set "hosting_icon_!count!=[GL]"
          
          echo !remote_url! | findstr /i "bitbucket.org" >nul 2>&1
          if not errorlevel 1 set "hosting_icon_!count!=[BB]"
          
          echo !remote_url! | findstr /i "dev.azure.com" >nul 2>&1
          if not errorlevel 1 set "hosting_icon_!count!=[AZ]"
          
          echo !remote_url! | findstr /i "gitea\|gitee" >nul 2>&1
          if not errorlevel 1 set "hosting_icon_!count!=[GT]"
          
          if not defined hosting_icon_!count! (
            echo !remote_url! | findstr /i "git@\|\.git" >nul 2>&1
            if not errorlevel 1 set "hosting_icon_!count!=[GIT]"
          )
        )
      )
      
      :: Формируем имя переменной с иконкой
      set "icon_var=hosting_icon_!count!"
      call set "current_icon=%%!icon_var!%%"
      
      :: Отображение
      echo.
      if "!status_icon!"=="%GREEN%[✓]%RESET%" (
        echo  %GREEN%!count!.%RESET% %%a %CYAN%!branch_info!%RESET% %GREEN%● чистый%RESET% !hosting_icon!
        ) else if "!status_icon!"=="%YELLOW%[!]%RESET%" (
        echo  %GREEN%!count!.%RESET% %%a %CYAN%!branch_info!%RESET% %YELLOW%● изменения%RESET% !hosting_icon!
        ) else if "!status_icon!"=="%RED%[✗]%RESET%" (
        echo  %GREEN%!count!.%RESET% %%a %CYAN%!branch_info!%RESET% %RED%● ошибка%RESET% !hosting_icon!
        ) else (
        echo  %GREEN%!count!.%RESET% %%a %RED%● не найден%RESET%
      )
    )
  )
)

echo.
echo %CYAN%════════════════════════════════════════════════════════════%RESET%
echo %BOLD%%WHITE%▸ ДЕЙСТВИЯ%RESET%
if %count% gtr 0 echo %GREEN%  [1-%count%]  Выбрать%RESET%
echo %CYAN%════════════════════════════════════════════════════════════%RESET%
echo %CYAN%  [C] Клонировать репозиторий%RESET%
echo %CYAN%  [A] Добавить репозиторий %RESET%
echo.
echo %CYAN%  [G] Управление группами%RESET%
echo %CYAN%  [U] Обновить все репозитории %RESET%
echo.
echo %CYAN%  [S] Настройки%RESET%
echo %CYAN%  [D] Удалить %GREEN%(репо удалится только из менеджера)%RESET%
echo %CYAN%════════════════════════════════════════════════════════════%RESET%
echo %RED%  [X] Выход%RESET%
echo %CYAN%════════════════════════════════════════════════════════════%RESET%
echo.
set /p "action=%BOLD%%WHITE%  → %RESET%"

:: Проверяем, число или буква
set is_number=0
echo %action%| findstr /r "^[0-9][0-9]*$" >nul 2>&1
if not errorlevel 1 set is_number=1

if %is_number%==1 (
  if %action% leq %count% (
    set "repo_index=%action%"
    call "%MAIN_SCRIPTS_DIR%\repo-select.bat" "%repo_index%"
    goto MENU
    ) else (
    echo %RED%  ❌ Неверный номер!%RESET%
    pause
    goto MENU
  )
  ) else (
  if /i "%action%"=="C" (
    call "%MAIN_SCRIPTS_DIR%\clone-repo.bat"
    goto MENU
  )
  if /i "%action%"=="A" (
    call "%MAIN_SCRIPTS_DIR%\add-repo.bat"
    goto MENU
  )
  if /i "%action%"=="U" (
    call "%MAIN_SCRIPTS_DIR%\repo-maintenance.bat" UPDATE_ALL
    goto MENU
  )
  if /i "%action%"=="G" (
    call "%MAIN_SCRIPTS_DIR%\groups.bat" MANAGE_GROUPS
    goto MENU
  )
  if /i "%action%"=="D" (
    call "%MAIN_SCRIPTS_DIR%\repo-maintenance.bat" DELETE_REPO
    goto MENU
  )
  if /i "%action%"=="S" (
    call "%MAIN_SCRIPTS_DIR%\repo-maintenance.bat" SETTINGS
    goto MENU
  )
  if /i "%action%"=="X" exit
  echo %RED%  ❌ Неверный выбор!%RESET%
  pause
  goto MENU
)
