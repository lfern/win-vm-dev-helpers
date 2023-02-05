#!/bin/bash
#
# Some util funcs

parse_options() {
    local -n ret=$1
    shift
    ret[0]=1
    ret[1]="${VM_DEV_USER}"
    ret[2]="${VM_DEV_PASS}"
    ret[3]="${VM_DEV_MACHINE}"
    
    local OPTIND

    OPTIND=1
    while getopts 'u:p:m:' opt; do
        case "$opt" in
            u)
            ret[1]="$OPTARG"
            ;;
            
            p)
            ret[2]="$OPTARG"
            ;;
            
            m)
            ret[3]="$OPTARG"
            ;;

            *)
            ;;
        esac
    done
    #shift "$(($OPTIND -1))"
    ret[0]="$(($OPTIND -1))"
}

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
    # local machine="${1:-$VM_DEV_MACHINE}"
    local machine
    parse_options result "$@"
    shift "${result[0]}"
    machine="${result[3]}"
    vboxmanage showvminfo "$machine" | grep -c "running (since"
    return 0
}

#######################################
# Send win+r keys to vm
# Arguments:
#   Machine to be executed on
#######################################
vm_send_win_r() {
    #local machine="${1:-$VM_DEV_MACHINE}"
    local machine
    parse_options result "$@"
    shift "${result[0]}"
    machine="${result[3]}"
    # press WINDOWS KEY(E0 5B), press R(13), release WINDOWS KEY(E0DB), release R(93)
    VBoxManage controlvm "$machine" keyboardputscancode E0 5B 13 E0 DB 93
    sleep 5 
    return 0
}

#######################################
# Execute command in vm
# Arguments:
#   Command to execute
#   Machine to be executed on
#######################################
vm_execute_command() {
    local machine
    parse_options result "$@"
    shift "${result[0]}"
    machine="${result[3]}"

    local command="${1:?command is missing}"
    #local machine="${2:-$VM_DEV_MACHINE}"

    vm_send_win_r "$machine"
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
#   Command execute
#   Machine to be executed on
#######################################
vm_execute_elevated_command() {
    local machine
    parse_options result "$@"
    shift "${result[0]}"
    machine="${result[3]}"

    local command="${1:?command is missing}"
    #local machine="${2:-$VM_DEV_MACHINE}"

    vm_send_win_r "$machine"
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
#   Command to execute
#   Machine to be executed on
#######################################
vm_execute_in_cmd() {
    local machine
    parse_options result "$@"
    shift "${result[0]}"
    machine="${result[3]}"

    local command="${1:?command is missing}"
    #local machine="${2:-$VM_DEV_MACHINE}"

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
#   File
#   Local file
#   Machine to be executed on
#######################################
vm_wait_windows_ready() {
    local machine
    parse_options result "$@"
    shift "${result[0]}"
    machine="${result[3]}"

    local file="${1:?file is missing}"
    local localfile="${2:?local-file is missing}"
    #local machine="${3:-$VM_DEV_MACHINE}"

    while : ; do
        echo "Check if windows is ready..."
        vm_execute_command "cmd.exe /c echo logged > $file"
        sleep 5
        if [ -f "$localfile" ]; then
            break;
        fi
        echo "Sleep 20 seconds"
        sleep 20
    done

    return 0
}

#######################################
# Execute command vm
# Arguments:
#   From file
#   To file
#   Machine to be executed on
#######################################
vm_copy_from() {
    local user pass machine
    parse_options result "$@"
    shift "${result[0]}"
    user="${result[1]}"
    pass="${result[2]}"
    machine="${result[3]}"

    local from_file="${1:?file is missing}"
    local to_file="${2:?local-file is missing}"
    #local machine="${3:-$VM_DEV_MACHINE}"
    #local user="${4:-$VM_DEV_USER}"
    #local pass="${5:-$VM_DEV_PASS}"

    VBoxManage guestcontrol "$machine" --username "$user" --password "$pass" copyfrom "$from_file" "$to_file" 
}

#######################################
# Execute command vm
# Arguments:
#   From file
#   To file
#   Machine to be executed on
#   User
#   Pass
#######################################
vm_copy_to() {
    local user pass machine
    parse_options result "$@"
    shift "${result[0]}"
    user="${result[1]}"
    pass="${result[2]}"
    machine="${result[3]}"
    
    local from_file="${1:?file is missing}"
    local to_file="${2:?local-file is missing}"
    #local machine="${3:-$VM_DEV_MACHINE}"
    #local user="${4:-$VM_DEV_USER}"
    #local pass="${5:-$VM_DEV_PASS}"

    VBoxManage guestcontrol "$machine" --username "$user" --password "$pass" copyto "$from_file" "$to_file" 
}

#######################################
# Execute command, for user
# Options:
#   -m Machine to be executed on
#   -u User to be executed on
#   -p Pass for user
#######################################
vm_run() {
    local user pass machine
    parse_options result "$@"
    shift "${result[0]}"
    user="${result[1]}"
    pass="${result[2]}"
    machine="${result[3]}"
    
    VBoxManage guestcontrol "$machine" --username "$user" --password "$pass" run --exe "cmd.exe" -- cmd.exe /c "$@"

}

#######################################
# Start vm
# Options:
#   -m Machine to be executed on
#######################################
vm_start() {
    local machine
    parse_options result "$@"
    shift "${result[0]}"
    machine="${result[3]}"

    VBoxManage startvm "$machine"
}

#######################################
# Start vm headless mode
# Options:
#   -m Machine to be executed on
#######################################
vm_start_headless() {
    local machine
    parse_options result "$@"
    shift "${result[0]}"
    machine="${result[3]}"

    VBoxManage startvm "$machine" --type headless
}


#######################################
# Stop machine, executing command for user
# Options:
#   -m Machine to be executed on
#   -u User to be executed on
#   -p Pass for user
#######################################
vm_stop() {
    local user pass machine
    parse_options result "$@"
    shift "${result[0]}"
    user="${result[1]}"
    pass="${result[2]}"
    machine="${result[3]}"

    VBoxManage guestcontrol "$machine" --username "$user" --password "$pass" run --exe "cmd.exe" -- "cmd" "/c" "shutdown /s /t 0 /f"
}

#######################################
# Reboot, executing command for user
# Options:
#   -m Machine to be executed on
#   -u User to be executed on
#   -p Pass for user
#######################################
vm_reboot() {
    local user pass machine
    parse_options result "$@"
    shift "${result[0]}"
    user="${result[1]}"
    pass="${result[2]}"
    machine="${result[3]}"

    VBoxManage guestcontrol "$machine" --username "$user" --password "$pass" run --exe "cmd.exe" -- "cmd" "/c" "shutdown /r /t 0 /f"
}

#######################################
# Check user is logged
# Options:
#   -m Machine to be executed on
#   -u User to be executed on
#   -p Pass for user
# Outputs:
#   1 if user is logged, else 0
#######################################
vm_islogged() {
    local user pass machine
    parse_options result "$@"
    shift "${result[0]}"
    user="${result[1]}"
    pass="${result[2]}"
    machine="${result[3]}"

    result=$(VBoxManage guestcontrol "$machine" --username "$user" --password "$pass" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe query user)
    if [ "M$result" != "M"  ]; then
        echo 1
    else
        echo 0
    fi

}

#######################################
# Execute command in powershell
# Options:
#   -m Machine to be executed on
#   -u User to be executed on
#   -p Pass for user
#######################################
vm_powershell() {
    local user pass machine
    parse_options result "$@"
    shift "${result[0]}"
    user="${result[1]}"
    pass="${result[2]}"
    machine="${result[3]}"

    VBoxManage guestcontrol "$machine" --username "$user" --password "$pass" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe "$@"
}

#######################################
# Add share to vm
# Arguments:
#   Host folder
#   Guest mount point
# Options:
#   -m Machine to be executed on
#######################################
vm_add_share() {
    local machine
    parse_options result "$@"
    shift "${result[0]}"
    machine="${result[3]}"
    local host_folder="${1:?host-folder is missing}"
    local guest_mount_point="${2:?guest-mount-point is missing}"

    VBoxManage sharedfolder add "$machine" --name "init-share" --hostpath "$host_folder" --automount --auto-mount-point "$guest_mount_point"

}

#######################################
# acpi power button
# Options:
#   -m Machine to be executed on
#######################################
vm_acpipowerbutton () {
    local machine
    parse_options result "$@"
    shift "${result[0]}"
    machine="${result[3]}"

    VBoxManage controlvm "$machine" acpipowerbutton
}

#######################################
# poweroff
# Options:
#   -m Machine to be executed on
#######################################
vm_poweroff() {
    local machine
    parse_options result "$@"
    shift "${result[0]}"
    machine="${result[3]}"

    VBoxManage controlvm "$machine" poweroff
}

#######################################
# reset
# Options:
#   -m Machine to be executed on
#######################################
vm_reset() {
    local machine
    parse_options result "$@"
    shift "${result[0]}"
    machine="${result[3]}"

    VBoxManage controlvm "$machine" reset
}