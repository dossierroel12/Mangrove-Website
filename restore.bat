@echo off
cd /d "%~dp0"

REM Restores a backup .zip (database + uploaded photos).
REM Drag a backup .zip onto this file, or double-click and enter the path when asked.
php backend\bin\restore.php %*

pause
