Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

. .\functions.ps1

Write-Host -NoNewline "Checking `"K-Lite_Codec_Pack_770_Mega`" : "
$codec=  get-alluninstall | where{$_.DisplayName -match "K-Lite"}
if ($codec -eq $null){
	Write-Host -NoNewline "installing...";
	Start-Process -FilePath ".\tools\K-Lite_Codec_Pack_770_Mega\K-Lite_Codec_Pack_770_Mega.exe" `
	-ArgumentList '/silent /norestart /LoadInf=".\tools\K-Lite_Codec_Pack_770_Mega\klcp_mega_unattended.ini"' `
	-Wait
	cscript.exe .\tools\K-Lite_Codec_Pack_770_Mega\configKLite.vbs | Out-Null
	Write-Host "Finished";
}else{
	Write-Host "exist.";
}
Pop-Location