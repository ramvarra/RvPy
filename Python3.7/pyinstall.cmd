@ECHO OFF
REM -------------------------------------------------------------------------
REM  Install Base Anaconda Python package
REM -------------------------------------------------------------------------
SET INSTALL_DIR=C:\Anaconda3
set PYTHON_INSTALL_PKG=Anaconda3-5.3.0-Windows-x86_64.exe

REM Check if we are Admin.

NET SESSION >NUL 2>&1
IF %ERRORLEVEL% NEQ 0 (
    ECHO [101mNot running as Admin. Run this from a command prompt opened as Adminstrator[0m
    GOTO END_ALL
)

REM Ensure INSTALL_DIR not present already
IF EXIST "%INSTALL_DIR%\" (
  ECHO INSTALL_DIR %INSTALL_DIR% already present. Please uninstall previous version of Python first.
  GOTO END_ALL
)

ECHO Installing %PYTHON_INSTALL_PKG% to %INSTALL_DIR%
ECHO This will take several minutes. Please be patient and wait for Installation Successful message.
start /wait "" %PYTHON_INSTALL_PKG% /InstallationType=AllUsers /RegisterPython=1 /AddToPath=1 /S /D=%INSTALL_DIR%

IF %ERRORLEVEL% NEQ 0 (
    ECHO [101mFailed to install...[0m
    ECHO.
    GOTO END_ALL
)
ECHO Installation Successful.

:END_ALL
