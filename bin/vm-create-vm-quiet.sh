#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
restore_set() {
    SAVED_OPTIONS=$(set +o)
    trap 'eval "$SAVED_OPTIONS"' EXIT
}

track_last_command() {
    # keep track of the last executed command
    trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
    # echo an error message before exiting
    trap 'echo "\"${last_command}\" command filed with exit code $?."' EXIT
}

restore_set
track_last_command
set -e

#"$SCRIPT_DIR/download-win-vm.sh"
echo "Importing ova ..."
"$SCRIPT_DIR/import-ova.sh" *.ova
echo "Setting VRDE config"
"$SCRIPT_DIR/vm-set-vrde.sh" lfern "$VM_DEV_VRDEPASS"
echo "Init..."
"$SCRIPT_DIR/vm-init.sh"
echo "Start headless"
"$SCRIPT_DIR/vm-start-headless.sh"
"$SCRIPT_DIR/vm-wait4run.sh"
echo "Installing vs desktop..."
"$SCRIPT_DIR/vm-install-vs-desktop.sh"
echo "Installing rust..."
"$SCRIPT_DIR/vm-install-rust.sh"
echo "Installing choco..."
"$SCRIPT_DIR/vm-install-choco.sh"
echo "Installing git..."
"$SCRIPT_DIR/vm-install-git.sh"
"$SCRIPT_DIR/vm-install-gitpath.sh"
echo "Installing vs desktop..."
"$SCRIPT_DIR/powershell.sh" Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

