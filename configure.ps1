. .\functions.ps1
#设置电源管理
Write-Host -NoNewline "设置电源管理为[一直开着]:"
$powerstyle = "一直开着"
$m0 = powercfg.exe -List | select-string -Pattern  "$powerstyle"
if ($m0 -ne $null){

	$m = powercfg.exe -List | select-string -Pattern  "^.+GUID:\s*([0-9 a-f]{8}-([0-9 a-f]{4}-){3}[0-9 a-f]{12})\s*\($powerstyle\).*$"
	if ($m -ne $null){

		$uid = $x.matches[0].groups[1]
		powercfg -SETACTIVE $uid
		powercfg -change -disk-timeout-ac 0 
		powercfg -change -disk-timeout-dc 0
		powercfg -change -monitor-timeout-ac 0 
		powercfg -change -monitor-timeout-dc 0 
		powercfg -change -standby-timeout-ac 0 
		powercfg -change -standby-timeout-dc 0 
		powercfg -change -hibernate-timeout-ac 0 
		powercfg -change -hibernate-timeout-dc 0
	}
	else{
		powercfg -SETACTIVE "$powerstyle"
		powercfg /change "$powerstyle"  /disk-timeout-ac 0
		powercfg /change "$powerstyle"  /disk-timeout-dc 0
		powercfg /change "$powerstyle"  /monitor-timeout-ac 0 
		powercfg /change "$powerstyle"  /monitor-timeout-dc 0 
		powercfg /change "$powerstyle"  /standby-timeout-ac 0 
		powercfg /change "$powerstyle"  /standby-timeout-dc 0 
		powercfg /change "$powerstyle"  /hibernate-timeout-ac 0 
		powercfg /change "$powerstyle"  /hibernate-timeout-dc 0 
	}
	Write-Host  "OK."
}

#禁用屏保
Write-Host "禁用屏幕保护程序(系统重启后生效):OK"
Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\Desktop" -Name "ScreenSaveActive" -Value 0

#安装sp3补丁
$version = Get-WmiObject -Class Win32_OperatingSystem |  select-object -expandproperty version
$ver = $version.split(".")
$v = [int]$ver[0]*10000000+[int]$ver[1]*100000+[int]$ver[2]
[int]$vsp3 = 50102600
if (([int]$ver[0] -eq 5) -and ($v -lt $vsp3)){
	Write-Host "安装SP3:"
	#如果xp版本低于sp3将安装sp3补丁
	Start-Process -Wait -FilePath "./WindowsXP-KB936929-SP3-x86-CHS.exe" 
	Write-Host "OK"
}else{
	Write-Host "操作系统版本高于XPSP3"
}

#设置扩展到第二块屏幕，并设置屏幕分辨率为1024*768
$monitors= Get-WmiObject -Namespace root\wmi -class WmiMonitorID
if ($monitors.count -ge 2){
	Set-Display -Mode extend
	Set-ScreenResolution -Width 1024 -Height 768 
}

#卸载IDS
#检查IDS是否已经安装

$ids=Get-Process -Name "IDS" 
#删除IDS服务
$service  = Get-WmiObject -Class Win32_Service -Filter "Name like 'IDS%'" 
if($service){
	$service.Delete()
}

#卸载IDS



