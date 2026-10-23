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

REM Convert line endings from CRLF to LF.
powershell -NoProfile -Command "$c = [System.IO.File]::ReadAllText('UUIDs-Generated.md'); [System.IO.File]::WriteAllText('UUIDs-Generated.md', $c.Replace([string][char]13 + [string][char]10, [string][char]10), [System.Text.Encoding]::UTF8)"

REM End.
endlocal
echo. & echo UUIDs saved in "UUIDs-Generated.md" & echo Done!
pause & exit
