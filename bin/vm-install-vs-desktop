#!/bin/bash
#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" start /wait '"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" modify --add Microsoft.VisualStudio.Workload.NativeDesktop --installPath "C:\Program Files\Microsoft Visual Studio\2022\Community" --quiet --force --norestart'

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe Start-Process -Wait -FilePath '"C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe"' -ArgumentList '"modify --quiet --norestart --add Microsoft.VisualStudio.Workload.NativeDesktop --installpath ""C:\Program Files\Microsoft Visual Studio\2022\Community"""'

