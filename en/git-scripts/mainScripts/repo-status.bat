@echo off
  set "repo_path=%~1"
  set "status_var=%~2"
  set "branch_info="
  
  if exist "%repo_path%" (
    pushd "%repo_path%" 2>nul
    if not errorlevel 1 (
      :: Get current branch
      set "branch_info="
      for /f "tokens=*" %%b in ('git branch --show-current 2^>nul') do set "branch_info=%%b"
      if "!branch_info!"=="" (
        for /f "tokens=2" %%b in ('git branch 2^>nul ^| find "*"') do set "branch_info=%%b"
      )
      if not "!branch_info!"=="" (
        set "branch_info= [!branch_info!]"
        ) else (
        set "branch_info= %RED%[no branch]%RESET%"
      )
      
      :: Check status with details
      git status --porcelain > "%TEMP%\git_status_tmp.txt" 2>&1
      if errorlevel 1 (
        set "status_icon=%RED%[✗]%RESET%"
        set "status_text=%RED%● git error%RESET%"
        ) else (
        set "has_changes=0"
        set "has_added=0"
        set "has_modified=0"
        set "has_deleted=0"
        set "has_untracked=0"
        
        for /f "tokens=1,*" %%i in (%TEMP%\git_status_tmp.txt) do (
          set "line=%%i"
          if "!line:~0,1!"=="A" set "has_added=1"
          if "!line:~0,1!"=="M" set "has_modified=1"
          if "!line:~0,1!"=="D" set "has_deleted=1"
          if "!line:~0,1!"=="?" set "has_untracked=1"
          set "has_changes=1"
        )
        
        if !has_changes!==0 (
          set "status_icon=%GREEN%[✓]%RESET%"
          set "status_text=%GREEN%● clean%RESET%"
          ) else (
          set "status_icon=%YELLOW%[!]%RESET%"
          set "status_text=%YELLOW%●%RESET%"
          if !has_added!==1 set "status_text=!status_text! +"
          if !has_modified!==1 set "status_text=!status_text! M"
          if !has_deleted!==1 set "status_text=!status_text! D"
          if !has_untracked!==1 set "status_text=!status_text! ?"
          set "status_text=!status_text!%RESET%"
        )
      )
      del "%TEMP%\git_status_tmp.txt" 2>nul
      popd
      ) else (
      set "status_icon=%RED%[!]%RESET%"
      set "status_text=%RED%● no access%RESET%"
      set "branch_info=%RED%[no access]%RESET%"
    )
    ) else (
    set "status_icon=%RED%[?]%RESET%"
    set "status_text=%RED%● folder not found%RESET%"
    set "branch_info=%RED%[not found]%RESET%"
  )
  
  set "%status_var%=!status_text!"
  set "branch_%count%=!branch_info!"
  goto :eof
