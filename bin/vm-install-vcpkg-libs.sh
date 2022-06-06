#!/bin/sh
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd" "/c" "e: && \
cd vcpkg && \
vcpkg install boost:x86-windows boost:x64-windows curl:x86-windows curl:x64-windows cpprestsdk cpprestsdk:x64-windows boost-uuid boost-uuid:x64-windows libqrencode libqrencode:x64-windows tgbot-cpp:x86-windows tgbot-cpp:x64-windows winreg winreg:x64-windows"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd" "/c" "e: && \
cd vcpkg && \
vcpkg install boost:x86-windows-static boost:x64-windows-static curl:x86-windows-static curl:x64-windows-static cpprestsdk:x86-windows-static cpprestsdk:x64-windows-static boost-uuid:x86-windows-static boost-uuid:x64-windows-static libqrencode:x86-windows-static libqrencode:x64-windows-static tgbot-cpp:x86-windows-static tgbot-cpp:x64-windows-static  winreg:x86-windows-static winreg:x64-windows-static"
