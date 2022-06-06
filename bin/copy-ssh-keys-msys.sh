#!/bin/bash
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "c:\MSYS2\usr\bin\env.exe" -- "c:\MSYS2\usr\bin\env.exe" MSYSTEM=MSYS /usr/bin/bash -lc "cp /c/Users/User/.ssh/* /home/User/.ssh/ && \
find /home/User/.ssh -name \"id_rsa*\" -not -name \"*.pub\" -exec chmod 400 {} \; && \
chmod 600 /home/User/.ssh/config"
