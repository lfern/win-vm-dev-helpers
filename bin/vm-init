#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# shellcheck source=./vm-lib.sh
. "$SCRIPT_DIR/vm-lib.sh"

track_last_command

set -e

# create temp folder
mkdir -p ./init-share
rm -f ./init-share/logged.txt
folder=$(realpath ./init-share)
localfile="$folder/logged.txt"
drive="z:\\"
file="${drive}logged.txt"
# add share to temp folder
vm_add_share "$folder" "$drive"
# start headless
vm_start_headless
# wait to windows to be ready creating this file
vm_wait_windows_ready "$file" "$localfile"
echo "Ready ..."
rm -f "$localfile"

set +e

while : ; do 
    echo "Executing commands..."
    vm_execute_elevated_command "cmd.exe"
    vm_execute_in_cmd "net user administrator /active:yes"
    vm_execute_in_cmd "net user administrator \"$VM_DEV_ADMINPASS\""
    vm_execute_in_cmd "net user User \"$VM_DEV_PASS\""
    vm_execute_in_cmd "reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f"
    vm_execute_in_cmd "echo logged > $file"
    vm_execute_in_cmd "shutdown /s /t 0 /f"
    sleep 10 
    result=$(vm_isrunning)
    if [ "M$result" == "M0" ]; then
        break
    fi

    if [ -f "$localfile" ]; then
        break;
    fi
done

set -e

while : ; do
    result=$(vm_isrunning)
    if [ "M$result" == "M0" ]; then
        break
    fi
    echo "Still running..."
    sleep 5
done

sleep 5
