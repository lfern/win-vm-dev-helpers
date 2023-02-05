#!/bin/bash
if [ M"$2" == "M" ]; then
    echo "Uso: $(basename "$0") user pass"
    exit 1
fi

### Prepare for RDP
VBoxManage setproperty vrdeauthlibrary "VBoxAuthSimple"
VBoxManage modifyvm "$VM_DEV_MACHINE" --vrde on
VBoxManage modifyvm "$VM_DEV_MACHINE" --vrdeaddress 0.0.0.0
VBoxManage modifyvm "$VM_DEV_MACHINE" --vrdeauthtype external

### Set password for user
result=$(VBoxManage internalcommands passwordhash "$2")
IFS=' ' read -r -a array <<< "$result"
VBoxManage setextradata "$VM_DEV_MACHINE" "VBoxAuthSimple/users/$1" "${array[-1]}"
