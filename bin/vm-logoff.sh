#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

result=$(VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe query user)
if [ "M$result" != "M"  ]; then
    result=$(tail -n +2 <<< $result)
    read -r user console session other <<< $result
    echo Closing session $session for user $user
    VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe logoff $session

    IS_LOGGED=1
    for i in {1..10}; do
        "$SCRIPT_DIR/vm-islogged.sh" > /dev/null
        if [ "M$?" == "M0" ]; then
            IS_LOGGED=0
            break
        fi
        sleep 1
    done

    if [ $IS_LOGGED == 0 ]; then 
        echo "Logged out"
        exit 0
    else
        echo "Could not logout"
        exit 1
    fi
fi
