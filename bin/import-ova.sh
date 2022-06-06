#!/bin/bash
if [ "M$1" == "M" ]; then
    echo "missing OVA filename" && exit -1
fi

vboxmanage import "$1" --vsys 0 --vmname "$VM_DEV_MACHINE"
vboxmanage modifyvm "$VM_DEV_MACHINE" --cpus 2 --memory 4096