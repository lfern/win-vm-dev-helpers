#!/bin/sh
USER=$USER
PASS=$PASS
MACHINE=$MACHINE

VBoxManage guestcontrol "$MACHINE" --username "$USER" --password "$PASS" run --exe "cmd.exe" -- "cmd" "/c" "e: && \
git clone https://github.com/reo7sp/tgbot-cpp.git && \
cd tgbot-cpp && \
mkdir build && \
cd build && \
mkdir x86 && \
mkdir x64 && \
cd x86 && \
cmake -DCMAKE_TOOLCHAIN_FILE=..\..\..\vcpkg\scripts\buildsystems\vcpkg.cmake -A Win32 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release && \
cd .. && \
cd x64 && \
cmake -DCMAKE_TOOLCHAIN_FILE=..\..\..\vcpkg\scripts\buildsystems\vcpkg.cmake -A x64 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release"
