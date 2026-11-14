@echo off
cd /d "%~dp0"
setlocal enabledelayedexpansion

REM Variables.
set "VariablesFileName=Variables.conf"
set "VariablesFile=..\configs\%VariablesFileName%"
set "TargetFileName=UUIDs-Generated.md"
set "TargetFile=..\configs\%TargetFileName%"

REM Configs.
if exist "%VariablesFile%" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("%VariablesFile%") do set "%%A=%%~B"
) else (
	echo Warning: File not found at '%VariablesFile%'! & echo Check if there is that file or download it from the repository! & echo.
)

echo UUIDs-Generator %UUIDs_Generator_Version% & echo.

REM Confirmation.
set /p "Confirmation=Run this script? (y/N) "
if /i not "%Confirmation%"=="Y" (
	echo. & echo Operation cancelled by user. & echo.
	pause & exit /b
)

if not exist "..\configs" mkdir "..\configs"

REM Generate UUID and save in file.
echo Generating UUIDs. Please wait...
(
	echo Header UUID:
	powershell -NoProfile -Command "(New-Guid).Guid"
	echo.
	echo Modules UUID:
	powershell -NoProfile -Command "(New-Guid).Guid"
) > "%TargetFile%"

REM Convert line endings from CRLF to LF.
powershell -NoProfile -Command "$path = '%TargetFile%'; $c = [System.IO.File]::ReadAllText($path); $utf8NoBOM = New-Object System.Text.UTF8Encoding $false; [System.IO.File]::WriteAllText($path, $c.Replace([string][char]13 + [string][char]10, [string][char]10), $utf8NoBOM)"

REM End.
endlocal
echo. & echo UUIDs saved in the parent directory in "configs\UUIDs-Generated.md" & echo Done!
pause & exit
