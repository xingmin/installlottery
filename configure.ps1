Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

. .\functions.ps1
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

#��װsp3����
Write-Host "������ϵͳ�汾:"
$version = Get-WmiObject -Class Win32_OperatingSystem |  select-object -expandproperty version
$ver = $version.split(".")
$major = [int]$ver[0];
$v = [int]$ver[0]*10000000+[int]$ver[1]*100000+[int]$ver[2]
[int]$vsp3 = 50102600
if (([int]$ver[0] -eq 5) -and ($v -lt $vsp3)){
	Write-Host "��װSP3:"
	#���xp�汾����sp3����װsp3����
	if (-not (Test-Path -Path "./sp3/WindowsXP-KB936929-SP3-x86-CHS.exe")){
		$curpwd_linux = (Resolve-Path $curpwd).Path 
		$curpwd_linux = $curpwd_linux -replace '\\','/'
		& C:\xingmin\git\bin\sh.exe --login -c "cd $curpwd_linux;cat ./sp3/WindowsXP-KB936929-SP3-x86-CHS.exea* > ./sp3/WindowsXP-KB936929-SP3-x86-CHS.exe"
	}
	Start-Process -Wait -FilePath "./sp3/WindowsXP-KB936929-SP3-x86-CHS.exe" 
	Write-Host "OK"
}else{
	Write-Host "����ϵͳ�汾����XPSP3"
}

#������չ���ڶ�����Ļ����������Ļ�ֱ���Ϊ1024*768
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
	}
	Set-ScreenResolution -Width 1024 -Height 768 
}else{
		Write-Host "��⵽��Ļ����:1,��ִ����չ�������";
	}		



#ж��IDS
#���IDS�Ƿ��Ѿ���װ

#$ids=Get-Process -Name "IDS" 
##ɾ��IDS����
#$service  = Get-WmiObject -Class Win32_Service -Filter "Name like 'IDS%'" 
#if($service){
#	$service.Delete()
#}

#ж��IDS

Pop-Location

