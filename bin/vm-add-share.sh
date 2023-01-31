#!/bin/bash
if [ "M$2" == "M" ]; then
    echo "Uso `basename $0` host-folder guest-mount-point"
fi

VBoxManage sharedfolder add "$VM_DEV_MACHINE" --name "init-share" --hostpath "$1" --automount --auto-mount-point "$2"
