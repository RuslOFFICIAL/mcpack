@echo off
cd /d "%~dp0"
setlocal enabledelayedexpansion

REM Variables.
set "Version=1.0.1"

echo Make-MCPACK %Version%& echo.
echo Available folders:

set "Count=0"
REM Loop through all directories in the current path, excluding "mcpack".
for /d %%D in (*) do (
	if /i not "%%D"=="mcpack" (
		if /i not "%%D"=="example" (
			set /a Count+=1
			set "folder[!Count!]=%%D"
			echo [!Count!] %%D
		)
	)
)

if %Count%==0 (
	echo No pack folders found to compress!
	goto end
)

echo.
set /p "Choice=Enter the number of the folder you want to pack: "

REM Validate the choice.
if not defined folder[%Choice%] (
	echo.& echo Invalid selection! Please run the script again.
	goto end
)
set "Target=!folder[%Choice%]!"

REM Check if "manifest.json" exists in the target folder.
if not exist "%Target%\manifest.json" (
	echo.& echo Error: "manifest.json" not found inside "%Target%"!
	goto end
)
echo.& echo Reading manifest.json...

REM Extract Name and Version from manifest.json.
for /f "delims=" %%a in ('powershell -Command "$json = Get-Content '%Target%\manifest.json' | ConvertFrom-Json; Write-Output $json.header.name; Write-Output (($json.header.version -join '.'))"') do (
	if not defined PackName (
		set "PackName=%%a"
	) else (
		set "PackVersion=%%a"
	)
)

if not exist "mcpack" mkdir "mcpack"
set "FinalName=%PackName%_%PackVersion%.mcpack"
set "TempZip=mcpack\temp_pack.zip"
set "OutputFile=mcpack\%FinalName%"

echo.& echo Packing "%target%" into "%~dp0%outputFile%"...

REM Remove existing files if they already exist
if exist "%TempZip%" del "%TempZip%"
if exist "%OutputFile%" del "%OutputFile%"

REM Compress to a temporary .zip file.
powershell -Command "Compress-Archive -Path '%Target%\*' -DestinationPath '%TempZip%' -CompressionLevel Optimal"

REM Rename the ".zip" file to ".mcpack".
if exist "%TempZip%" (
	ren "%TempZip%" "%FinalName%"
	echo.& endlocal& echo Success! Created: "%~dp0%OutputFile%"
) else (
	echo.& echo Error: Failed to create the package.
)

:End
endlocal
echo.& echo Done!
pause& exit
