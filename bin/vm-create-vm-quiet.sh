#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
set -e

#"$SCRIPT_DIR/download-win-vm.sh"
"$SCRIPT_DIR/import-ova.sh" *.ova
"$SCRIPT_DIR/vm-set-vrde.sh" lfern \"$VM_DEV_VRDEPASS\""
"$SCRIPT_DIR/vm-init.sh"
"$SCRIPT_DIR/vm-start-headless.sh"
"$SCRIPT_DIR/vm-wait4run.sh"

"$SCRIPT_DIR/vm-install-vs-desktop.sh"
"$SCRIPT_DIR/vm-install-rust.sh"
"$SCRIPT_DIR/vm-install-choco.sh"
"$SCRIPT_DIR/vm-install-git.sh"
"$SCRIPT_DIR/vm-install-gitpath.sh"


