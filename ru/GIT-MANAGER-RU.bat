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

:: ========== Выравнивание ==========
set "SP80=                                                                                "
set "W_NAME=20"
set "W_BRANCH=8"
set "W_HOSTING=12"

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
<<<<<<< HEAD
echo %CYAN%═════════════════════════════════════════════════════════════%RESET%
echo %BLUE%             GIT-MANAGER 🚀         %YELLOW%by AtinsS%RESET%
echo %CYAN%═════════════════════════════════════════════════════════════%RESET%
=======
echo %CYAN%═══════════════════════════════════════════════════════════════════════════════%RESET%
echo   %BLUE%     ███  ███ █████    █   █  ███  █   █  ███   ███  █████ ████  
echo   %BLUE%    █      █    █      ██ ██ █   █ ██  █ █   █ █     █     █   █ 
echo   %BLUE%    █  ██  █    █      █ █ █ █████ █ █ █ █████ █  ██ ████  ████  
echo   %BLUE%    █   █  █    █      █   █ █   █ █  ██ █   █ █   █ █     █  █  
echo   %BLUE%     ███  ███   █      █   █ █   █ █   █ █   █  ███  █████ █   █  %YELLOW%by AtinsS%RESET%
echo %CYAN%══════════════════════════════════════════════════════════════════════════════%RESET%
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
echo.
set count=0
if exist "%CONFIG_FILE%" (
  echo %BOLD%%WHITE%▸ РЕПОЗИТОРИИ%RESET%
  
  set "MARKED_FILE=%TEMP%\marked_repos_%RANDOM%.tmp"
  set "REPO_MAP_FILE=%TEMP%\repo_map_%RANDOM%.tmp"
  type nul > "!MARKED_FILE!"
  type nul > "!REPO_MAP_FILE!"
  
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
          for /f "usebackq tokens=1,2,3,4 delims=;" %%i in ("%CONFIG_FILE%") do (
            if "%%i"=="%%r" (
              set /a count+=1
<<<<<<< HEAD
              call :SET_HOSTING_LABEL "%%k" "%%l"
              call "%MAIN_SCRIPTS_DIR%\repo-status.bat" "%%j" status_!count!

              if "!status_icon!"=="%GREEN%[✓]%RESET%"  set "status_text=%GREEN%● чистый%RESET%"
              if "!status_icon!"=="%YELLOW%[!]%RESET%" set "status_text=%YELLOW%● изменения%RESET%"
              if "!status_icon!"=="%RED%[✗]%RESET%"    set "status_text=%RED%● ошибка%RESET%"
              if not defined status_text               set "status_text=%RED%● не найден%RESET%"

              call :PRINT_REPO_ROW !count! "%%i" "!branch_info!" "!hosting_label!" "!hosting_plain!" "!status_text!"
              >> "!REPO_MAP_FILE!" echo !count!=%%i
=======
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
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
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
<<<<<<< HEAD
    for /f "usebackq tokens=1,2,3,4 delims=;" %%a in ("%CONFIG_FILE%") do (
=======
    for /f "usebackq tokens=1,* delims=;" %%a in ("%CONFIG_FILE%") do (
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
      findstr /x /c:"%%a" "!MARKED_FILE!" >nul 2>&1
      if errorlevel 1 set "has_ungrouped=1"
    )
    
    if !has_ungrouped!==1 (
      echo.
      echo %BOLD%%YELLOW%  ▸ Без группы:%RESET%
<<<<<<< HEAD
      for /f "usebackq tokens=1,2,3,4 delims=;" %%a in ("%CONFIG_FILE%") do (
        findstr /x /c:"%%a" "!MARKED_FILE!" >nul 2>&1
        if errorlevel 1 (
          set /a count+=1
          call :SET_HOSTING_LABEL "%%c" "%%d"
          call "%MAIN_SCRIPTS_DIR%\repo-status.bat" "%%b" status_!count!

          if "!status_icon!"=="%GREEN%[✓]%RESET%"  set "status_text=%GREEN%● чистый%RESET%"
          if "!status_icon!"=="%YELLOW%[!]%RESET%" set "status_text=%YELLOW%● изменения%RESET%"
          if "!status_icon!"=="%RED%[✗]%RESET%"    set "status_text=%RED%● ошибка%RESET%"
          if not defined status_text               set "status_text=%RED%● не найден%RESET%"

          call :PRINT_REPO_ROW !count! "%%a" "!branch_info!" "!hosting_label!" "!hosting_plain!" "!status_text!"
          >> "!REPO_MAP_FILE!" echo !count!=%%a
=======
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
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
        )
      )
    )
    
    del "!MARKED_FILE!" 2>nul
    
    ) else (
    :: Нет файла групп — показываем все репозитории без групп
<<<<<<< HEAD
    for /f "usebackq tokens=1,2,3,4 delims=;" %%a in ("%CONFIG_FILE%") do (
      set /a count+=1
      call :SET_HOSTING_LABEL "%%c" "%%d"
      call "%MAIN_SCRIPTS_DIR%\repo-status.bat" "%%b" status_!count!

      if "!status_icon!"=="%GREEN%[✓]%RESET%"  set "status_text=%GREEN%● чистый%RESET%"
      if "!status_icon!"=="%YELLOW%[!]%RESET%" set "status_text=%YELLOW%● изменения%RESET%"
      if "!status_icon!"=="%RED%[✗]%RESET%"    set "status_text=%RED%● ошибка%RESET%"
      if not defined status_text               set "status_text=%RED%● не найден%RESET%"

      call :PRINT_REPO_ROW !count! "%%a" "!branch_info!" "!hosting_label!" "!hosting_plain!" "!status_text!"
      >> "!REPO_MAP_FILE!" echo !count!=%%a
=======
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
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
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
<<<<<<< HEAD
    set "repo_name="
    if exist "!REPO_MAP_FILE!" (
      for /f "usebackq tokens=1,2 delims==" %%x in ("!REPO_MAP_FILE!") do (
        if %%x==%action% set "repo_name=%%y"
      )
    )
    if defined repo_name (
      echo !repo_name!>"%TEMP%\repo_index.tmp"
      call "%MAIN_SCRIPTS_DIR%\repo-select.bat" "!repo_name!"
    ) else (
      echo %RED%  ❌ Ошибка: Репозиторий не найден!%RESET%
      pause
    )
    del "!REPO_MAP_FILE!" 2>nul
=======
    set "repo_index=%action%"
    call "%MAIN_SCRIPTS_DIR%\repo-select.bat" "%repo_index%"
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
    goto MENU
    ) else (
    echo %RED%  ❌ Неверный номер!%RESET%
    pause
    del "!REPO_MAP_FILE!" 2>nul
    goto MENU
  )
  ) else (
  if /i "%action%"=="C" (
<<<<<<< HEAD
    del "!REPO_MAP_FILE!" 2>nul
=======
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
    call "%MAIN_SCRIPTS_DIR%\clone-repo.bat"
    goto MENU
  )
  if /i "%action%"=="A" (
<<<<<<< HEAD
    del "!REPO_MAP_FILE!" 2>nul
=======
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
    call "%MAIN_SCRIPTS_DIR%\add-repo.bat"
    goto MENU
  )
  if /i "%action%"=="U" (
<<<<<<< HEAD
    del "!REPO_MAP_FILE!" 2>nul
=======
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
    call "%MAIN_SCRIPTS_DIR%\repo-maintenance.bat" UPDATE_ALL
    goto MENU
  )
  if /i "%action%"=="G" (
<<<<<<< HEAD
    del "!REPO_MAP_FILE!" 2>nul
=======
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
    call "%MAIN_SCRIPTS_DIR%\groups.bat" MANAGE_GROUPS
    goto MENU
  )
  if /i "%action%"=="D" (
<<<<<<< HEAD
    del "!REPO_MAP_FILE!" 2>nul
=======
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
    call "%MAIN_SCRIPTS_DIR%\repo-maintenance.bat" DELETE_REPO
    goto MENU
  )
  if /i "%action%"=="S" (
<<<<<<< HEAD
    del "!REPO_MAP_FILE!" 2>nul
=======
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
    call "%MAIN_SCRIPTS_DIR%\repo-maintenance.bat" SETTINGS
    goto MENU
  )
  if /i "%action%"=="X" exit
  del "!REPO_MAP_FILE!" 2>nul
  echo %RED%  ❌ Неверный выбор!%RESET%
  pause
  goto MENU
)
<<<<<<< HEAD

:SET_HOSTING_LABEL
set "repo_url=%~1"
set "repo_hosting=%~2"
if not defined repo_hosting set "repo_hosting=Local"
if /i "%repo_hosting%"=="Other" call :DETECT_HOSTING_FROM_URL

if /i "%repo_hosting%"=="Local" (
  set "hosting_label=%YELLOW%[Local]%RESET%"
  set "hosting_plain=[Local]"
) else if /i "%repo_hosting%"=="GitHub" (
  set "hosting_label=%CYAN%[GitHub]%RESET%"
  set "hosting_plain=[GitHub]"
) else if /i "%repo_hosting%"=="GitLab" (
  set "hosting_label=%MAGENTA%[GitLab]%RESET%"
  set "hosting_plain=[GitLab]"
) else if /i "%repo_hosting%"=="Bitbucket" (
  set "hosting_label=%BLUE%[Bitbucket]%RESET%"
  set "hosting_plain=[Bitbucket]"
) else if /i "%repo_hosting%"=="Azure DevOps" (
  set "hosting_label=%BLUE%[Azure DevOps]%RESET%"
  set "hosting_plain=[Azure DevOps]"
) else if /i "%repo_hosting%"=="Codeberg" (
  set "hosting_label=%GREEN%[Codeberg]%RESET%"
  set "hosting_plain=[Codeberg]"
) else if /i "%repo_hosting%"=="Gitea" (
  set "hosting_label=%GREEN%[Gitea]%RESET%"
  set "hosting_plain=[Gitea]"
) else if /i "%repo_hosting%"=="Git" (
  set "hosting_label=%WHITE%[Git]%RESET%"
  set "hosting_plain=[Git]"
) else (
  set "hosting_label=%WHITE%[%repo_hosting%]%RESET%"
  set "hosting_plain=[%repo_hosting%]"
)
exit /b 0

:DETECT_HOSTING_FROM_URL
if not defined repo_url exit /b 0
if /i not "!repo_url:github=!"=="!repo_url!" set "repo_hosting=GitHub"
if /i not "!repo_url:gitlab=!"=="!repo_url!" set "repo_hosting=GitLab"
if /i not "!repo_url:bitbucket=!"=="!repo_url!" set "repo_hosting=Bitbucket"
if /i not "!repo_url:dev.azure.com=!"=="!repo_url!" set "repo_hosting=Azure DevOps"
if /i not "!repo_url:visualstudio.com=!"=="!repo_url!" set "repo_hosting=Azure DevOps"
if /i not "!repo_url:codeberg=!"=="!repo_url!" set "repo_hosting=Codeberg"
if /i not "!repo_url:gitea=!"=="!repo_url!" set "repo_hosting=Gitea"
if /i not "!repo_url:gitee=!"=="!repo_url!" set "repo_hosting=Gitea"
if /i "%repo_hosting%"=="Other" if /i not "!repo_url:git@=!"=="!repo_url!" set "repo_hosting=Git"
exit /b 0

:PRINT_REPO_ROW
:: Параметры: номер, имя, ветка, цветной_хостинг, plain_хостинг, статус
set "_r_num=%~1"
set "_r_name=%~2"
set "_r_branch=%~3"
set "_r_hlcol=%~4"
set "_r_hlplain=%~5"
set "_r_st=%~6"

:: Номер (ширина 3, вправо)
set "_r_tmp=  %_r_num%."
set "_r_num_disp=%GREEN%!_r_tmp:~-3!%RESET%"

:: Имя (ширина %W_NAME%)
set "_r_tmp=%_r_name%%SP80%"
set "_r_name_disp=%WHITE%!_r_tmp:~0,%W_NAME%!%RESET%"

:: Ветка (ширина %W_BRANCH%)
set "_r_tmp=%_r_branch%%SP80%"
set "_r_branch_disp=%CYAN%!_r_tmp:~0,%W_BRANCH%!%RESET%"

:: Длина plain-метки
set "_r_hllen=0"
if defined _r_hlplain call :STRLEN "!_r_hlplain!" _r_hllen
set /a _r_pad = W_HOSTING - _r_hllen
if !_r_pad! lss 0 set "_r_pad=0"

:: Собираем цветную метку с пробелами (через промежуточную переменную)
set "_r_pad_spaces=!SP80:~0,%_r_pad%!"
set "_r_hl_disp=!_r_hlcol!!_r_pad_spaces!!RESET!"

echo !_r_num_disp!  !_r_name_disp!  !_r_branch_disp!  !_r_hl_disp!  !_r_st!
exit /b 0

:STRLEN
set "_s=%~1"
set "_len=0"
if defined _s for /l %%a in (0,1,1000) do if "!_s:~%%a,1!" neq "" set /a _len+=1
endlocal & set "%~2=%_len%"
exit /b 0
=======
>>>>>>> e80729d99517f44b23d5675f76d91b041993a785
