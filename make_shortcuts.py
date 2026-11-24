# -*- coding: utf-8 -*-
import os
import comtypes.client as cc

sh = cc.CreateObject("WScript.Shell", dynamic=True)
startup = os.path.join(os.environ["APPDATA"], r"Microsoft\Windows\Start Menu\Programs\Startup")
desktop = sh.SpecialFolders("Desktop")

targets = [
    (os.path.join(startup, "JianyingDraftGuard.lnk"), "Jianying draft auto-backup (runs at logon)"),
    (os.path.join(desktop, "剪映草稿保险箱.lnk"), "Jianying draft auto-backup - double click to start"),
]

for path, desc in targets:
    lnk = sh.CreateShortcut(path)
    lnk.TargetPath = r"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"
    lnk.Arguments = r'-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File "D:\JianyingDraftBackup\loop.ps1"'
    lnk.WorkingDirectory = r"D:\JianyingDraftBackup"
    lnk.IconLocation = r"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe,0"
    lnk.Description = desc
    lnk.Save()
    print("created:", path)
