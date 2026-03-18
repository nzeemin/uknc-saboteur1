@echo off

rem Define ESCchar to use in ANSI escape sequences
rem https://stackoverflow.com/questions/2048509/how-to-echo-with-different-colors-in-the-windows-command-line
for /F "delims=#" %%E in ('"prompt #$E# & for %%E in (1) do rem"') do set "ESCchar=%%E"

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "DATESTAMP=%YYYY%-%MM%-%DD%"
for /f %%i in ('git rev-list HEAD --count') do (set REVISION=%%i)
echo REV.%REVISION% %DATESTAMP%

echo 	.ASCII /REV.%REVISION% %DATESTAMP%/ > VERSIO.MAC

@if exist SABOT1.LST del SABOT1.LST
@if exist SABOT1.OBJ del SABOT1.OBJ
@if exist SABOT1.MAP del SABOT1.MAP
@if exist SABOT1.SAV del SABOT1.SAV
@if exist SABOT1.SAV del SABOT1.SAV

tools\macro11.exe SABOT1.MAC -l SABOT1.lst -o SABOT1.obj -rt11 -se
if not errorlevel 1 (
  echo SABOT1 COMPILED SUCCESSFULLY
) ELSE (
  findstr /RC:"^[ABDEILMNOPQRTUZ] " SABOT1.LST
  echo ======= %errdet% =======
  goto :Failed
)

tools\pclink11.exe /VERBOSITY:1 SABOT1.obj /MAP /EXECUTE:SABOT1.SAV
if errorlevel 1 (
  echo ======= LINK FAILED =======
  goto :Failed
)
for /f "delims=" %%a in ('findstr /B "Undefined globals" SABOT1.MAP') do set "undefg=%%a"
if not "%undefg%"=="" (
  echo ======= LINK FAILED: Undefined globals =======
  goto :Failed
)
echo S1ATB LINKED SUCCESSFULLY

dir /-c SABOT1.SAV|findstr /R /C:"SABOT1.SAV"

echo %ESCchar%[92mSUCCESS%ESCchar%[0m
exit

:Failed
@echo off
echo %ESCchar%[91mFAILED%ESCchar%[0m
exit /b

:FileSize
set fsize=%~z1
exit /b 0
