#!/bin/sh
wget https://win.rustup.rs/ -O rustup-init.exe
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" copyto "rustup-init.exe" --target-directory c:\\Users\\User\\Desktop\\rustup-init.exe
rm rustup-init.exe
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" c:\\Users\\User\\Desktop\\rustup-init.exe -y

#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" choco uninstall rustup.install rust -y

