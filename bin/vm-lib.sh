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
# Wait windows stopped
# Options:
#   Machine to be executed on
#######################################
vm_wait_windows_stopped() {
    local machine
    parse_options result "$@"
    shift "${result[0]}"
    machine="${result[3]}"

    #local machine="${3:-$VM_DEV_MACHINE}"

    while : ; do
        echo "Check if windows is stopped..."
        result=$(vm_isrunning -m "$machine")
        if [ "M$result" == "M0" ]; then
            break;
        fi
        echo "Sleep 20 seconds"
        sleep 20
    done

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
# Wait windows ready to receive commands
# Arguments:
#   File
#   Local file
# Options:
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
        vm_execute_command -m "$machine" "cmd.exe /c echo logged > $file"
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
# Copy from
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
# Copy to
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

    return 0
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

# source: https://github.com/mrbaseman/parse_yaml.git
vm_parse_yaml() {
   local prefix=$2
   local separator=${3:-_}

   local indexfix
   # Detect awk flavor
   if awk --version 2>&1 | grep -q "GNU Awk" ; then
      # GNU Awk detected
      indexfix=-1
   elif awk -Wv 2>&1 | grep -q "mawk" ; then
      # mawk detected
      indexfix=0
   fi

   local s='[[:space:]]*' sm='[ \t]*' w='[a-zA-Z0-9_]*' fs=${fs:-$(echo @|tr @ '\034')} i=${i:-  }
   cat $1 | \
   awk -F$fs "{multi=0; 
       if(match(\$0,/$sm\|$sm$/)){multi=1; sub(/$sm\|$sm$/,\"\");}
       if(match(\$0,/$sm>$sm$/)){multi=2; sub(/$sm>$sm$/,\"\");}
       while(multi>0){
           str=\$0; gsub(/^$sm/,\"\", str);
           indent=index(\$0,str);
           indentstr=substr(\$0, 0, indent+$indexfix) \"$i\";
           obuf=\$0;
           getline;
           while(index(\$0,indentstr)){
               obuf=obuf substr(\$0, length(indentstr)+1);
               if (multi==1){obuf=obuf \"\\\\n\";}
               if (multi==2){
                   if(match(\$0,/^$sm$/))
                       obuf=obuf \"\\\\n\";
                       else obuf=obuf \" \";
               }
               getline;
           }
           sub(/$sm$/,\"\",obuf);
           print obuf;
           multi=0;
           if(match(\$0,/$sm\|$sm$/)){multi=1; sub(/$sm\|$sm$/,\"\");}
           if(match(\$0,/$sm>$sm$/)){multi=2; sub(/$sm>$sm$/,\"\");}
       }
   print}" | \
   sed  -e "s|^\($s\)?|\1-|" \
       -ne "s|^$s#.*||;s|$s#[^\"']*$||;s|^\([^\"'#]*\)#.*|\1|;t1;t;:1;s|^$s\$||;t2;p;:2;d" | \
   sed -ne "s|,$s\]$s\$|]|" \
        -e ":1;s|^\($s\)\($w\)$s:$s\(&$w\)\?$s\[$s\(.*\)$s,$s\(.*\)$s\]|\1\2: \3[\4]\n\1$i- \5|;t1" \
        -e "s|^\($s\)\($w\)$s:$s\(&$w\)\?$s\[$s\(.*\)$s\]|\1\2: \3\n\1$i- \4|;" \
        -e ":2;s|^\($s\)-$s\[$s\(.*\)$s,$s\(.*\)$s\]|\1- [\2]\n\1$i- \3|;t2" \
        -e "s|^\($s\)-$s\[$s\(.*\)$s\]|\1-\n\1$i- \2|;p" | \
   sed -ne "s|,$s}$s\$|}|" \
        -e ":1;s|^\($s\)-$s{$s\(.*\)$s,$s\($w\)$s:$s\(.*\)$s}|\1- {\2}\n\1$i\3: \4|;t1" \
        -e "s|^\($s\)-$s{$s\(.*\)$s}|\1-\n\1$i\2|;" \
        -e ":2;s|^\($s\)\($w\)$s:$s\(&$w\)\?$s{$s\(.*\)$s,$s\($w\)$s:$s\(.*\)$s}|\1\2: \3 {\4}\n\1$i\5: \6|;t2" \
        -e "s|^\($s\)\($w\)$s:$s\(&$w\)\?$s{$s\(.*\)$s}|\1\2: \3\n\1$i\4|;p" | \
   sed  -e "s|^\($s\)\($w\)$s:$s\(&$w\)\(.*\)|\1\2:\4\n\3|" \
        -e "s|^\($s\)-$s\(&$w\)\(.*\)|\1- \3\n\2|" | \
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\(---\)\($s\)||" \
        -e "s|^\($s\)\(\.\.\.\)\($s\)||" \
        -e "s|^\($s\)-$s[\"']\(.*\)[\"']$s\$|\1$fs$fs\2|p;t" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p;t" \
        -e "s|^\($s\)-$s\(.*\)$s\$|\1$fs$fs\2|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\?\(.*\)$s\$|\1$fs\2$fs\3|" \
        -e "s|^\($s\)[\"']\?\([^&][^$fs]\+\)[\"']$s\$|\1$fs$fs$fs\2|" \
        -e "s|^\($s\)[\"']\?\([^&][^$fs]\+\)$s\$|\1$fs$fs$fs\2|" \
        -e "s|$s\$||p" | \
   awk -F$fs "{
      gsub(/\t/,\"        \",\$1);
      if(NF>3){if(value!=\"\"){value = value \" \";}value = value  \$4;}
      else {
        if(match(\$1,/^&/)){anchor[substr(\$1,2)]=full_vn;getline};
        indent = length(\$1)/length(\"$i\");
        vname[indent] = \$2;
        value= \$3;
        for (i in vname) {if (i > indent) {delete vname[i]; idx[i]=0}}
        if(length(\$2)== 0){  vname[indent]= ++idx[indent] };
        vn=\"\"; for (i=0; i<indent; i++) { vn=(vn)(vname[i])(\"$separator\")}
        vn=\"$prefix\" vn;
        full_vn=vn vname[indent];
        if(vn==\"$prefix\")vn=\"$prefix$separator\";
        if(vn==\"_\")vn=\"__\";
      }
      assignment[full_vn]=value;
      if(!match(assignment[vn], full_vn))assignment[vn]=assignment[vn] \" \" full_vn;
      if(match(value,/^\*/)){
         ref=anchor[substr(value,2)];
         if(length(ref)==0){
           printf(\"%s=\\\"%s\\\"\n\", full_vn, value);
         } else {
           for(val in assignment){
              if((length(ref)>0)&&index(val, ref)==1){
                 tmpval=assignment[val];
                 sub(ref,full_vn,val);
                 if(match(val,\"$separator\$\")){
                    gsub(ref,full_vn,tmpval);
                 } else if (length(tmpval) > 0) {
                    printf(\"%s=\\\"%s\\\"\n\", val, tmpval);
                 }
                 assignment[val]=tmpval;
              }
           }
         }
      } else if (length(value) > 0) {
         printf(\"%s=\\\"%s\\\"\n\", full_vn, value);
      }
   }END{
      for(val in assignment){
         if(match(val,\"$separator\$\"))
            printf(\"%s=\\\"%s\\\"\n\", val, assignment[val]);
      }
   }"
}

vm_config_prefix() {
    echo "${VMPREFIX:-"VM_"}"
}
vm_load_conf() {
    local prefix
    prefix="$(vm_config_prefix)"
    eval $(vm_parse_yaml "$1" "$prefix")
    local user_var=${prefix}"machine_user"
    local pass_var=${prefix}"machine_pass"
    local adminuser_var=${prefix}"machine_adminuser"
    local adminpass_var=${prefix}"machine_adminpass"
    local machine_var=${prefix}"machine_name"
    local cpus_var=${prefix}"machine_cpus"
    local memory_var=${prefix}"machine_memory"
    local vrdeuser_var=${prefix}"vrde_user"
    local vrdepass_var=${prefix}"vrde_pass"
    local vrdeaddress_var=${prefix}"vrde_address"
    local vrdeport_var=${prefix}"vrde_port"
    # old variables
    VM_DEV_USER="${!user_var}"
    VM_DEV_PASS="${!pass_var}"
    VM_DEV_ADMINUSER="${!adminuser_var}"
    VM_DEV_ADMINPASS="${!adminpass_var}"
    VM_DEV_MACHINE="${!machine_var}"
    VM_DEV_CPUS="${!cpus_var}"
    VM_DEV_MEMORY="${!memory_var}"
    VM_DEV_VRDEUSER="${!vrdeuser_var}"
    VM_DEV_VRDEPASS="${!vrdepass_var}"
    VM_DEV_VRDEADDRESS="${!vrdeaddress_var}"
    VM_DEV_VRDEPORT="${!vrdeport_var}"
}

vm_unload_conf() {
    local prefix
    prefix="$(vm_config_prefix)"
    unset $(compgen -v "$prefix")
}

vm_show_conf() {
    local prefix
    prefix=$(vm_config_prefix)
    local machine_prefix="${prefix}machine_"
    local vrde_prefix="${prefix}vrde_"
    while read -r line; do echo "$line=${!line}"; done < <(compgen -v "$machine_prefix")
    while read -r line; do echo "$line=${!line}"; done < <(compgen -v "$vrde_prefix")
    while read -r line; do echo "$line=${!line}"; done < <(compgen -v "VM_DEV_")
    local index=1
    local combined
    echo "Script:"
    while : ; do
        combined="${prefix}installscript_${index}"
        if [ -z ${!combined+x} ]; then break; fi
        echo "    "$index "->" ${!combined}
        index=$((index+1))
    done
}