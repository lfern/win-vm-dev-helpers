#!/bin/sh

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" choco install git -y -params "/GitAndUnixToolsOnPath" --install-args="/DIR=C:\git"

#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" choco uninstall git -y --removedependencies

#downloadlink=`wget -qO- 'https://github.com/git-for-windows/git/releases/latest' | grep -o '/git-for-windows.*Git.*64-bit.exe' | head -1`
#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe -command "Invoke-WebRequest https://github.com$downloadlink -OutFile c:\\Users\\User\\Desktop\\git-install.exe"
