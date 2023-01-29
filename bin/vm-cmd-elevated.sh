#!/bin/sh
VBoxManage controlvm "$VM_DEV_MACHINE" keyboardputscancode E0 5B 13 E0 DB 93
sleep 5
VBoxManage controlvm $VM_DEV_MACHINE keyboardputstring "cmd.exe"
sleep 1
VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode 1D 2a 1c 9c
sleep 1
VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode aa 9d
sleep 2
VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode 0f 8f 0f 8f 39 b9
sleep 2

VBoxManage controlvm $VM_DEV_MACHINE keyboardputstring "net user administrator /active:yes"
VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode 1c 9c

sleep 1

VBoxManage controlvm $VM_DEV_MACHINE keyboardputstring "net user administrator Demo"
VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode 1c 9c

sleep 1

VBoxManage controlvm $VM_DEV_MACHINE keyboardputstring "net user User Demo"
VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode 1c 9c

sleep 1

VBoxManage controlvm $VM_DEV_MACHINE keyboardputstring "reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f"
VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode 1c 9c

sleep 1

VBoxManage controlvm $VM_DEV_MACHINE keyboardputstring "shutdown /r /t 0 /f"
VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode 1c 9c

