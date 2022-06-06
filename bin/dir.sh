#!/bin/bash
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "dir"
