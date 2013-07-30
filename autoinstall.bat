ECHO OFF
PowerShell -Command "& {echo 'powershell installed'}"
IF ERRORLEVEL 0 goto ps
IF NOT ERRORLEVEL 0 goto installps

:installps
ECHO "installing PowerShell"
start /wait .\WindowsXP-KB968930-x86-CHS.exe

:ps
powershell -command "& {.\install.ps1}"