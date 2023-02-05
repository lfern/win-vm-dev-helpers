#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "$SCRIPT_DIR/vm-lib.sh"

track_last_command
set -e

#"$SCRIPT_DIR/download-win-vm.sh"
echo "Importing ova ..."
"$SCRIPT_DIR/import-ova.sh" ./*.ova
echo "Setting VRDE config"
"$SCRIPT_DIR/vm-set-vrde.sh" lfern "$VM_DEV_VRDEPASS"
echo "Init..."
"$SCRIPT_DIR/vm-init.sh"
echo "Start headless"
vm_start_headless
"$SCRIPT_DIR/vm-wait4run.sh"
echo "Installing vs desktop..."
"$SCRIPT_DIR/vm-install-vs-desktop.sh"
echo "Installing choco..."
"$SCRIPT_DIR/vm-install-choco.sh"
echo "Installing git..."
"$SCRIPT_DIR/vm-install-git.sh"
"$SCRIPT_DIR/vm-install-gitpath.sh"
echo "Setting powershell policy remotesigned..."
vm_powershell Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

vm_run "mkdir c:\\Users\\User\\.ssh"
vm_run "ssh-keyscan -H bitbucket.org >> c:\\Users\\User\\.ssh\\known_hosts"

"$SCRIPT_DIR/vm-login-user.sh"
echo "Installing rust..."
"$SCRIPT_DIR/vm-install-rust.sh"
"$SCRIPT_DIR/vm-logoff.sh"

echo "Stop machine..."
vm_stop
vm_wait_windows_stopped

echo "Start headless"
vm_start_headless
"$SCRIPT_DIR/vm-wait4run.sh"

vm_run cargo install cargo-make
