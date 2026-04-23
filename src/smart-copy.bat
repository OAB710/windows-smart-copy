@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM ====================== MAIN CONFIGURATION ======================

REM Configure source, build, and zip output paths.
REM Example: set "SRC=D:\A" & set "DST=D:\A_build" & set "ZIP=D:\A_build.zip"
set "SRC=<SOURCE_FOLDER>" & set "DST=<BUILD_FOLDER>" & set "ZIP=<ZIP_FILE_PATH>"

REM ======================== IGNORE LIST ===========================

REM List full paths to exclude, separated by "|".
REM Example: set "IGNORE_PATHS=D:\A\C|D:\A\Temp|D:\A\2.txt|D:\A\B\4.txt"
set "IGNORE_PATHS=<FULL_PATH>|<FULL_PATH>"

REM ====================== CHECK SOURCE PATH =======================

REM Stop the script if the source folder does not exist.
if not exist "%SRC%" (
    echo [ERROR] Source folder not found:
    echo %SRC%
    goto :end
)

REM ===================== RESET BUILD FOLDER =======================

REM Remove the old build folder if it exists, then recreate it.
if exist "%DST%" (
    echo [INFO] Removing old build folder: %DST%
    rmdir /S /Q "%DST%"
)

mkdir "%DST%"

REM =================== BUILD ROBOCOPY EXCLUDES ====================

REM Convert IGNORE_PATHS into robocopy exclusion arguments.
set "XD_ARGS="
set "XF_ARGS="

if not "%IGNORE_PATHS%"=="" (
    for %%P in ("%IGNORE_PATHS:|=" "%") do (
        if exist "%%~P\" (
            set "XD_ARGS=!XD_ARGS! /XD %%~P"
        ) else (
            set "XF_ARGS=!XF_ARGS! /XF %%~P"
        )
    )
)

REM ========================= COPY FILES ===========================

REM Copy all files and subfolders from SRC to DST, excluding ignored paths.
echo.
echo =========================================================
echo Copying from:
echo   %SRC%
echo To:
echo   %DST%
echo =========================================================
echo.

robocopy "%SRC%" "%DST%" /E %XD_ARGS% %XF_ARGS%

REM ========================= CREATE ZIP ===========================

REM Compress the build folder into a ZIP archive.
echo.
echo =========================================================
echo Creating ZIP archive:
echo   %ZIP%
echo =========================================================
echo.

powershell -NoProfile -Command "Compress-Archive -Path '%DST%\*' -DestinationPath '%ZIP%' -Force"

if exist "%ZIP%" (
    echo.
    echo [OK] ZIP archive created successfully:
    echo %ZIP%
) else (
    echo.
    echo [ERROR] Failed to create ZIP archive.
)

REM ============================ END ===============================

:end
echo.
pause