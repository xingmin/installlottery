Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

. .\functions.ps1

Write-Host -NoNewline "Checking `"K-Lite_Codec_Pack_770_Mega`":"
$codec=  get-alluninstall | where{$_.DisplayName -match "K-Lite"}
if ($codec -eq $null){
	Write-Host -NoNewline "installing...";
	& .\tools\K-Lite_Codec_Pack_770_Mega\K-Lite_Codec_Pack_770_Mega.exe
	Start-Sleep -Seconds 2
	& python installcodec.py
	wscript.exe .\tools\K-Lite_Codec_Pack_770_Mega\configKLite.vbs
	Write-Host "Finished";
}else{
	Write-Host "exist.";
}
Pop-Location