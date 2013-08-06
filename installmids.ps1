Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

#检查MIDSClient是否运行
Write-Host -NoNewline "Checking `"MIDSClient`" : "
$midsclient = get-wmiobject -class win32_product | where{$_.Name -match "^MIDSClient"}
if ($midsclient -ne $null){
	Write-Host "Exist.";
}else{
	Write-Host -NoNewline "installing..."
    Start-Process -FilePath	"msiexec.exe" -ArgumentList "/i tools\MIDSClient_V1.0R2F.msi /passive /norestart" -Wait
	Write-Host "Finished"

}

#检查MIDSUpdater是否运行
Write-Host -NoNewline "Checking `"MIDSUpdater`" : "
$midsUpdater = get-wmiobject -class win32_product | where{$_.Name -match "MIDSUpdater"}
if ($midsUpdater -ne $null){
	Write-Host "Exist.";
}else{
	Write-Host -NoNewline "installing..."
    Start-Process -FilePath	"msiexec.exe" -ArgumentList "/i tools\MIDSUpdater_V1.0R2A.msi /passive /norestart" -Wait
	Write-Host "Finished"

}


Pop-Location