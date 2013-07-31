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
	Write-Host -NoNewline "OK."
}
#��������
Write-Host "������Ļ��������(ϵͳ��������Ч):OK"
Set-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Control Panel\Desktop" -Name "ScreenSaveActive" -Value 0

#��װsp3����
$version = Get-WmiObject -Class Win32_OperatingSystem |  select-object -expandproperty version
$ver = $version.split(".")
$v = [int]$ver[0]*10000000+[int]$ver[1]*100000+[int]$ver[2]
[int]$vsp3 = 50102600
if (([int]$ver[0] -eq 5) -and ($v -lt $vsp3)){
	#���xp�汾����sp3����װsp3����
	Write-Host "xxx"
}else{
	Write-Host "����ϵͳ�汾����XPSP3"
}