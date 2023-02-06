#!/bin/sh
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- cmd.exe /c SETX PATH "%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- cmd.exe /c SETX PATH "%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" "choco -v"

#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" copyto ChocolateyInstallNonAdmin.ps1 --target-directory c:\\Users\\User\\Desktop
#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe Set-ExecutionPolicy Bypass -Scope Process -Force 
#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe c:\\Users\\User\\Desktop\\UpdateVsInstaller2.ps1







