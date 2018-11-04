@ECHO OFF



WHERE python > %TEMP%\python_path.txt
SET /p PYTHON_EXE_PATH=<%TEMP%\python_path.txt
DEL /q %TEMP%\python_path.txt



IF "%PYTHON_EXE_PATH:~-10%" NEQ "python.exe" (
    echo [101mUnable to find python with WHERE[0m
    GOTO END_ALL
)

FOR %%I in ("%PYTHON_EXE_PATH%") DO (
    SET PYTHON_DIR=%%~dpI
)

REM Ensure no python instances are Running
TASKLIST /V /FI "IMAGENAME EQ PYTHON*" > %TEMP%\task_list.txt
findstr /c:"INFO: No tasks are running which match the specified criteria" %TEMP%\task_list.txt > NUL 2>&1
IF NOT %ERRORLEVEL% == 0 (
    ECHO Folllowing Python processes running. Stop these first.
    TYPE %TEMP%\task_list.txt
    DEL %TEMP%\task_list.txt
    GOTO END_ALL
)
DEL %TEMP%\task_list.txt

REM ECHO Uninstalling JypterLab
REM pip uninstall -y jupyterlab

REM UPGRADE PIP
python -m pip install --force-reinstall --upgrade --no-index --find-links PACKAGE_CACHE pip

ECHO Installing Extra Pkgs...
FOR %%F in (EXTRA_PACKAGES\*.*) DO (
    ECHO.
    ECHO Installing %%F
    ECHO.
    pip install --force-reinstall --upgrade --no-index --find-links PACKAGE_CACHE %%F
)

ECHO Installing Python Packages requirements.txt from PACKAGE_CACHE


SET TMP_REQ=%TEMP%\requirements.tmp
PYTHON pycat.py requirements.txt > %TMP_REQ%

FOR /F "TOKENS=*" %%L IN (%TMP_REQ%) DO (
    ECHO.
	ECHO PIP Installing %%L from PACKAGE_CACHE %%L
    ECHO.

    PIP install %%L --upgrade --no-index --find-links package_cache

)



ECHO.
ECHO Applying ActiveDirectory patch
REM XCOPY /E /F /R /Y PATCH\* %PYTHON_DIR%
PYTHON patch_adsi.py


REM Check admin rights
ECHO.
ECHO Setting Python file association

ECHO.
NET SESSION >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO [101mNot running as Admin. Can not set python file association.[0m
    ECHO.
    GOTO END_ALL
)


ASSOC .py=Python.File
FTYPE Python.File="%PYTHON_EXE_PATH%" "%%1" %%*

:ERROR_END
GOTO END_ALL


:END_ALL
