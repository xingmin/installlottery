#-*- coding:utf-8 -*-

import win32api
import win32gui
import win32con
import time


class autoinstall:
    #取得主窗口的句柄
    def mainwin(self, wndclass, title):
        self.winhandle = win32gui.FindWindow(wndclass,title);
        if self.winhandle ==0:
            print("Failed to find the window:"+title);
            return False;
        win32gui.SetForegroundWindow(self.winhandle)            
        time.sleep(1)
        return True;
    def clickbtninwnd(self, wndclass, wndtitle, btnclass, btntitle):
        print ("send click to" + wndtitle+":"+ btntitle);
        for i in range(1,1000):
            print("Trying send click message [{0}] times.".format(i));
            time.sleep(0.5);
            try:
                if not self.mainwin(wndclass, wndtitle):
                    continue;
                hbtn = win32gui.FindWindowEx(self.winhandle, 0, btnclass, btntitle);
                if hbtn == 0:
                    continue;
                style = win32gui.GetWindowLong(hbtn, win32con.GWL_STYLE)
                if style & win32con.WS_DISABLED == win32con.WS_DISABLED:
                    continue;
                time.sleep(0.5);
                win32api.SendMessage(hbtn, win32con.BM_CLICK, 0, -1)
                return True;
            except:
                continue;
        print("Send click message to "+btntitle+" failed!")
        return False;
    #下一步        
    def next(self):
        print("click button of next!");
        if not self.clickbtninwnd("MsiDialogCloseClass", "Oracle VM VirtualBox 4.2.10 Setup", "Button", "&Next >"):
            exit(-1);

    #点击浏览,去修改路径      
    def browse(self):
        print("click button of browse!");
        if not self.clickbtninwnd("MsiDialogCloseClass", "Oracle VM VirtualBox 4.2.10 Setup", "Button", "Br&owse"):
            exit(-1);
    #修改程序的安装路径
    def dochangepath(self, hwnd, hrtxt):
        win32api.SendMessage(hrtxt, win32con.WM_SETTEXT, None, "D:\\VirtualBox\\");
        hokbtn = win32gui.FindWindowEx(hwnd, 0,"Button", "O&K");
        time.sleep(0.5);
        win32api.SendMessage(hokbtn, win32con.BM_CLICK, 0, -1);
    def changpathcb(self, hwnd, data):
        wintitle =  win32gui.GetWindowText(hwnd)
        if wintitle  == "Oracle VM VirtualBox 4.2.10 Setup" :
            hrtxt= win32gui.FindWindowEx(hwnd, 0, "RichEdit20W", None)
            if hrtxt != 0:
                self.hpathwnd = hwnd;
                self.dochangepath(hwnd, hrtxt);
                return False;
    def changepathwin(self):
        print("changing the install path.");
        i=0;
        self.hpathwnd = None;
        while not self.hpathwnd and i <100:
            i+=1;
            time.sleep(0.5);
            try:
                win32gui.EnumWindows(self.changpathcb, 0);
            except:
                continue;

    #选择是或否    
    def yesorno(self, yn):
        if yn == "yes":
            yn= "&Yes"
        else:
            yn= "&No"
        #注意第二个参数是有空格的
        print("select Yes!");
        if not self.clickbtninwnd("MsiDialogCloseClass", "Oracle VM VirtualBox 4.2.10 ", "Button", yn):
            exit(-1);
     #install        
    def install(self):
        print("click button of install!");
        if not self.clickbtninwnd("MsiDialogCloseClass", "Oracle VM VirtualBox 4.2.10 Setup", "Button", "&Install"):
            exit(-1);
#Windows 安全
##    def moveCursor(self, client_pos):
##        screen_pos = win32gui.ClientToScreen(self.gobangHandle, client_pos)
##        win32api.SetCursorPos(screen_pos)

##    def click(self, handle, pos):
##        print("in click");
##       
##        client_pos = win32gui.ScreenToClient(handle, pos)
##        print(client_pos)
##        tmp = win32api.MAKELONG(client_pos[0], client_pos[1])
##        #tmp = win32api.MAKELONG(pos[0], pos[1])
##        win32gui.SendMessage(handle, win32con.WM_ACTIVATE, win32con.WA_ACTIVE, 0)
##        win32api.SendMessage(handle, win32con.WM_LBUTTONDOWN, win32con.MK_LBUTTON, tmp) 
##        win32api.SendMessage(handle, win32con.WM_LBUTTONUP, win32con.MK_LBUTTON, tmp)

##    def authcb(self, hwnd, data):
##        txt =  win32gui.GetWindowText(hwnd)
##        print(txt);
##        if txt  == "安装(&I)" :
##            rect = win32gui.GetWindowRect(hwnd);
##            print(rect);
##            print(win32api.GetCursorPos());
##            #win32api.SetCursorPos([rect[0]+2, rect[1]+2]);
##            win32api.SetCursorPos([rect[0],rect[1]]);
##            print("hi")
##            time.sleep(0.1);
##            print(win32api.GetCursorPos());
##            win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN
##                                 ,0
##                                 ,0
##                                 ,0
##                                 ,0)
##            time.sleep(0.1);
##            win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP
##                                 ,0
##                                 ,0
##                                 ,0
##                                 ,0)
##            #self.click(hwnd,(rect.left,rect.top));
##            #win32api.SendMessage(hwnd, win32con.BM_CLICK, 0, -1);
##    def doauth(self,hbtn):
##        win32api.SendMessage(hbtn, win32con.BM_CLICK, 0, -1);
##        rect = win32gui.GetWindowRect(hbtn);
##        pos= [rect[0], rect[1]];
##        win32gui.SetForegroundWindow(self.winhandle)
##        win32api.SetCursorPos([1178,556]);
##        win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN
##                             ,0
##                             ,0
##                             ,0
##                             ,0)
##        time.sleep(0.2);
##        win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP
##                             ,0
##                             ,0
##                             ,0
##                             ,0)
##
##    def auth(self):
##        win32api.SetCursorPos([1178,556]);
##        self.winhandle = win32gui.FindWindow(None,"Windows 安全");
##        #win32gui.SetForegroundWindow(self.winhandle) 
##        #self.mainwin(None, "Windows 安全")
##        win32api.SetCursorPos([1178,556]);
##        hdui = win32gui.FindWindowEx(self.winhandle, 0, "DirectUIHWND", None)
##        hmid = win32gui.GetWindow(hdui, win32con.GW_CHILD);
##        hmid = win32gui.GetWindow(hmid, win32con.GW_HWNDLAST);
##        while 1==1:
##            hbtn = win32gui.FindWindowEx(hmid, 0, "Button", "安装(&I)")                
##            if hbtn !=0 :
##                win32api.SendMessage(hbtn, win32con.BM_CLICK, 0, -1);
##                rect = win32gui.GetWindowRect(hbtn);
##                pos= [rect[0], rect[1]];
##                win32gui.SetForegroundWindow(self.winhandle)
##                win32api.SetCursorPos([1178,556]);
##                win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN
##                                     ,0
##                                     ,0
##                                     ,0
##                                     ,0)
##                time.sleep(0.2);
##                win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP
##                                     ,0
##                                     ,0
##                                     ,0
##                                     ,0)
##                exit(0);
##            hmid = win32gui.GetWindow(hmid, win32con.GW_HWNDPREV);
##        if i>=4:
##            print("failed");
##        #win32api.SetCursorPos(100, 600);
##        #win32gui.EnumChildWindows(self.winhandle, self.authcb, 0)
    def finish(self):
        print("click button of finish! Finish the install process!");
        if not self.clickbtninwnd("MsiDialogCloseClass", "Oracle VM VirtualBox 4.2.10 Setup", "Button", "&Finish"):
            exit(-1);
    def startautoinstall(self):
        self.next();
        self.browse();
        self.changepathwin();
        self.next();
        self.next();
        self.yesorno("yes");
        self.install();
        self.finish();
        
ai = autoinstall();
ai.startautoinstall();
print("Finished.");