Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

$idsclient = get-wmiobject -class win32_product | where{$_.Name -match "^IDS.*$"}
if ($idsclient -ne $null){
	Write-Host "Uninstalling the IDS Client."
    Start-Process -FilePath	"msiexec.exe" -ArgumentList "/x $idsclient.IdentifyingNumber /passive /norestart" -Wait
}

$idsagent = get-wmiobject -class win32_product | where{$_.Name -match "^Agent.*$"}
if ($idsagent -ne $null){
	Write-Host "Uninstalling the IDS Agent."
	Start-Process -FilePath	"msiexec.exe" -ArgumentList "/x $idsagent.IdentifyingNumber /passive /norestart" -Wait
}

Pop-Location