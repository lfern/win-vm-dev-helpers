#!/bin/bash
#
# Some util funcs

#######################################
# Restore set 
#######################################
restore_set() {
    local SAVED_OPTIONS
    SAVED_OPTIONS=$(set +o)
    trap eval "$SAVED_OPTIONS" EXIT
}

#######################################
# Track last command on error (when you set set -e)
#######################################
track_last_command() {
    # keep track of the last executed command
    trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
    # echo an error message before exiting
    trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT
}

#######################################
# Show last command on error (set -t)
# example:
#   exit_on_error $? !!
# Arguments:
#   Exit code
# Outputs:
#   last command and error code of last command
#######################################
exit_on_error() {
    exit_code=$1
    last_command=${@:2}
    if [ $exit_code -ne 0 ]; then
        >&2 echo "\"${last_command}\" command failed with exit code ${exit_code}."
        exit $exit_code
    fi
}

#######################################
# Get configuration directory.
# Arguments:
#   Machine to be executed on
# Outputs:
#   1 if machine is running, else 0
#######################################
vm_isrunning() {
    # local machine="${1:?machine-name is missing}"
    local machine="${1:-$VM_DEV_MACHINE}"
    vboxmanage showvminfo "$machine" | grep -c "running (since"
    return 0
}

#######################################
# Send win+r keys to vm
# Arguments:
#   Machine to be executed on
#######################################
vm_send_win_r() {
    local machine="${1:-$VM_DEV_MACHINE}"
    # press WINDOWS KEY(E0 5B), press R(13), release WINDOWS KEY(E0DB), release R(93)
    VBoxManage controlvm "$machine" keyboardputscancode E0 5B 13 E0 DB 93
    sleep 5 
    return 0
}

#######################################
# Execute command in vm
# Arguments:
#   Machine to be executed on
#######################################
vm_execute_command() {
    local command="${1:?command is missing}"
    local machine="${2:-$VM_DEV_MACHINE}"
    send_win_r "$machine"
    # write command
    VBoxManage controlvm "$machine" keyboardputstring "$command"
    sleep 2
    # press RETURN(1C=00011100), release RETURN(9C=10011100)
    # release key is press key code bitwise or 0x80 (most significant bit to 1) 
    VBoxManage controlvm "$machine" keyboardputscancode 1c 9c 
    sleep 5 
    return 0
}

#######################################
# Execute elevated command vm
# Arguments:
#   Machine to be executed on
#######################################
vm_execute_elevated_command() {
    local command="${1:?command is missing}"
    local machine="${2:-$VM_DEV_MACHINE}"
    send_win_r "$machine"
    # write command
    VBoxManage controlvm "$machine" keyboardputstring "$command"
    sleep 2
    # press CTRL(1d), press LEFT SHIFT(1a), press return(1c), release return(9c)
    VBoxManage controlvm "$machine" keyboardputscancode 1d 2a 1c 9c
    sleep 1
    # release LEFT SHIFT(aa), release CTRL(9d)
    VBoxManage controlvm "$machine" keyboardputscancode aa 9d
    sleep 2
    # press TAB(0f), release TAB(8f), repeat, press SPACE(39), release SPACE(b9)
    VBoxManage controlvm "$machine" keyboardputscancode 0f 8f 0f 8f 39 b9
    sleep 5

    return 0
}

#######################################
# Execute command vm
# Arguments:
#   Machine to be executed on
#######################################
vm_execute_in_cmd() {
    local command="${1:?command is missing}"
    local machine="${2:-$VM_DEV_MACHINE}"
    # write command
    VBoxManage controlvm "$machine" keyboardputstring "$command"
    sleep 2
    # press RETURN(1C=00011100), release RETURN(9C=10011100)
    # release key is press key code bitwise or 0x80 (most significant bit to 1) 
    VBoxManage controlvm "$machine" keyboardputscancode 1c 9c 
    sleep 5
    return 0
}

#######################################
# Execute command vm
# Arguments:
#   Machine to be executed on
#######################################
vm_wait_windows_ready() {
    local file="${1:?file is missing}"
    local localfile="${2:?local-file is missing}"
    local machine="${3:-$VM_DEV_MACHINE}"
    while : ; do
        echo "Check if windows is ready..."
        execute_command "cmd.exe /c echo logged > $file"
        sleep 5
        if [ -f "$localfile" ]; then
            break;
        fi
        echo "Sleep 20 seconds"
        sleep 20
    done

    return 0
}
