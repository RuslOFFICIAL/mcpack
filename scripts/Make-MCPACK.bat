@echo off
cd /d "%~dp0"
setlocal enabledelayedexpansion

REM Variables.
set "VariablesFileName=Variables.conf"
set "VariablesFile=..\configs\%VariablesFileName%"

REM Configs.
if exist "%VariablesFile%" (
	for /f "usebackq eol=# tokens=1,2 delims==" %%A in ("%VariablesFile%") do set "%%A=%%~B"
) else (
	echo Warning: File not found at '%VariablesFile%'! & echo Check if there is that file or download it from the repository! & echo.
)

echo Make-MCPACK %Make_MCPACK_Version% & echo.
echo Available folders:

set "Count=0"
REM Loop through directories in parent, using %%~nxD to get just the folder name.
for /d %%D in (..\*) do (
	set "FolderName=%%~nxD"
	if /i not "!FolderName!"=="mcpack" (
		if /i not "!FolderName!"=="example" (
			if /i not "!FolderName!"=="scripts" (
				if /i not "!FolderName!"=="configs" (
					set /a Count+=1
					set "folder[!Count!]=!FolderName!"
					echo [!Count!] !FolderName!
				)
			)
		)
	)
)

if %Count%==0 (
	echo No pack folders found to compress!
	goto end
)

echo.
set /p "Choice=Enter the number of the folder to pack: "

REM Validate the choice.
if not defined folder[%Choice%] (
	echo. & echo Invalid selection! Please run the script again.
	goto end
)
set "TargetName=!folder[%Choice%]!"
set "Target=..\!TargetName!"

REM Check if "manifest.json" exists in the target folder.
if not exist "%Target%\manifest.json" (
	echo. & echo Error: "manifest.json" not found inside "%TargetName%"!
	goto end
)
echo. & echo Reading manifest.json...

REM Extract Name and Version from manifest.json.
for /f "delims=" %%a in ('powershell -Command "$json = Get-Content '%Target%\manifest.json' | ConvertFrom-Json; Write-Output $json.header.name; Write-Output (($json.header.version -join '.'))"') do (
	if not defined PackName (
		set "PackName=%%a"
	) else (
		set "PackVersion=%%a"
	)
)

if not exist "..\mcpack" mkdir "..\mcpack"
set "FinalName=%PackName%_%PackVersion%.mcpack"
set "TempZip=..\mcpack\temp_pack.zip"
set "OutputFile=..\mcpack\%FinalName%"

echo. & echo Packing "%TargetName%" into "mcpack\%FinalName%"...

REM Remove existing files if they already exist
if exist "%TempZip%" del "%TempZip%"
if exist "%OutputFile%" del "%OutputFile%"

REM Compress to a temporary ".zip" file.
powershell -Command "Compress-Archive -Path '%Target%\*' -DestinationPath '%TempZip%' -CompressionLevel Optimal"

REM Rename the ".zip" file to ".mcpack".
if exist "%TempZip%" (
	ren "%TempZip%" "%FinalName%"
	echo. & endlocal & echo Success! Created: "mcpack\%FinalName%"
) else (
	echo. & echo Error: Failed to create the package.
)

:End
endlocal
echo. & echo Done!
pause & exit
