@ping -n 10 127.1>nul
@rem schtasks /delete /tn configbasicdevenv /f
@reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v basicdevenv  >nul 2>&1 
if %ERRORLEVEL% EQU 0 (goto 0) else (goto EOF)
:0
@reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v basicdevenv /f  >nul 2>&1 
:EOF
@echo "Finished!" 
exit /b 0


