#!/bin/sh
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" SETX PATH "%PATH%;C:\Users\User\.cargo\bin"
