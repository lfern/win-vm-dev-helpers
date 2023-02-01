#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

wait_user_ready4commands() {
    local file="$1"
    local localfile="$2"
    while [ 1 == 1 ]; do
        echo "Check if user ready for commands..."
        execute_command "cmd.exe /c echo logged > $file"
        VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" "echo logged > $file"
        sleep 5
        if [ -f "$localfile" ]; then
            break;
        fi
        echo "Sleep 20 seconds"
        sleep 20
    done

    return 0
}

# create temp folder
mkdir -p ./init-share
rm -f ./init-share/logged.txt
folder=`realpath ./init-share`
localfile="$folder/logged.txt"
drive="z:\\"
file="${drive}logged.txt"

wait_windows_ready "$file" "$localfile"
echo "Ready ..."
rm -f "$localfile"
