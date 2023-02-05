#!/bin/bash
result=`VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe query user`
if [ "M$result" != "M"  ]; then
    exit 1
else
    exit 0
fi
