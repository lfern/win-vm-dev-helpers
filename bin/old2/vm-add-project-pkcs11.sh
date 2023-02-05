#!/bin/sh

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "c:\MSYS2\usr\bin\env.exe" -- "c:\MSYS2\usr\bin\env.exe" MSYSTEM=MINGW64 /usr/bin/bash -lc "cd /e && \
git clone git@github.com:/lfern/pkcs11-proxy.git && \
cd pkcs11-proxy && \
mkdir build && \
cd build && \
cmake -G \"MSYS Makefiles\" .. -DCMAKE_BUILD_TYPE=Debug && \
cmake --build ."

