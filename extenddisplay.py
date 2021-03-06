#-*- coding:utf-8 -*-

import win32api
import win32gui
import win32con
import time
import struct  
import os
import array

class extenddisplay:
    #取得主窗口的句柄
    def initWin(self):
        for i in range(1,1000):
            self.winhandle = win32gui.FindWindow(None,"显示 属性");
            if self.winhandle ==0:
                print(i,"Not found the window of [Display Property]")
                continue;
            #print("Window founded.")
            self.winConfig = win32gui.FindWindowEx(self.winhandle, None, None, "设置 ")
            time.sleep(1);
            return True;
        return False;

    #获得combox中的列表文本数组
    def getComboboxItems(self, hwnd):
        result = []
        bufferlength = struct.pack('i', 255)        
        itemCount = win32gui.SendMessage(hwnd, win32con.CB_GETCOUNT, 0, 0)
        for itemIndex in range(itemCount):
            #linetext = bufferlength + b"".ljust(253)
            linetext = array.array('u', str(bufferlength) + str().ljust(253))
            linelength = win32gui.SendMessage(hwnd, win32con.CB_GETLBTEXT, itemIndex, linetext)       
            result.append((linetext[:linelength]).tounicode())
        return result;
    def setCheckButton(self, hwnd):
        win32gui.SendMessage(hwnd, win32con.BM_SETCHECK, None, None);
    def clickbtn(self, hwnd, txt):
        btn = win32gui.FindWindowEx(hwnd, 0, "Button", txt);
        if 0 != btn:
            win32gui.SendMessage(btn, win32con.BM_CLICK, None, -1);
    def identifyDisplay(self):
        self.clickbtn(self.winConfig, "识别(&I)");
        time.sleep(2);

    #扩展屏幕操作
    def extendMonitor(self):
        if not self.initWin():
            print("无法找到窗口句柄.")
            return 0;
        print("开始设置扩展屏幕...");
        self.identifyDisplay();
        lblDisplay = win32gui.FindWindowEx(self.winConfig, 0, "Static", "显示:");
        #找到combox of 显示器列表
        self.cbxDisplay = win32gui.GetWindow(lblDisplay, win32con.GW_HWNDNEXT);
        cbxitems = self.getComboboxItems(self.cbxDisplay);
        #print(cbxitems);
        if len(cbxitems)<=1:
            self.clickbtn(self.winhandle,"取消");
            return 1;
        #两个及以上显示器，需要设置为扩展
        self.btnMainMonitor = win32gui.FindWindowEx(self.winConfig, 0, "Button", "使用该设备作为主监视器");
        self.btnExtend = win32gui.FindWindowEx(self.winConfig, 0, "Button", "将 Windows 桌面扩展到该监视器上");

        for i in range(len(cbxitems)):
            win32gui.SendMessage(self.cbxDisplay, win32con.CB_SETCURSEL, i,0);
            time.sleep(1);
            if i<=0:
                self.setCheckButton(self.btnMainMonitor);
            else:
                setCheckButton(self.btnExtend);
        self.clickbtn(self.winhandle,"应用(&A)");
        time.sleep(1);
        self.clickbtn(self.winhandle,"确定");

        return len(cbxitems);
if __name__ == "__main__":
    #os.execl("cmd.exe rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,3");
    #os.popen("cmd.exe rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,3");
    ed = extenddisplay();
    monitors = ed.extendMonitor();
    print("显示器数目:", monitors);
    print("显示设置完毕.")    