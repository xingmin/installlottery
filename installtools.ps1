
Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

. .\functions.ps1

#检查Windows installer是否运行
Write-Host -NoNewline "Checking `"Windows installer`":"
$msisrv = Get-Service -Name "msiserver"
if ($msisrv.Status -ne [System.ServiceProcess.ServiceControllerStatus]::Running){
	Start-Service -Name "msiserver"
	msiexec.exe /UNREGISTER
	msiexec.exe /REGSERVER
	Write-Host "register and running";
}else{
	Write-Host "Running";
}


#Checking windows version & installing sp3
Write-Host -NoNewline "Checking `"Windows OS Version`":"
$version = get-osversion;
$major = $ver[0];
$v = $ver[0]*10000000+$ver[1]*100000+$ver[2]
[int]$vsp3 = 50102600
if (($major -eq 5) -and ($v -lt $vsp3)){
	Write-Host -NoNewline "installing sp3..."
	#如果xp版本低于sp3将安装sp3补丁
	if (-not (Test-Path -Path ".\sp3\WindowsXP-KB936929-SP3-x86-CHS.exe")){
		$curpwd_linux = (Resolve-Path $curpwd).Path 
		$curpwd_linux = $curpwd_linux -replace '\\','/'
		& C:\xingmin\git\bin\sh.exe --login -c "cd $curpwd_linux;cat ./sp3/WindowsXP-KB936929-SP3-x86-CHS.exea* > ./sp3/WindowsXP-KB936929-SP3-x86-CHS.exe"
	}
	Start-Process -Wait -FilePath ".\sp3\WindowsXP-KB936929-SP3-x86-CHS.exe" 
	Write-Host "Finished."
}else{
	Write-Host ">=XPSP3"
}

#检查msxml6是否运行
Write-Host -NoNewline "Checking `"msxml6`":"
if (-not (Test-Path "$Env:SystemRoot\system32\msxml6.dll")){
	Write-Host -NoNewline "installing...";
	Start-Process -FilePath	"msiexec.exe" -ArgumentList "/i tools\msxml6.msi /passive /norestart" -Wait
	Write-Host "Finished";
}else{
	Write-Host "exist.";
}

#Microsoft Visual C++ 2008 Redistributable
Write-Host -NoNewline "Checking `"Microsoft Visual C++ 2008 Redistributable - x86`":"
$vcredist= get-wmiobject -class win32_product | where{$_.Name -match "^Microsoft\s*Visual\s*C\+\+\s*2008\s*Redistributable\s*-\s*x86.*$"}
if ($vcredist -eq $null){
	Write-Host -NoNewline "installing...";
    Start-Process -FilePath	"msiexec.exe" -ArgumentList "/i tools\vcredist_x86\vc_red.msi /passive /norestart" -Wait
	Write-Host "Finished";
}else{
	Write-Host "exist.";
}


Pop-Location