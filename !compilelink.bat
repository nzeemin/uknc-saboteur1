@echo off
set rt11exe=C:\bin\rt11\rt11.exe

rem Define ESCchar to use in ANSI escape sequences
rem https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line
for /F "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do set "ESCchar=%%E"

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "DATESTAMP=%YYYY%-%MM%-%DD%"
for /f %%i in ('git rev-list HEAD --count') do (set REVISION=%%i)
echo REV.%REVISION% %DATESTAMP%

echo 	.ASCII /REV.%REVISION% %DATESTAMP%/ > VERSIO.MAC

@if exist S1CORE.LST del S1CORE.LST
@if exist S1CORE.OBJ del S1CORE.OBJ
@if exist S1CORE.MAP del S1CORE.MAP
@if exist S1CORE.SAV del S1CORE.SAV
@if exist SABOT1.SAV del SABOT1.SAV

%rt11exe% MACRO/LIST:DK: S1CORE.MAC

for /f "delims=" %%a in ('findstr /B "Errors detected" S1CORE.LST') do set "errdet=%%a"
if "%errdet%"=="Errors detected:  0" (
  echo S1CORE COMPILED SUCCESSFULLY
) ELSE (
  findstr /RC:"^[ABDEILMNOPQRTUZ] " S1CORE.LST
  echo ======= %errdet% =======
  goto :Failed
)

%rt11exe% LINK S1CORE /MAP:S1CORE.MAP

for /f "delims=" %%a in ('findstr /B "Undefined globals" S1CORE.MAP') do set "undefg=%%a"
if "%undefg%"=="" (
  type S1CORE.MAP
  echo.
  echo S1CORE LINKED SUCCESSFULLY
) ELSE (
  echo ======= LINK FAILED =======
  goto :Failed
)

dir /-c S1CORE.SAV|findstr /R /C:"S1CORE.SAV"

echo %ESCchar%[92mSUCCESS%ESCchar%[0m
exit

:Failed
@echo off
echo %ESCchar%[91mFAILED%ESCchar%[0m
exit /b

:FileSize
set fsize=%~z1
exit /b 0
