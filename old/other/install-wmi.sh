#!/bin/sh
USER=$USER
PASS=$PASS
MACHINE=$MACHINE

VBoxManage guestcontrol "$MACHINE" --username "$USER" --password "$PASS" run --exe "cmd.exe" -- "cmd" "/c" "e: && \
git clone https://github.com/lfern/wmi.git"

VBoxManage guestcontrol "$MACHINE" --username "$USER" --password "$PASS" copyto Wmi-CMakeLists.txt --target-directory e:\\wmi\\CMakeLists.txt

VBoxManage guestcontrol "$MACHINE" --username "$USER" --password "$PASS" run --exe "cmd.exe" -- "cmd" "/c" "e: && \
cd wmi && \
mkdir build && \
cd build && \
mkdir x86 && \
mkdir x64 && \
mkdir x86-static && \
mkdir x64-static && \
cd x86 && \
cmake -A Win32 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release && \
cd .. && \
cd x64 && \
cmake -A x64 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release && \
cd .. && \
cd x86-static && \
cmake -DEC_STATIC_LINK=1 -A Win32 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release && \
cd .. && \
cd x64-static && \
cmake -DEC_STATIC_LINK=1 -A x64 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release"