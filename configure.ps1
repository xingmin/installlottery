Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

. .\functions.ps1

#����NTP����
w32tm.exe /config /update /manualpeerlist:18.1.12.3 /syncfromflags:manual
#net stop w32time /y 
#net start w32time
Stop-Service -Name "w32time" -Force
Start-Service -Name "w32time"


#���õ�Դ����
Write-Host -NoNewline "���õ�Դ����Ϊ[һֱ����]:"
$powerstyle = "һֱ����"
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

#��������
Write-Host "������Ļ��������(ϵͳ��������Ч):OK"
Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\Desktop" -Name "ScreenSaveActive" -Value 0


#������չ���ڶ�����Ļ����������Ļ�ֱ���Ϊ1024*768
$major=get-osversionmajor;
if ($major -ge 6){
	$monitors= Get-WmiObject -Namespace root\wmi -class WmiMonitorID
}else{
	$monitors = Get-WmiObject -Class Win32_PnPEntity | Where-Object{$_.DeviceId -match "^DISPLAY"}
}
if (($monitors.GetType() -eq [Object[]]) -and ($monitors.count -ge 2)){
	$msg = "��⵽��Ļ����:"  -f $monitors.count;
	Write-Host $msg
	Write-Host "������ʾ��Ϊ:��չģʽ."
	if ($major -ge 6){
		Set-Display -Mode extend
	}else{
		& .\extenddisplay.ps1
	}
	Set-ScreenResolution -Width 1024 -Height 768 
}else{
		Write-Host "��⵽��Ļ����:1,��ִ����չ�������";
}		


Pop-Location
return 0
