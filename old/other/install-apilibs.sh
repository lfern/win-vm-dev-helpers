#!/bin/sh
USER=$USER
PASS=$PASS
MACHINE=$MACHINE

#if your CMake flags already contain /MD, you can ensure that the above commands are executed after the point at which /MD is inserted (the later addition of /MT overrides the conflicting existing option), or you can set the flags from scratch:
#set(CMAKE_CXX_FLAGS_RELEASE "/MT")
#set(CMAKE_CXX_FLAGS_DEBUG "/MTd")
#-DEC_STATIC_LINK=1


VBoxManage guestcontrol "$MACHINE" --username "$USER" --password "$PASS" run --exe "cmd.exe" -- "cmd" "/c" "e: && \
mkdir apilibs"

VBoxManage guestcontrol "$MACHINE" --username "$USER" --password "$PASS" run --exe "cmd.exe" -- "cmd" "/c" "e: && \
cd apilibs && \
git clone git@bitbucket.org:lfern70/ec-privateapi-cpprest-client.git && \
cd ec-privateapi-cpprest-client && \
mkdir build && \
cd build && \
mkdir x86 && \
mkdir x64 && \
mkdir x86-static && \
mkdir x64-static && \
cd x86 && \
cmake -DCMAKE_TOOLCHAIN_FILE=..\..\..\vcpkg\scripts\buildsystems\vcpkg.cmake -DCPPREST_ROOT=..\..\..\vcpkg\installed\x86-windows -A Win32 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release && \
cd .. && \
cd x64 && \
cmake -DCMAKE_TOOLCHAIN_FILE=..\..\..\vcpkg\scripts\buildsystems\vcpkg.cmake -DCPPREST_ROOT=..\..\..\vcpkg\installed\x64-windows -A x64 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release && \
cd .. && \
cd x86-static && \
cmake -DCMAKE_TOOLCHAIN_FILE=..\..\..\vcpkg\scripts\buildsystems\vcpkg.cmake -DEC_STATIC_LINK=1 -DVCPKG_TARGET_TRIPLET=x86-windows-static -DCPPREST_ROOT=..\..\..\vcpkg\installed\x86-windows-static -A Win32 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release && \
cd .. && \
cd x64-static && \
cmake -DCMAKE_TOOLCHAIN_FILE=..\..\..\vcpkg\scripts\buildsystems\vcpkg.cmake -DEC_STATIC_LINK=1 -DVCPKG_TARGET_TRIPLET=x64-windows-static -DCPPREST_ROOT=..\..\..\vcpkg\installed\x64-windows-static -A x64 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release"



VBoxManage guestcontrol "$MACHINE" --username "$USER" --password "$PASS" run --exe "cmd.exe" -- "cmd" "/c" "e: && \
cd apilibs && \
git clone git@bitbucket.org:lfern70/ec-publicapi-cpprest-client.git && \
cd ec-publicapi-cpprest-client && \
mkdir build && \
cd build && \
mkdir x86 && \
mkdir x64 && \
mkdir x86-static && \
mkdir x64-static && \
cd x86 && \
cmake -DCMAKE_TOOLCHAIN_FILE=..\..\..\vcpkg\scripts\buildsystems\vcpkg.cmake -DCPPREST_ROOT=..\..\..\vcpkg\installed\x86-windows -A Win32 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release && \
cd .. && \
cd x64 && \
cmake -DCMAKE_TOOLCHAIN_FILE=..\..\..\vcpkg\scripts\buildsystems\vcpkg.cmake -DCPPREST_ROOT=..\..\..\vcpkg\installed\x64-windows -A x64 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release && \
cd .. && \
cd x86-static && \
cmake -DCMAKE_TOOLCHAIN_FILE=..\..\..\vcpkg\scripts\buildsystems\vcpkg.cmake -DEC_STATIC_LINK=1 -DVCPKG_TARGET_TRIPLET=x86-windows-static -DCPPREST_ROOT=..\..\..\vcpkg\installed\x86-windows-static -A Win32 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release && \
cd .. && \
cd x64-static && \
cmake -DCMAKE_TOOLCHAIN_FILE=..\..\..\vcpkg\scripts\buildsystems\vcpkg.cmake -DEC_STATIC_LINK=1 -DVCPKG_TARGET_TRIPLET=x64-windows-static -DCPPREST_ROOT=..\..\..\vcpkg\installed\x64-windows-static -A x64 ..\.. && \
cmake --build . --config Debug && \
cmake --build . --config Release"
