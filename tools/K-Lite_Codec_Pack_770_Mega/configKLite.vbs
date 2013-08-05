On Error Resume Next

Dim RegPath, Type_Name, Key_Name
Dim WshShell

Type_Name = "REG_DWORD" 'data type

Set WshShell = WScript.CreateObject("WScript.shell") 'Create the shell object

'config HKEY_CURRENT_USER

' 1: Disable H264 in ffdshow 
RegPath ="HKEY_CURRENT_USER\Software\GNU\ffdshow\" 
Key_Name = "h264" 'register name
WshShell.RegWrite regpath&Key_Name, 0, Type_Name 

' 2: Enable H264 in LAV 
RegPath ="HKEY_CURRENT_USER\Software\LAV\Video\Formats\" 
Key_Name = "h264" 'register name
WshShell.RegWrite regpath&Key_Name, 1, Type_Name
 
' 3: Disable H263 in ffdshow 
RegPath ="HKEY_CURRENT_USER\Software\GNU\ffdshow\" 
Key_Name = "h263" 'register name
WshShell.RegWrite regpath&Key_Name, 0, Type_Name 

' 4: Enable H263 in LAV 
RegPath ="HKEY_CURRENT_USER\Software\LAV\Video\Formats\" 
Key_Name = "mpeg4" 'register name
WshShell.RegWrite regpath&Key_Name, 1, Type_Name 

' 5: Disable AAC in ffdshow 
RegPath ="HKEY_CURRENT_USER\Software\GNU\ffdshow_audio\" 
Key_Name = "aac" 'register name
WshShell.RegWrite regpath&Key_Name, 0, Type_Name 

' 6: Disable Haali Splitter trayicon
RegPath ="HKEY_CURRENT_USER\Software\Haali\Matroska Splitter\" 
Key_Name = "ui.trayicon" 'register name
WshShell.RegWrite regpath&Key_Name, 0, Type_Name 

'config HKEY_LOCAL_MACHINE

' 7: Disable H264 in ffdshow 
RegPath ="HKEY_LOCAL_MACHINE\Software\GNU\ffdshow\" 
Key_Name = "h264" 'register name
WshShell.RegWrite regpath&Key_Name, 0, Type_Name 

' 8: Enable H264 in LAV 
RegPath ="HKEY_LOCAL_MACHINE\Software\LAV\Video\Formats\" 
Key_Name = "h264" 'register name
WshShell.RegWrite regpath&Key_Name, 1, Type_Name
 
' 9: Disable H263 in ffdshow 
RegPath ="HKEY_LOCAL_MACHINE\Software\GNU\ffdshow\" 
Key_Name = "h263" 'register name
WshShell.RegWrite regpath&Key_Name, 0, Type_Name 

' 10: Enable H263 in LAV 
RegPath ="HKEY_LOCAL_MACHINE\Software\LAV\Video\Formats\" 
Key_Name = "mpeg4" 'register name
WshShell.RegWrite regpath&Key_Name, 1, Type_Name 

' 11: Disable AAC in ffdshow 
RegPath ="HKEY_LOCAL_MACHINE\Software\GNU\ffdshow_audio\" 
Key_Name = "aac" 'register name
WshShell.RegWrite regpath&Key_Name, 0, Type_Name 

' 12: register mmaacd.ax file
WshShell.run "regsvr32 /s C:\PROGRA~1\K-LITE~1\Filters\mmaacd.ax"

'config HKEY_USERS

Dim oWMI, oAs, oA, sSid, strUser
Set oWMI = GetObject("winmgmts:\\.\root\cimv2")
Set objNetwork = CreateObject("Wscript.Network")
strUser=objNetwork.UserName'获取当前的用户名
Set oAs = oWMI.ExecQuery("Select SID From Win32_Account" & _
		  " WHERE SIDType=1 AND Name='" & strUser & "'")
For Each oA In oAs
	sSid= oA.SID
	' 13: Disable H264 in ffdshow 
	RegPath ="HKEY_USERS\" & sSid & "\Software\GNU\ffdshow\" 
	Key_Name = "h264" 'register name
	WshShell.RegWrite regpath&Key_Name, 0, Type_Name 

	' 14: Enable H264 in LAV 
	RegPath ="HKEY_USERS\" & sSid & "\Software\LAV\Video\Formats\" 
	Key_Name = "h264" 'register name
	WshShell.RegWrite regpath&Key_Name, 1, Type_Name
	 
	' 15: Disable H263 in ffdshow 
	RegPath ="HKEY_USERS\" & sSid & "\Software\GNU\ffdshow\" 
	Key_Name = "h263" 'register name
	WshShell.RegWrite regpath&Key_Name, 0, Type_Name 

	' 16: Enable H263 in LAV 
	RegPath ="HKEY_USERS\" & sSid & "\Software\LAV\Video\Formats\" 
	Key_Name = "mpeg4" 'register name
	WshShell.RegWrite regpath&Key_Name, 1, Type_Name 

	' 17: Disable AAC in ffdshow 
	RegPath ="HKEY_USERS\" & sSid & "\Software\GNU\ffdshow_audio\" 
	Key_Name = "aac" 'register name
	WshShell.RegWrite regpath&Key_Name, 0, Type_Name 
		
	' 18: Disable Haali Splitter trayicon
	RegPath ="HKEY_USERS\" & sSid & "\Software\Haali\Matroska Splitter\" 
	Key_Name = "ui.trayicon" 'register name
	WshShell.RegWrite regpath&Key_Name, 0, Type_Name 
Next

' 19: Disable error reporting 
RegPath ="HKEY_LOCAL_MACHINE\Software\Microsoft\PCHealth\ErrorReporting\" 
Key_Name = "DoReport" 'register name
WshShell.RegWrite regpath&Key_Name, 0, Type_Name 

RegPath ="HKEY_LOCAL_MACHINE\Software\Microsoft\PCHealth\ErrorReporting\" 
Key_Name = "ShowUI" 'register name
WshShell.RegWrite regpath&Key_Name, 0, Type_Name 

WScript.Echo "K-Lite 配置成功！" 