#!/bin/sh
result=`vboxmanage showvminfo $VM_DEV_MACHINE | grep -c "running (since"`
if [ "M$result" == "M1" ]; then
    exit 1
else
    exit 0
fi