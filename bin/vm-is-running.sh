#!/bin/bash
vboxmanage showvminfo $VM_DEV_MACHINE | grep -c "running (since"
