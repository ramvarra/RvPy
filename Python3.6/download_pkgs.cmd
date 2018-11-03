@ECHO OFF

REM Create PACKAGE_CACHE, EXTRA_PACAKGES Directories, if not present already
FOR %%D IN (PACKAGE_CACHE EXTRA_PACAKGES) DO (
  IF NOT EXIST %%D (
    ECHO Creating Dir: %%D
    MKDIR %%D
  )
)

ECHO Downloading packages for requirements.txt
python -m pip download -r requirements.txt --dest PACKAGE_CACHE


ECHO Downloading extra EXTRA_PACAKGES

FOR /F "TOKENS=*" %%L IN (extra_requirements.txt) DO (
    ECHO.
	  ECHO PIP Downloading %%L to EXTRA_PACKAGES
    ECHO.
    python -m pip download  %%L --dest PACKAGE_CACHE
)

ECHO Cleanup cache of older versions
python clean_cache.py PACKAGE_CACHE

:END_ALL
