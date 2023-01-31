#!/bin/sh
set -e
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

if [ "M$2" == "M" ]; then
    echo "uso: `basename $0` local-path mount-point"
    exit -1
fi

mkdir -p ./init-share
rm ./init-share/logged.txt
realpath=`realpath ./init-shre/logged.txt`

VBoxManage sharedfolder add "$VM_DEV_MACHINE" --name "init-share" --hostpath "$realpath" --automount --auto-mount-point "z:\\"

"$SCRIPT_DIR/vm-start.sh" > /dev/null

while [ 1 == 1 ]; do
    echo "Try to execute"
    # WINDOWS KEY + R
    VBoxManage controlvm "$VM_DEV_MACHINE" keyboardputscancode E0 5B 13 E0 DB 93
    sleep 5
    # write command
    VBoxManage controlvm $VM_DEV_MACHINE keyboardputstring "echo logged > z:\\logged.txt"
    sleep 1
    VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode 1c 9c
    sleep 5
    if [ -f "$realpath" ]; then
        break;
    fi

    echo "Sleep 20 seconds"
    sleep 20
done
echo "Ready ..."