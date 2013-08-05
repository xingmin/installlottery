Start-Process -FilePath "rundll32.exe" -ArgumentList "shell32.dll,Control_RunDLL desk.cpl,,3"
Start-Sleep -Seconds 2
& python extenddisplay.py