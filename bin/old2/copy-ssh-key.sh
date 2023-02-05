#!/bin/bash
if [ "M$1" == "M" ]; then
    echo "Missing file" && exit -1
fi

if [ "M$2" == "M" ]; then
    echo "Missing dest file" && exit -1
fi

#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" copyfrom -R c:\\Users\\User\\.ssh .

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" "if not exist C:\\Users\\User\\.ssh mkdir C:\\Users\\User\\.ssh\\"
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" copyto "$1" --target-directory "c:\\Users\\User\\.ssh\\$2"