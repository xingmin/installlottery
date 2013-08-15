@echo off
pushd %cd%

@echo off
cd /d %~dp0

#run this program needs the network working. In other words, ping the world are OK. 
ping -n 4 www.baidu.com >nul 2>&1 
if errorlevel 1 goto EOF

@echo off
rem echo "change working directory to %~dp0"

call .\lib\configdevenv\autoinstall.bat
if not exist ".\lib\configdevenv\reboot.txt" goto next1

del ".\lib\configdevenv\reboot.txt"
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v basicdevenv /t reg_sz /d "%~dp0main.bat" /f >nul 2>&1 
shutdown /r /f /t 0
exit /b 0

:next1
powershell -command "& {.\main.ps1}"
call .\deltask.bat
popd
exit /b 0


:EOF
@echo "Can't run this program!!! Ping the world failed, you must check the network!!!"
popd
pause
exit /b 1