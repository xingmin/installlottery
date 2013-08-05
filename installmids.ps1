Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd



$idsclient = get-wmiobject -class win32_product | where{$_.Name -match "^IDS.*$"}
if ($idsclient -ne $null){
	Write-Host "Uninstalling the IDS Client."
    Start-Process -FilePath	"msiexec.exe" -ArgumentList "/x $idsclient.IdentifyingNumber /passive /norestart" -Wait
}


Pop-Location