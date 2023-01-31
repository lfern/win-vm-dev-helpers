#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e
send_win_r() {
    # press WINDOWS KEY(E0 5B), press R(13), release WINDOWS KEY(E0DB), release R(93)
    VBoxManage controlvm "$VM_DEV_MACHINE" keyboardputscancode E0 5B 13 E0 DB 93
    sleep 5 
    return 0
}

execute_command() {
    send_win_r
    # write command
    VBoxManage controlvm $VM_DEV_MACHINE keyboardputstring "$1"
    sleep 2
    # press RETURN(1C=00011100), release RETURN(9C=10011100)
    # release key is press key code bitwise or 0x80 (most significant bit to 1) 
    VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode 1c 9c 
    sleep 5 
    return 0
}

execute_elevated_command() {
    send_win_r
    # write command
    VBoxManage controlvm $VM_DEV_MACHINE keyboardputstring "$1"
    sleep 2
    # press CTRL(1d), press LEFT SHIFT(1a), press return(1c), release return(9c)
    VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode 1d 2a 1c 9c
    sleep 1
    # release LEFT SHIFT(aa), release CTRL(9d)
    VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode aa 9d
    sleep 2
    # press TAB(0f), release TAB(8f), repeat, press SPACE(39), release SPACE(b9)
    VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode 0f 8f 0f 8f 39 b9
    sleep 5

    return 0
}

execute_in_cmd() {
    # write command
    VBoxManage controlvm $VM_DEV_MACHINE keyboardputstring "$1"
    sleep 2
    # press RETURN(1C=00011100), release RETURN(9C=10011100)
    # release key is press key code bitwise or 0x80 (most significant bit to 1) 
    VBoxManage controlvm $VM_DEV_MACHINE keyboardputscancode 1c 9c 
    sleep 5
    return 0
}

wait_windows_ready() {
    while [ 1 == 1 ]; do
        echo "Check if windows is ready..."
        execute_command "cmd.exe /c echo logged > $1"
        sleep 5
        if [ -f "$file" ]; then
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
file="$folder/logged.txt"
drive="z:\\"
# add share to temp folder
#"$SCRIPT_DIR/vm-add-share.sh" "$folder" "$drive"
# start headless
"$SCRIPT_DIR/vm-start-headless.sh"
# wait to windows to be ready creating this file
wait_windows_ready "${drive}logged.txt"
echo "Ready ..."

echo "Executing commands..."
execute_elevated_command "cmd.exe"
#execute_in_cmd("net user administrator /active:yes")
#execute_in_cmd("net user administrator Demo")
#execute_in_cmd("net user User Demo")
#execute_in_cmd("reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f")
execute_in_cmd "shutdown /s /t 0 /f"

while [ 1 == 1 ]; do
    result=`"$SCRIPT_DIR/vm-is-running.sh"`
    if [ "M$result" == "M0" ]; then
        break
    fi
    echo "Still running..."
    sleep 5
done

sleep 5
