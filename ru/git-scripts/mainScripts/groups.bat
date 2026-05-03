@echo off
setlocal enabledelayedexpansion
if "%~1"=="" goto :eof
set "__MAIN_SCRIPT_ACTION=%~1"
shift /1
goto :%__MAIN_SCRIPT_ACTION%
  :ADD_REPO_TO_GROUP
  set "repo_to_add=%~1"
  
  :: Проверяем есть ли группы
  if not exist "%GROUPS_FILE%" (
    echo %YELLOW%  ⚠ Нет созданных групп. Хотите создать новую?%RESET%
    set /p "create_new=%YELLOW%    [y/n]: %RESET%"
    if /i "!create_new!"=="y" call :CREATE_GROUP_FROM_ADD "%repo_to_add%"
    goto :eof
  )
  
  :: Проверяем, есть ли вообще группы в файле
  set "group_exists=0"
  for /f "usebackq tokens=1 delims=;" %%a in ("%GROUPS_FILE%") do (
    if not "%%a"=="" set "group_exists=1"
  )
  
  if !group_exists!==0 (
    echo %YELLOW%  ⚠ Нет созданных групп. Хотите создать новую?%RESET%
    set /p "create_new=%YELLOW%    [y/n]: %RESET%"
    if /i "!create_new!"=="y" call :CREATE_GROUP_FROM_ADD "%repo_to_add%"
    goto :eof
  )
  
  :: Показываем существующие группы
  echo.
  echo %BOLD%%WHITE%  Выберите группу:%RESET%
  set group_count=0
  for /f "usebackq tokens=1 delims=;" %%a in ("%GROUPS_FILE%") do (
    if not "%%a"=="" (
      set /a group_count+=1
      set "group_name_add_!group_count!=%%a"
      echo %GREEN%  !group_count!.%RESET% %%a
    )
  )
  echo %GREEN%  0.%RESET% Создать новую группу
  
  echo.
  set /p "group_choice=%BOLD%%WHITE%    ⚡ Ваш выбор: %RESET%"
  
  if "!group_choice!"=="0" (
    call :CREATE_GROUP_FROM_ADD "%repo_to_add%"
    goto :eof
  )
  
  set "selected_group=!group_name_add_%group_choice%!"
  
  :: Создаем временный файл
  set "temp_groups=%TEMP%\groups_%RANDOM%.tmp"
  type nul > "!temp_groups!"
  
  :: Обрабатываем файл groups.cfg
  set "repo_added=0"
  for /f "usebackq tokens=1,* delims=;" %%a in ("%GROUPS_FILE%") do (
    if "%%a"=="!selected_group!" (
      set "current_repos=%%b"
      
      :: Проверяем, есть ли уже репозиторий в группе
      echo "!current_repos!" | find "!repo_to_add!" >nul 2>&1
      if errorlevel 1 (
        :: Добавляем репозиторий
        if "!current_repos!"=="" (
          echo %%a;!repo_to_add!>> "!temp_groups!"
          ) else (
          echo %%a;!current_repos!;!repo_to_add!>> "!temp_groups!"
        )
        set "repo_added=1"
        echo %GREEN%  ✅ Репозиторий "%repo_to_add%" добавлен в группу "%selected_group%"%RESET%
        ) else (
        echo %%a;%%b>> "!temp_groups!"
        echo %YELLOW%  ⚠ Репозиторий "%repo_to_add%" уже находится в группе "%selected_group%"%RESET%
      )
      ) else (
      echo %%a;%%b>> "!temp_groups!"
    )
  )
  
  :: Заменяем файл
  move /y "!temp_groups!" "%GROUPS_FILE%" >nul 2>&1
  
  if !repo_added!==0 (
    echo %RED%  ❌ Не удалось добавить репозиторий в группу%RESET%
  )
  
  pause
  goto :eof
  
  :CREATE_GROUP_FROM_ADD
  set "repo_to_add=%~1"
  echo.
  set /p "new_group=%GREEN%    📝 Введите название новой группы: %RESET%"
  
  if "!new_group!"=="" (
    echo %RED%  ❌ Название не может быть пустым!%RESET%
    pause
    goto :eof
  )
  
  :: Проверяем, существует ли уже такая группа
  if exist "%GROUPS_FILE%" (
    findstr /b "!new_group!;" "%GROUPS_FILE%" >nul 2>&1
    if not errorlevel 1 (
      echo %RED%  ❌ Группа с таким именем уже существует!%RESET%
      pause
      goto :eof
    )
  )
  
  :: Создаем группу и добавляем репозиторий
  echo !new_group!;%repo_to_add%>> "%GROUPS_FILE%"
  echo %GREEN%  ✅ Группа "%new_group%" создана и репозиторий добавлен!%RESET%
  pause
  goto :eof
  :MANAGE_GROUPS
  cls
  echo %BOLD%%CYAN%  📚 УПРАВЛЕНИЕ ГРУППАМИ%RESET%
  echo.
  echo %GREEN%  1.%RESET% Создать новую группу
  echo %GREEN%  2.%RESET% Добавить репозиторий в группу
  echo %GREEN%  3.%RESET% Удалить репозиторий из группы
  echo %GREEN%  4.%RESET% Показать все группы
  echo %GREEN%  5.%RESET% Удалить группу
  echo %RED%  6.%RESET% Назад
  echo.
  set /p "grp_act=%BOLD%%WHITE% → %RESET%"
  
  if "!grp_act!"=="1" goto CREATE_GROUP
  if "!grp_act!"=="2" goto ADD_TO_GROUP
  if "!grp_act!"=="3" goto REMOVE_FROM_GROUP
  if "!grp_act!"=="4" goto SHOW_GROUPS
  if "!grp_act!"=="5" goto DELETE_GROUP
  if "!grp_act!"=="6" exit /b 0
  goto MANAGE_GROUPS
  
  :CREATE_GROUP
  cls
  echo %BOLD%%CYAN%  ✨ СОЗДАНИЕ ГРУППЫ%RESET%
  echo.
  set /p "new_group=%GREEN%    📝 Введите название группы: %RESET%"
  
  if "!new_group!"=="" (
    echo %RED%  ❌ Название не может быть пустым!%RESET%
    pause
    goto MANAGE_GROUPS
  )
  
  if exist "%GROUPS_FILE%" (
    findstr /b "!new_group!;" "%GROUPS_FILE%" >nul 2>&1
    if not errorlevel 1 (
      echo %RED%  ❌ Группа с таким именем уже существует!%RESET%
      pause
      goto MANAGE_GROUPS
    )
  )
  
  echo !new_group!;>> "%GROUPS_FILE%"
  echo %GREEN%  ✅ Группа "%new_group%" создана!%RESET%
  pause
  goto MANAGE_GROUPS
  
  :ADD_TO_GROUP
cls
echo %BOLD%%CYAN%  📌 ДОБАВЛЕНИЕ В ГРУППУ%RESET%
echo.

echo %BOLD%%WHITE%  Существующие группы:%RESET%
set group_count=0
if exist "%GROUPS_FILE%" (
  for /f "usebackq tokens=1 delims=;" %%a in ("%GROUPS_FILE%") do (
    if not "%%a"=="" (
      set /a group_count+=1
      set "group_name_!group_count!=%%a"
      echo %GREEN%  !group_count!.%RESET% %%a
    )
  )
) else (
  echo %YELLOW%  Нет созданных групп%RESET%
  pause
  goto MANAGE_GROUPS
)

if !group_count!==0 (
  echo %YELLOW%  Нет созданных групп%RESET%
  pause
  goto MANAGE_GROUPS
)

echo.
set /p "group_num=%BOLD%%WHITE%    ⚡ Выберите номер группы: %RESET%"
set "selected_group=!group_name_%group_num%!"

if "!selected_group!"=="" (
  echo %RED%  ❌ Неверный выбор!%RESET%
  pause
  goto MANAGE_GROUPS
)

echo.
echo %BOLD%%WHITE%  Репозитории не в группах:%RESET%
set repo_count=0
for /f "usebackq tokens=1,* delims=;" %%a in ("%CONFIG_FILE%") do (
  set "in_group=0"
  if exist "%GROUPS_FILE%" (
    for /f "usebackq tokens=2 delims=;" %%g in ("%GROUPS_FILE%") do (
      if not "%%g"=="" (
        for %%r in (%%g) do (
          if "%%r"=="%%a" set "in_group=1"
        )
      )
    )
  )
  if !in_group!==0 (
    set /a repo_count+=1
    set "repo_name_add_!repo_count!=%%a"
    echo %GREEN%  !repo_count!.%RESET% %%a
  )
)

if !repo_count!==0 (
  echo %YELLOW%  Нет репозиториев для добавления%RESET%
  pause
  goto MANAGE_GROUPS
) else (
  echo.
  set /p "repo_num=%BOLD%%WHITE%    ⚡ Выберите номер репозитория: %RESET%"
  set "selected_repo=!repo_name_add_%repo_num%!"
)

if "!selected_repo!"=="" (
  echo %RED%  ❌ Неверный выбор!%RESET%
  pause
  goto MANAGE_GROUPS
)

set "temp_groups=%TEMP%\groups_%RANDOM%.tmp"
type nul > "!temp_groups!"
set "group_found=0"

if exist "%GROUPS_FILE%" (
  for /f "usebackq tokens=1,* delims=;" %%a in ("%GROUPS_FILE%") do (
    if "%%a"=="!selected_group!" (
      set "current_repos=%%b"
      if "!current_repos!"=="" (
        echo %%a;!selected_repo!>> "!temp_groups!"
      ) else (
        echo %%a;!current_repos!;!selected_repo!>> "!temp_groups!"
      )
      set "group_found=1"
    ) else (
      echo %%a;%%b>> "!temp_groups!"
    )
  )
)

if !group_found!==0 (
  echo !selected_group!;!selected_repo!>> "!temp_groups!"
)

move /y "!temp_groups!" "%GROUPS_FILE%" >nul 2>&1

echo %GREEN%  ✅ Репозиторий "%selected_repo%" добавлен в группу "%selected_group%"%RESET%
pause
goto MANAGE_GROUPS
  
  :DELETE_GROUP
  cls
  echo %BOLD%%CYAN%  🗑️ УДАЛЕНИЕ ГРУППЫ%RESET%
  echo.
  
  if exist "%GROUPS_FILE%" (
    for /f "usebackq tokens=1 delims=;" %%a in ("%GROUPS_FILE%") do (
      echo %GREEN%  -%RESET% %%a
    )
    ) else (
    echo %YELLOW%  Нет групп для удаления%RESET%
    pause
    goto MANAGE_GROUPS
  )
  
  echo.
  set /p "group_del_name=%BOLD%%WHITE%    Введите название группы для удаления: %RESET%"
  
  set "temp_groups=%TEMP%\groups.tmp"
  type nul > "!temp_groups!"
  if exist "%GROUPS_FILE%" (
    for /f "usebackq tokens=1,* delims=;" %%a in ("%GROUPS_FILE%") do (
      if not "%%a"=="!group_del_name!" (
        echo %%a;%%b>> "!temp_groups!"
      )
    )
    move /y "!temp_groups!" "%GROUPS_FILE%" >nul 2>&1
  )
  
  echo %GREEN%  ✅ Группа удалена%RESET%
  pause
  goto MANAGE_GROUPS
