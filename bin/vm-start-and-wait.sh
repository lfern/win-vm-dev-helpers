#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

set -e

mkdir -p ./init-share
rm -f ./init-share/logged.txt
folder=`realpath ./init-share`
file="$folder/logged.txt"

#VBoxManage sharedfolder add "$VM_DEV_MACHINE" --name "init-share" --hostpath "$folder" --automount --auto-mount-point "z:\\"

#VBoxManage startvm "$VM_DEV_MACHINE" --type headless

while [ 1 == 1 ]; do
    echo "Try to execute"
    # WINDOWS KEY + R
    VBoxManage controlvm "$VM_DEV_MACHINE" keyboardputscancode E0 5B 13 E0 DB 93
    sleep 5
    # write command
    VBoxManage controlvm $VM_DEV_MACHINE keyboardputstring "cmd.exe /c echo logged > z:\\logged.txt"
    sleep 1
    VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode 1c 9c
    sleep 5
    echo $file
    if [ -f "$file" ]; then
        break;
    fi

    echo "Sleep 20 seconds"
    sleep 20
done
echo "Ready ..."
