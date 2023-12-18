# Virtual Machine Creation Automatization for Development

## Environment variables and paths
Create .env file with required env variables:
```bash 
# User name shipped with provided Windows virtual machine
export VM_DEV_USER=User
# Selected password for User
export VM_DEV_PASS=whatever-password
# Administrator user
export VM_DEV_ADMINUSER=Administrator
# Selected password for Administrator
export VM_DEV_ADMINPASS=choose-your-password
# Machine name
export VM_DEV_MACHINE=your-machine-name
# Number of CPUs
export VM_DEV_CPUS=2
# Assigned memory
export VM_DEV_MEMORY=4096
# VRDE Username
export VM_DEV_VRDEUSER=your-username-for-vrde
# VRDE Password
export VM_DEV_VRDEPASS=password-for-vrde
# VRDE Port
export VM_DEV_VRDE_PORT=5555
# Jenkins base URL
export VM_DEV_JENKINS_URL=jenkins-base-url
``` 
Also, you can add these lines to add the bin directory to the path and load some function utils from vm-lib.sh file

```bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";
if [[ :$PATH: != *:"$SCRIPT_DIR":* ]] ; then
    export PATH=$PATH:"$SCRIPT_DIR/bin"
    . "$SCRIPT_DIR/bin/vm-lib.sh"
fi
```
Then load .env file `source .env`.

## Create VM, configure and install some apps
All these steps is coded in the `vm-create-vm-quiet` script. It is a first try to create a unnattended script to create a windows virtual machine used for development purposes, e.g. a jenkins windows agent to compile rust project.
### Create and initialize VM
```bash
# Download win vm image
download-win-vm
# Import OVA
import-ova *.ova
# Enable VRDE (0.0.0.0) and set VRDE credentials (if needed)
vm-set-vrde "$VM_DEV_VRDEUSER" "$VM_DEV_VRDEPASS"
# Disable (if necesary) 3D acceleration
vm_disable_3d_accel
# Initialize VM (Activate Administrator User,
#  set Administrator password, set User password
#  and disable UAC
vm-init
```
### Install apps, service logon rights and add keys to ssh known_hosts file
```bash
# install visual studio desktop C development
vm-install-vs-desktop
# install choco
vm-install-choco
# install git and add to path
vm-install-git
vm-install-gitpath
# install carbon (needed to add service logon right privilege to User, so it can be used in windows services)
vm-install-carbon
# set powershell policy remotesigned
vm_powershell Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
# Grant service logon right to User
vm_powershell "Import-Module 'Carbon';Grant-CPrivilege -Identity \"$VM_DEV_USER\" -Privilege SeServiceLogonRight"
# Add bitbucket to known_hosts file
vm_run "mkdir c:\\Users\\User\\.ssh"
vm_run "ssh-keyscan -H bitbucket.org >> c:\\Users\\User\\.ssh\\known_hosts"
# Install rust
vm-install-rust
# Install cargo-make complement
vm_run cargo install cargo-make
```
## Install jenkins agent
```bash
vm-install-jenkins jenkins-agent-name jenkins-agent-secret
```
* jenkins-agent-name: name assigned to this agent in jenkins server (just like it is showed in the jenkins agent URL e.g: in this url: http://192.168.0.17:8001/manage/computer/win%2Drust/jenkins-agent.jnlp, the agent name would be win%2Drust).


### Remove machine
Just if you need to remove the machine
```bash
VBoxManage unregistervm --delete "$VM_DEV_MACHINE"
```