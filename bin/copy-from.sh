#!/bin/bash
#!/bin/bash
if [ "M$1" == "M" ]; then
    echo "Missing file" && exit -1
fi

if [ "M$2" == "M" ]; then
    echo "Missing dest file" && exit -1
fi

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" copyfrom "$1" "$2" 

