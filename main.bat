@echo off
pushd %cd%

@echo off
cd /d %~dp0

@echo off
rem echo "change working directory to %~dp0"

call .\lib\configdevenv\autoinstall.bat
if not exist ".\lib\configdevenv\reboot.txt" goto next1

del ".\lib\configdevenv\reboot.txt"
SCHTASKS /create /tn configbasicdevenv /tr "%~dp0\main.bat" /sc ONSTART
shutdown /r /f /t 0

next1:

start .\deltask.bat

popd
exit
