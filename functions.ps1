﻿#This function was copied from http://social.technet.microsoft.com/Forums/scriptcenter/en-US/7539f69d-57c3-4c7c-9e27-3132f7f4e8e2/script-to-detect-and-clone-display-in-vista
function Set-Display
{
    param(
        [Parameter(Position=0)]
        [ValidateSet('external','internal','clone','extend','gui')]
        [string]$Mode='gui'
    )
    
    $path = Join-Path -Path ([environment]::SystemDirectory) -ChildPath DisplaySwitch.exe
    
    if( !(Test-Path -Path $path -PathType Leaf))
    {
        throw "Cannot find DisplaySwitch.exe"
    }
    
    
    if($Mode -eq 'gui')
    {
        & $path
    }
    else
    {
        & $path /$Mode
    }
}

Function Set-ScreenResolution { 
 
<# 
    .Synopsis 
        Sets the Screen Resolution of the primary monitor 
    .Description 
        Uses Pinvoke and ChangeDisplaySettings Win32API to make the change 
    .Example 
        Set-ScreenResolution -Width 1024 -Height 768         
    #> 
param ( 
[Parameter(Mandatory=$true, 
           Position = 0)] 
[int] 
$Width, 
 
[Parameter(Mandatory=$true, 
           Position = 1)] 
[int] 
$Height 
) 
 
$pinvokeCode = @" 
 
using System; 
using System.Runtime.InteropServices; 
 
namespace Resolution 
{ 
 
    [StructLayout(LayoutKind.Sequential)] 
    public struct DEVMODE1 
    { 
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] 
        public string dmDeviceName; 
        public short dmSpecVersion; 
        public short dmDriverVersion; 
        public short dmSize; 
        public short dmDriverExtra; 
        public int dmFields; 
 
        public short dmOrientation; 
        public short dmPaperSize; 
        public short dmPaperLength; 
        public short dmPaperWidth; 
 
        public short dmScale; 
        public short dmCopies; 
        public short dmDefaultSource; 
        public short dmPrintQuality; 
        public short dmColor; 
        public short dmDuplex; 
        public short dmYResolution; 
        public short dmTTOption; 
        public short dmCollate; 
        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] 
        public string dmFormName; 
        public short dmLogPixels; 
        public short dmBitsPerPel; 
        public int dmPelsWidth; 
        public int dmPelsHeight; 
 
        public int dmDisplayFlags; 
        public int dmDisplayFrequency; 
 
        public int dmICMMethod; 
        public int dmICMIntent; 
        public int dmMediaType; 
        public int dmDitherType; 
        public int dmReserved1; 
        public int dmReserved2; 
 
        public int dmPanningWidth; 
        public int dmPanningHeight; 
    }; 
 
 
 
    class User_32 
    { 
        [DllImport("user32.dll")] 
        public static extern int EnumDisplaySettings(string deviceName, int modeNum, ref DEVMODE1 devMode); 
        [DllImport("user32.dll")] 
        public static extern int ChangeDisplaySettings(ref DEVMODE1 devMode, int flags); 
 
        public const int ENUM_CURRENT_SETTINGS = -1; 
        public const int CDS_UPDATEREGISTRY = 0x01; 
        public const int CDS_TEST = 0x02; 
        public const int DISP_CHANGE_SUCCESSFUL = 0; 
        public const int DISP_CHANGE_RESTART = 1; 
        public const int DISP_CHANGE_FAILED = -1; 
    } 
 
 
 
    public class PrmaryScreenResolution 
    { 
        static public string ChangeResolution(int width, int height) 
        { 
 
            DEVMODE1 dm = GetDevMode1(); 
 
            if (0 != User_32.EnumDisplaySettings(null, User_32.ENUM_CURRENT_SETTINGS, ref dm)) 
            { 
 
                dm.dmPelsWidth = width; 
                dm.dmPelsHeight = height; 
 
                int iRet = User_32.ChangeDisplaySettings(ref dm, User_32.CDS_TEST); 
 
                if (iRet == User_32.DISP_CHANGE_FAILED) 
                { 
                    return "Unable To Process Your Request. Sorry For This Inconvenience."; 
                } 
                else 
                { 
                    iRet = User_32.ChangeDisplaySettings(ref dm, User_32.CDS_UPDATEREGISTRY); 
                    switch (iRet) 
                    { 
                        case User_32.DISP_CHANGE_SUCCESSFUL: 
                            { 
                                return "Success"; 
                            } 
                        case User_32.DISP_CHANGE_RESTART: 
                            { 
                                return "You Need To Reboot For The Change To Happen.\n If You Feel Any Problem After Rebooting Your Machine\nThen Try To Change Resolution In Safe Mode."; 
                            } 
                        default: 
                            { 
                                return "Failed To Change The Resolution"; 
                            } 
                    } 
 
                } 
 
 
            } 
            else 
            { 
                return "Failed To Change The Resolution."; 
            } 
        } 
 
        private static DEVMODE1 GetDevMode1() 
        { 
            DEVMODE1 dm = new DEVMODE1(); 
            dm.dmDeviceName = new String(new char[32]); 
            dm.dmFormName = new String(new char[32]); 
            dm.dmSize = (short)Marshal.SizeOf(dm); 
            return dm; 
        } 
    } 
} 
 
"@ 
 
Add-Type $pinvokeCode -ErrorAction SilentlyContinue 
[Resolution.PrmaryScreenResolution]::ChangeResolution($width,$height) 
} 


function get-osversion{
	$version = Get-WmiObject -Class Win32_OperatingSystem |  select-object -expandproperty version
	$ver = $version.split(".")
	return [int[]]$ver;
}
function get-osversionmajor{
	return (get-osversion)[0];
}

#This function are modified from http://gallery.technet.microsoft.com/scriptcenter/e4cdcc2c-185a-43d7-9b44-3de15ba7bf34
function get-alluninstall{
	param ( 
	[Parameter(Position = 0)] 
	[string] 
	$computername)
	if (-not $computername) {
		$computername = $env:COMPUTERNAME;
	}
	$array = @()
	# Branch of the Registry  
	$Branch='LocalMachine'  
	 
	# Main Sub Branch you need to open  
	$SubBranch="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall"  
	 
	$registry=[microsoft.win32.registrykey]::OpenRemoteBaseKey('Localmachine',$computername)  
	$registrykey=$registry.OpenSubKey($Subbranch)  
	$SubKeys=$registrykey.GetSubKeyNames()  
	 
	# Drill through each key from the list and pull out the value of  
	# “DisplayName” – Write to the Host console the name of the computer  
	# with the application beside it 
	 
	Foreach ($key in $subkeys)  
	{  
	    $exactkey=$key  
	    $NewSubKey=$SubBranch+"\\"+$exactkey  
	    $ReadUninstall=$registry.OpenSubKey($NewSubKey)  
		
		$obj = New-Object PSObject

        $obj | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $computername

        $obj | Add-Member -MemberType NoteProperty -Name "DisplayName" -Value $($ReadUninstall.GetValue("DisplayName"))

        $obj | Add-Member -MemberType NoteProperty -Name "DisplayVersion" -Value $($ReadUninstall.GetValue("DisplayVersion"))

        $obj | Add-Member -MemberType NoteProperty -Name "InstallLocation" -Value $($ReadUninstall.GetValue("InstallLocation"))

        $obj | Add-Member -MemberType NoteProperty -Name "Publisher" -Value $($ReadUninstall.GetValue("Publisher"))

        $array += $obj
	 
	}  
	if ($array.count -gt 0){
		return $array;
	}else {
		return $null;
	}
	#$array | Where-Object { $_.DisplayName } | select ComputerName, DisplayName, DisplayVersion, Publisher | ft -auto
}
