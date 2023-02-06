#!/bin/sh
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd" "/c" "e: && \
git clone https://github.com/Microsoft/vcpkg.git"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd" "/c" "e: && \
cd vcpkg && \
bootstrap-vcpkg.bat"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd" "/c" "e: && \
cd vcpkg && \
vcpkg integrate install"