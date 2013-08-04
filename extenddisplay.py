#-*- coding:utf-8 -*-

import win32api
import win32gui
import win32con
import time
import struct  


class extenddisplay:
    def __init__(self):
        #取得主窗口的句柄
    def initWin(self):
        for i in range(1,1000):
            self.winhandle = win32gui.FindWindow(None,"显示 属性");
            if self.winhandle ==0:
                print("Not found the window of [Display Property]")
                continue;
            print("Window founded.")
            self.winConfig = win32gui.FindWindowEx(self.winhandle, None, None, "设置 ")
            time.sleep(1);            
        if i>1000:
            return False;
        return True;
    #获得combox中的列表文本数组
    def getComboboxItems(self, hwnd):
        result = []
        bufferlength = struct.pack('i', 255)
        itemCount = win32gui.SendMessage(hwnd, win32con.CB_GETCOUNT, 0, 0)
        for itemIndex in range(itemCount):
            linetext = bufferlength + "".ljust(253)
            linelength = win32gui.SendMessage(hwnd, win32con.CB_GETLBTEXT, itemIndex, linetext)
            result.append(linetext[:linelength])
        return result
    def setCheckButton(self, hwnd):
        win32gui.SendMessage(hwnd, win32con.BM_SETCHECK, None, None);
    #扩展屏幕操作
    def extendMonitor(self):
        if not self.initWin():
            return 0;
        lblDisplay = win32gui.FindWindowEx(self.winConfig, 0, "Static", "显示:");
        #找到combox of 显示器列表
        self.cbxDisplay = win32api.GetWindow(lblDisplay, win32con.GW_HWNDNEXT);
        cbxitems = self.getComboboxItems(cbxDisplay);
        if len(cbxitems)<=1:
            self.clickbtn("Button", "取消");
            return 1;
        #两个及以上显示器，需要设置为扩展
        self.btnMainMonitor = win32gui.FindWindowEx(self.winConfig, 0, "Button", "使用该设备作为主监视器");
        self.btnExtend = win32gui.FindWindowEx(self.winConfig, 0, "Button", "将 Windows 桌面扩展到该监视器上");

        for i in range(len(cbxitems)):
            win32gui.SendMessage(self.cbxDisplay, win32con.CB_SETCURSEL, i,0);
            if i<=0:
                self.setCheckButton(self.btnMainMonitor);
            else:
                setCheckButton(self.btnExtend);
        self.clickbtn("Button", "应用(&A)");
        self.clickbtn("Button", "确定");
        return len(cbxitems);
if __name__ == "__main__":
    ed = extenddisplay();
    monitors = ed.extendMonitor();
    print("显示器数目:", monitors);