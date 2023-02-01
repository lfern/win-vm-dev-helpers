#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e

#"$SCRIPT_DIR/download-win-vm.sh"
"$SCRIPT_DIR/import-ova.sh *.ova"
"$SCRIPT_DIR/vm-set-set-vrde lfern \"$VM_DEV_VRDEPASS\""
"$SCRIPT_DIR/vm-init.sh"
