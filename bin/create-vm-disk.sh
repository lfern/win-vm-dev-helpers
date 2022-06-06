#!/bin/bash
if [ "M$1" == "M" ]; then
    echo "Missing filename" && exit -1
fi
file="$HOME/VirtualBox VMs/$VM_DEV_MACHINE/$1.vdi"
vboxmanage createhd --filename "$file" --size 60000 --format VDI
vboxmanage storageattach "$VM_DEV_MACHINE" \
    --storagectl "SATA" \
    --device 0 \
    --port 2 \
    --type hdd \
    --medium "$file"