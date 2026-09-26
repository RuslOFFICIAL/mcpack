@echo off
cd /d "%~dp0"
setlocal enabledelayedexpansion

REM Generate UUID and save in file.
echo Generating UUIDs. Please wait...
(
	echo Header UUID:
	powershell -NoProfile -Command "(New-Guid).Guid"
	echo.
	echo Modules UUID:
	powershell -NoProfile -Command "(New-Guid).Guid"
) > UUIDs-Generated.md

REM End.
endlocal
echo.& echo UUIDs saved in "UUIDs-Generated.md"& echo Done!
pause& exit
