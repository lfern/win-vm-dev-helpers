#!/bin/sh

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" choco install msys2 -y 
 MYTMPFILE="$(mktemp)"
 trap 'rm -f -- "$MYTMPFILE"' EXIT
 
 wget -O "$MYTMPFILE" https://github.com/msys2/msys2-installer/releases/download/2022-06-03/msys2-x86_64-20220603.exe
 
 VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" copyto "$MYTMPFILE" --target-directory c:\\Users\\User\\msys2-x86_64.exe
 
 VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" "C:\\Users\\User\\msys2-x86_64.exe install --root C:\MSYS2 --confirm-command"
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "c:\MSYS2\usr\bin\env.exe" -- "c:\MSYS2\usr\bin\env.exe" MSYSTEM=MSYS /usr/bin/bash -lc "pacman -Syu --noconfirm"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "c:\MSYS2\usr\bin\env.exe" -- "c:\MSYS2\usr\bin\env.exe" MSYSTEM=MSYS /usr/bin/bash -lc "pacman -Syu --noconfirm"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "c:\MSYS2\usr\bin\env.exe" -- "c:\MSYS2\usr\bin\env.exe" MSYSTEM=MSYS /usr/bin/bash -lc "pacman -S --noconfirm --needed base-devel mingw-w64-x86_64-toolchain"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "c:\MSYS2\usr\bin\env.exe" -- "c:\MSYS2\usr\bin\env.exe" MSYSTEM=MSYS /usr/bin/bash -lc "pacman -S --noconfirm mingw-w64-x86_64-cmake mingw-w64-x86_64-ninja git vi"



