Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

. .\functions.ps1

#设置NTP服务
w32tm.exe /config /update /manualpeerlist:18.1.12.3 /syncfromflags:manual
#net stop w32time /y 
#net start w32time
Stop-Service -Name "w32time" -Force
Start-Service -Name "w32time"


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


#设置扩展到第二块屏幕，并设置屏幕分辨率为1024*768
$major=get-osversionmajor;
if ($major -ge 6){
	$monitors= Get-WmiObject -Namespace root\wmi -class WmiMonitorID
}else{
	$monitors = Get-WmiObject -Class Win32_PnPEntity | Where-Object{$_.DeviceId -match "^DISPLAY"}
}
if (($monitors.GetType() -eq [Object[]]) -and ($monitors.count -ge 2)){
	$msg = "检测到屏幕数量:"  -f $monitors.count;
	Write-Host $msg
	Write-Host "设置显示器为:扩展模式."
	if ($major -ge 6){
		Set-Display -Mode extend
	}else{
		& .\extenddisplay.ps1
	}
	Set-ScreenResolution -Width 1024 -Height 768 
}else{
		Write-Host "检测到屏幕数量:1,不执行扩展桌面操作";
}		


Pop-Location
return 0
