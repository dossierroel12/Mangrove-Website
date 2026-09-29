@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ============================================
echo  LeoWorks - First-Time Setup
echo ============================================
echo.

echo [1/4] Installing frontend dependencies (npm install)...
cmd /c npm install
if errorlevel 1 (
    echo.
    echo npm install failed. Make sure Node.js is installed: https://nodejs.org/
    pause
    exit /b 1
)

echo.
echo [2/4] Installing backend dependencies (composer install)...
cd backend
cmd /c composer install
if errorlevel 1 (
    echo.
    echo composer install failed. Make sure Composer is installed: https://getcomposer.org/
    cd /d "%~dp0"
    pause
    exit /b 1
)
cd /d "%~dp0"

echo.
echo [3/4] Checking database configuration...
if not exist "backend\src\config.local.php" (
    copy "backend\src\config.local.example.php" "backend\src\config.local.php" >nul
    echo Created backend\src\config.local.php with default XAMPP settings (root / blank password).
    echo If your database uses different credentials, edit that file now, then re-run this script.
) else (
    echo backend\src\config.local.php already exists - leaving it as is.
)

echo.
echo [4/4] Looking for a backup to restore...
set BACKUP_COUNT=0
set FOUND_BACKUP=
for %%F in ("backend\backups\*.zip") do (
    set /a BACKUP_COUNT+=1
    set "FOUND_BACKUP=%%F"
)

if "%BACKUP_COUNT%"=="0" (
    echo No backup .zip found in backend\backups\ - skipping restore.
    echo (This is expected for a brand-new, empty install with no prior data.)
) else if "%BACKUP_COUNT%"=="1" (
    echo Found backup: !FOUND_BACKUP!
    set /p DO_RESTORE="Restore this backup now? This will replace any existing data. Type Y or N: "
    if /i "!DO_RESTORE!"=="Y" (
        php backend\bin\restore.php "!FOUND_BACKUP!"
    ) else (
        echo Skipped restore. You can run it later by dragging the .zip onto restore.bat.
    )
) else (
    echo Multiple backups found in backend\backups\ - please restore manually:
    echo   drag the one you want onto restore.bat
)

echo.
echo ============================================
echo  Setup complete! Run start-dev.bat to launch LeoWorks.
echo ============================================
echo.
pause
