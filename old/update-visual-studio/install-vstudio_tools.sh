#!/bin/sh
USER=$USER
PASS=$PASS
MACHINE=$MACHINE

VBoxManage guestcontrol "$MACHINE" --username "$ADMINUSER" --password "$ADMINPASS" copyto UpdateVsInstaller2.ps1 --target-directory c:\\Users\\User\\Desktop
VBoxManage guestcontrol "$MACHINE" --username "$ADMINUSER" --password "$ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe Set-ExecutionPolicy Unrestricted
VBoxManage guestcontrol "$MACHINE" --username "$ADMINUSER" --password "$ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe c:\\Users\\User\\Desktop\\UpdateVsInstaller2.ps1

VBoxManage guestcontrol "$MACHINE" --username "$ADMINUSER" --password "$ADMINPASS" run --exe "c:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" -- "c:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" update --norestart --quiet --force --installPath "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community"
VBoxManage guestcontrol "$MACHINE" --username "$ADMINUSER" --password "$ADMINPASS" run --exe "c:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe" -- modify --includeRecommended --norestart --quiet --installPath "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community" --add Microsoft.VisualStudio.Workload.VCTools

#VBoxManage guestcontrol "$MACHINE" --username "$ADMINUSER" --password "$ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" choco install visualstudio2019buildtools -y 

#VBoxManage guestcontrol "$MACHINE" --username "$ADMINUSER" --password "$ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" choco install visualstudio2019buildtools --package-parameters "--allWorkloads --includeRecommended --includeOptional --passive --locale en-US" -y
#VBoxManage guestcontrol "$MACHINE" --username "$ADMINUSER" --password "$ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" choco uninstall visualstudio2019buildtools -y
