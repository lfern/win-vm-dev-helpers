#!/bin/bash

MYTMPFILE="$(mktemp)"
trap 'rm -f -- "$MYTMPFILE"' EXIT

cat <<EOF > "$MYTMPFILE"
select disk 1
clean
create partition primary
format fs=ntfs label=Projects
assign letter=E
EOF

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" copyto "$MYTMPFILE" --target-directory c:\\Users\\User\\Desktop\\diskpart.script
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "diskpart.exe" --wait-stdout -- diskpart.exe "/s" "c:\\Users\\User\\Desktop\\diskpart.script"
