Start-Process -FilePath "rundll32.exe" -ArgumentList "shell32.dll,Control_RunDLL desk.cpl,,3"
Start-Sleep -Seconds 5
& python extenddisplay.py