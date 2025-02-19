@echo off
setlocal enabledelayedexpansion

:: First check if `install.bat` (this) has needed files in same directory
if not exist %~dp0\cmdbot.py ( echo `cmdbot.py` missing in %~dp0 cannot install & goto :choice_default_3 )
if not exist %~dp0\prompt.txt ( echo `prompt.txt` missing in %~dp0 cannot install & goto :choice_default_3 ) 
if not exist %~dp0\cmdbot.yaml ( echo `cmdbot.yaml` missing in %~dp0 cannot install & goto :choice_default_3 ) 


:: Note: "~" or %HOME% is equivalent to "%HOMEDRIVE%%HOMEPATH%\" but the latter is set in VM environments (from what I can tell)
:: INSTALL_DIR = Directory the "cmdbot-ai-cmdbot\" will go to.
:: SCRIPT_DIR = Directory the "cmdbot.bat" script will go to.
:: createDIR = Whether or not a seperate "cmdbot-ai-cmdbot\" directory will be made/used to hold "cmdbot.py" and "prompt.txt". 1=Yes, 2=Just_use_Repo (the folder this is in)
:: createAPIKEY = Whether to create a ".openai.apikey" at %HOMEDRIVE%%HOMEPATH%\. 1=Yes, 2=No

:: Default values:
set "INSTALL_DIR=%HOMEDRIVE%%HOMEPATH%\"
set "SCRIPT_DIR=%HOMEDRIVE%%HOMEPATH%\"
set /a "createDIR=1"
set /a "createAPIKEY=2"
set "installing=1"

:: Set Variables To User Defined If Needed 
:: (This was as painful to make as it looks)
cls
call :print_default
choice /n /c YNCO /m "Let me know which option you want to select: "
set installing=%ERRORLEVEL%
goto :choice_default_!ERRORLEVEL!

:choice_default_2
cls
call :print_use_directory
choice /n /c YN /m "Let me know which option you want to select: "
set /a createDIR=%ERRORLEVEL%
goto :choice_use_directory_!ERRORLEVEL!

:choice_use_directory_1
cls
call :print_install
choice /n /c NY /m "Let me know which option you want to select: "
goto :choice_install_!ERRORLEVEL!

:choice_install_1
set /p INSTALL_DIR="Enter a path for `cmdbot-ai-cmdbot\` to be made:"
if exist !INSTALL_DIR!\ ( goto :choice_use_directory_1 ) else ( echo This file path does not exist & goto :choice_install_1 )

:choice_install_2
:choice_use_directory_2
cls
call :print_script
choice /n /c NY /m "Let me know which option you want to select: "
goto :choice_script_!ERRORLEVEL!

:choice_script_1
set /p SCRIPT_DIR="Enter a path for `cmdbot.bat` to be made:"
if exist !SCRIPT_DIR!\ ( goto :choice_use_directory_2 ) else ( echo This file path does not exist & goto :choice_script_1 )

:choice_script_2
:choice_default_1
set "TARGET_DIR=!INSTALL_DIR!\cmdbot-ai-cmdbot\"
set "TARGET_FULLPATH=!TARGET_DIR!\cmdbot.py"

::Actually Install cmdbot
cls
if /i %createDIR%==1 ( call :install_cmdbot_directory )
if /i %createDIR%==2 ( call :install_cmdbot_repository )

::Make sure safety is on when default installing 
::Note: when upgrading from v0.1 to v0.3 it will delete the file. 
::With v.0.2 the safety switch moved to the config file cmdbot.yaml
if /i !installing!==1 ( del %HOMEDRIVE%%HOMEPATH%\.cmdbot-safety-off )

:choice_default_4
::Optional files (Only runs in non-Default install or Optional File Install):
if /i !installing!==2 ( call :install_optional )
if /i !installing!==4 ( call :install_optional )

::Show a guide
cls
if /i !installing!==1 ( call :print_guide )
if /i !installing!==2 ( call :print_guide )


:: End Point
:choice_default_3
pause
:: In Case of Errors in Choice
:choice_default_0
:choice_default_9009
:choice_install_0
:choice_install_9009
:choice_script_0
:choice_script_9009
:choice_use_directory_0
:choice_use_directory_9009
color
goto :EOF

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                              Functions                                                             ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                             Installation                                                           ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Installs cmdbot using created directory
:install_cmdbot_directory
echo Installing cmdbot (Using Created Directory)
call :create_cmdbot_directory
call :create_cmdbot_bat_from_directory
call :create_env_in_directory
goto :EOF

:: Installs cmdbot using cloned repositiory
:install_cmdbot_repository
echo Installing cmdbot (Using Cloned Repository)
call :create_cmdbot_bat_from_repository
call :create_env_in_repository
goto :EOF

:: Installs optional files if user wants
:install_optional
cls
call :print_apikey
choice /n /c YN /m "Let me know which option you want to select: "
set /a createAPIKEY=!ERRORLEVEL!

if /i !createAPIKEY!==1 ( call :create_openai_apikey )
goto :EOF

:: Creates a directory to hold cmdbot.py and prompt.txt
:create_cmdbot_directory
echo cmdbot Directory:
echo Installing to !TARGET_DIR!
mkdir !TARGET_DIR!
copy  %~dp0\cmdbot.py !TARGET_DIR!
copy  %~dp0\prompt.txt !TARGET_DIR!
copy  %~dp0\cmdbot.yaml !TARGET_DIR!
goto :EOF

:: Create cmdbot.bat and input code linking to created directory
:create_cmdbot_bat_from_directory
echo cmdbot Batch (Directory):
echo `cmdbot.py` should be in `!TARGET_DIR!`...
if not exist !TARGET_FULLPATH! ( echo Not Found: Aborting "create_cmdbot_bat_from_directory" ) else (
    echo Found: Creating `cmdbot.bat` in `!SCRIPT_DIR!`
    copy nul !SCRIPT_DIR!\cmdbot.bat
    echo @echo off>!SCRIPT_DIR!\"cmdbot.bat"
    echo python.exe !TARGET_DIR!\cmdbot.py %%*>>!SCRIPT_DIR!\"cmdbot.bat"
)
goto :EOF

:: Create cmdbot.bat and input code linking to repository
:create_cmdbot_bat_from_repository
echo cmdbot Batch (Repository):
echo `cmdbot.py` should be in `%~dp0`...
if not exist %~dp0\cmdbot.py ( echo Not Found: Aborting "create_cmdbot_bat_from_repository") else (
    echo Found: Creating `cmdbot.bat` in `!SCRIPT_DIR!`
    copy nul !SCRIPT_DIR!\cmdbot.bat
    echo @echo off>!SCRIPT_DIR!\"cmdbot.bat"
    echo python.exe %~dp0\cmdbot.py %%*>>!SCRIPT_DIR!\"cmdbot.bat"
)
goto :EOF

::  :: Creates the .openai.apikey if it doesn't already exists (otherwise, does nothing)
::  :create_openai_apikey
::  echo cmdbot OpenAi ApiKey:
::  echo Creating `.open.apikey` (if not already exists) in `%HOMEDRIVE%%HOMEPATH%\`
::  copy nul %~dp0\.openai.apikey
::  robocopy %~dp0 %HOMEDRIVE%%HOMEPATH%\ .openai.apikey /xc /xn /xo /nfl /ndl /njh /njs /nc /ns /np
::  del %~dp0\.openai.apikey
::  goto :EOF

:: Creates the .env if it doesn't already exists in chosen install directory (otherwise, does nothing)
:create_env_in_directory
echo cmdbot .Env:
echo Creating `.env` (if not already exists) in `!TARGET_DIR!`
if not exist %~dp0\.env ( copy nul %~dp0\.env  & robocopy %~dp0 !TARGET_DIR! .env /xc /xn /xo /nfl /ndl /njh /njs /nc /ns /np & del %~dp0\.env ) else ( robocopy %~dp0 !TARGET_DIR! .env /xc /xn /xo /nfl /ndl /njh /njs /nc /ns /np )
goto :EOF

:: Creates the .env if it doesn't already exists in chosen install directory (otherwise, does nothing)
:create_env_in_repository
echo cmdbot .Env:
echo Creating `.env` (if not already exists) in `%~dp0`
if not exist %~dp0\.env ( copy nul %~dp0\.env ) else ( echo Already Exists )
goto :EOF

::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::                                              Messages                                                              ::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::Prints a prompt for initial installing options
:print_default
echo Welcome to the cmdbot installer. 
echo.
echo Installation Options:
echo.
echo [Y] cmdbot, Default installation to your home folder ( `%HOMEDRIVE%%HOMEPATH%\` )
echo [N] Non-default install, Set custom install locations
echo [C] Cancel, Do not install (exit this script)
echo [O] Optional Files (advanced options) 
echo.
echo You probably want to use [Y].
echo.
goto :EOF

:: Prints a prompt for folder installation
:print_use_directory
echo.
echo Installation Folder Options:
echo.
echo [Y] Yes, Will create a seperate `cmdbot-ai-cmdbot\` folder to run cmdbot and you can delete the folder holding this `install.bat` after.
echo [N] No , Will use the folder holding `install.bat` (`%~dp0`) to run cmdbot.
echo.
echo You probably want to use [Y].
echo.
goto :EOF

:: Prints a prompt for folder installation location
:print_install
echo.
echo Installation `cmdbot-ai-cmdbot\` folder Options:
echo.
echo [Y] Yes, Will use the current filepath of: `!INSTALL_DIR!`
echo [N] No, Will let you paste in a file path
echo.
echo Note: If you manually move this folder you need to run `install.bat` again for a new `cmdbot.bat` file.
echo.
goto :EOF

:: Prints a prompt for `cmdbot.bat` location
:print_script
echo.
echo Installation `cmdbot.bat` File Options:
echo.
echo This file will let you run cmdbot from the directory it is installed using:
echo `.\cmdbot.bat [Enter Prompt Here]` in terminal
echo or `cmdbot [Enter Prompt Here]` if it is in a $PATH folder
echo.
echo [Y] Yes, Will use the current filepath of: `!SCRIPT_DIR!`
echo [N] No, Will let you paste in a file path
echo.
echo You probably want to use [Y], you can manually move the `cmdbot.bat` file afterwards.
echo.
goto :EOF

:: Prints a prompt for `.openai.apikey`
:print_apikey
echo.
echo DEPRECATED - SELECTE N - Installation `.openai.apikey` File Options:
echo.
echo This file can hold your openai apikey to let you run cmdbot
echo.
echo [Y] Yes, Create a `.openai.apikey` if it does not exist at `%HOMEDRIVE%%HOMEPATH%\`
echo [N] No, Will skip this.
echo.
echo If you do not understand what this means, select [N]
echo.
goto :EOF

:: Prints a "Finished Installing" and usage message after installing
:print_guide
echo.
echo Finished Installing cmdbot.
echo.
echo Run commands by being in the same directory as your `cmdbot.bat` file ( It is in `!SCRIPT_DIR!` ):
echo `.\cmdbot.bat [Enter Prompt Here]`
echo. 
echo Or, put the `cmdbot.bat` file into a $PATH directory and run it like so, instead:
echo `cmdbot [Enter Prompt Here]`
echo.
if /i !createDIR!==1 ( call :print_bat_warning_directory )
if /i !createDIR!==2 ( call :print_bat_warning_repository )
set /p "wait=Press [Enter] for more:"
call :print_apikey_guide
echo.
goto :EOF

:print_bat_warning_directory
echo.
echo Warning:
echo.
echo If `!TARGET_DIR! is moved or deleted then the `cmdbot.bat` file will not work.
echo You will need to run `install.bat` again to create a new `cmdbot.bat` file that links to the correct folder.
echo However, `cmdbot.bat` can be moved from `!SCRIPT_DIR!` and still work.
goto :EOF

:print_bat_warning_repository
echo.
echo Warning:
echo.
echo If the `%~dp0` folder is moved or deleted then the `cmdbot.bat` file will not work.
echo You will need to run `install.bat` again to create a new `cmdbot.bat` file that links to the correct folder.
echo However, `cmdbot.bat` can be moved from `!SCRIPT_DIR!` and still work.
goto :EOF

:print_apikey_guide
echo.
echo API Key:
echo.
echo You need to provide your OpenAI API key to use cmdbot.
echo.
echo You can get a key from `https://oai.azure.com/portal/` after logging in.
echo There are multiple options for providing the key:
echo (2) You can paste `OPENAI_API_KEY="[yourkey]"` into a `.env` file that should be in the folder cmdbot is installed in currently.
if /i !createDIR!==1 ( echo `.env` should be in: !TARGET_DIR! )
if /i !createDIR!==2 ( echo `.env` should be in: %~dp0 )
echo (3) You can run `$env:OPENAI_API_KEY="[yourkey]"` in your terminal before using cmdbot in that terminal
echo   -If you run PowerShell as administrator you can then run `setx OPENAI_API_KEY "[yourkey]"` to permanently and use cmdbot in any terminal (you may need to reopen the terminal once).
echo   -Go to `Start` and search `edit environment variables for your account` and manually create the variable with name `OPENAI_API_KEY` and value `[yourkey]`
echo (4) Another option is to put the API key in the cmdbot.yaml configuration file (since v.0.2)
echo.
goto :EOF