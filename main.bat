@echo off
pushd %cd%

@echo off
cd /d %~dp0

@echo off
rem echo "change working directory to %~dp0"

call .\lib\configdevenv\autoinstall.bat
if not exist ".\lib\configdevenv\reboot.txt" goto next1

del ".\lib\configdevenv\reboot.txt"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v basicdevenv /t reg_sz /d "%~dp0main.bat" /f
shutdown /r /f /t 0
exit

:next1
powershell -command "& {.\configure.ps1}"
call .\deltask.bat
popd
exit
