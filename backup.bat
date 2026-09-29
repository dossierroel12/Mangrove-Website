@echo off
cd /d "%~dp0"

REM Creates a full backup (database + uploaded photos) in backend\backups\
php backend\bin\backup.php %*

pause
