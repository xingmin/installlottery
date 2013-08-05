Push-Location
$curpwd = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location -Path $curpwd

#载入公共函数
. .\functions.ps1

#设置相关的配置
& .\configure.ps1

#卸载IDS
& .\uninstallids.ps1

#安装相关的工具
& .\installtools.ps1

Pop-Location