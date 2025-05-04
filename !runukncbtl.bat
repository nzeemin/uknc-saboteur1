@echo off
set rt11dsk=C:\bin\rt11dsk

del x-ukncbtl\sabot1.dsk
@if exist "x-ukncbtl\sabot1.dsk" (
  echo.
  echo ####### FAILED to delete old disk image file #######
  exit /b
)
copy x-ukncbtl\sys1002ex.dsk sabot1.dsk
copy S1CORE.SAV SABOT1.SAV
%rt11dsk% a sabot1.dsk SABOT1.SAV
move sabot1.dsk x-ukncbtl\sabot1.dsk

@if not exist "x-ukncbtl\sabot1.dsk" (
  echo ####### ERROR disk image file not found #######
  exit /b
)

start x-ukncbtl\UKNCBTL.exe /boot
