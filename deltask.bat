@ping -n 10 127.1>nul
@rem schtasks /delete /tn configbasicdevenv /f
@reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v basicdevenv
if errorlevel 0 goto 0
if errorlevel 1 goto EOF
:0
@reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v basicdevenv /f
:EOF
@echo "Finished!" 
exit /b 0


