#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
"$SCRIPT_DIR/vm-islogged.sh" > /dev/null
if [ "M$?" == "M1" ]; then
    echo "User still logged"
    exit -1
fi

VBoxManage controlvm "$VM_DEV_MACHINE" keyboardputstring " "
sleep 3;
VBoxManage controlvm "$VM_DEV_MACHINE" keyboardputstring "$VM_DEV_PASS"
VBoxManage controlvm "$VM_DEV_MACHINE" keyboardputscancode 1c 9c 
# wait for

IS_LOGGED=0
for i in {1..10}; do
    "$SCRIPT_DIR/vm-islogged.sh" > /dev/null
    if [ "M$?" == "M1" ]; then
        IS_LOGGED=1
        break
    fi
    sleep 1
done

if [ $IS_LOGGED == 0 ]; then 
    # maybe loggon error 
    VBoxManage controlvm "$VM_DEV_MACHINE" keyboardputscancode 1c 9c 
    sleep 3;
    VBoxManage controlvm "$VM_DEV_MACHINE" keyboardputstring "$VM_DEV_PASS"
    VBoxManage controlvm "$VM_DEV_MACHINE" keyboardputscancode 1c 9c 
    for i in {1..10}; do
        "$SCRIPT_DIR/vm-islogged.sh" > /dev/null
        if [ "M$?" == "M1" ]; then
            IS_LOGGED=1
            break
        fi
        sleep 1
    done
fi

if [ $IS_LOGGED == 0 ]; then 
    echo "Could not log"
    exit -1
else
    echo "Logged"
    exit 0
fi

#1d 38 53 d3 b8 9d