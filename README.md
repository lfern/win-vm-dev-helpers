Create .env file with required env variables:
``` 
export VM_DEV_USER=User
export VM_DEV_PASS=demo
export VM_DEV_ADMINUSER=Administrator
export VM_DEV_ADMINPASS=demo
export VM_DEV_MACHINE=WinDev2301Eval
``` 
And do `source .env`

## Phase 1: Download and create VM
### Download win vm image
`download-win-vm.sh`
### Import OVA
`import-ova.sh vm_windows.ova`
### Create devel disk (or reuse previous one)
`create-vm-disk.sh filename`
### Start VM
`vm-start.sh`
## Phase 2: Manual steps to enable execution from guest
### Enable Administrator account
* Right-click the Start menu (or press Windows key + X) > Computer Management, then expand Local Users and Groups > Users.
* Select the Administrator account, right click on it then click Properties. Uncheck Account is disabled, click Apply then OK.
### Disable a Windows Security Policy
* In “Run” type “gpedit.msc”, then go to “Windows Settings” -> “Security Settings” -> “Local Policies” -> “Security Options” -> “Accounts: Limit local account use of blank passwords to console logon only” and set it to DISABLED. A reboot may be needed for the changes to take effect.
* If you are running Windows 7 Home and you don’t have Group Policy Editor installed, you can open regedit.exe (Windows Registry) and browse to the following registry key (you’ll need Administrator rights to change it):
```
HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa
Then change the DWORD value “LimitBlankPasswordUse” to 0 (that means disabled).
```
### Disable UAC
#### Option 1
* Open the Control Panel in Windows 10. Set the View by option to Large icons, and then click User Accounts.
user-accounts
* Click on the Change User Account Control settings link.
change-uac-settings
* In order to turn off UAC, move the slider to the bottom (Never Notify) and click OK. If you want to turn on UAC, move the silder to the top (Always notify).
uac-settings
* If prompted by UAC, click on Yes to continue. Reboot your computer for the change to take effect.
#### Option 2
* Open Regedit and browse to this registry location: `HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Lsa`
* In the right panel, set the value of the DWORD entry `EnableLUA` to 0:
* If you do not have this DWORD entry, then create it.
* Then reboot the computer.
#### Option 3
```
Windows Registry Editor Version 5.00

; Created by: Shawn Brink
; Created on: June 20th 2018
; Tutorial: https://www.tenforums.com/tutorials/112612-enable-disable-uac-prompt-built-administrator-windows.html


[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System]
"ValidateAdminCodeSignatures"=dword:00000000
```
### Set User and Administrator passwords
* Press `Win-r`.
* In the dialog box, type `compmgmt`. msc , and then press Enter.
* Expand Local Users and Groups and select the Users folder.
* Right-click the Administrator account and select Password.
* (Same for User)
* Update .env file with new passwords

## Phase 3: Initialize created disk
`init_vm_disk.sh`

## Phase 4: Install some utils
### Ssh key for git
Copy your keys, but it should be decrypted so you could execute git commands from guest:
```
copy-ssh-key.sh .ssh/id_rsa.pub
copy-ssh-key.sh .ssh/known_hosts
copy-ssh-key.sh .ssh/id_rsa 
...
```
### Programs
* vm-install-choco.sh
* vm-install-chrome.sh
* vm-install-git.sh
* vm-install-gitpath.sh
* vm-install-jre.sh
* vm-install-node.sh
* vm-install-nsis.sh
* vm-install-python.sh
* vm-install-vcpkg.sh
### Vcpkg libraries:
* vc-install-vcpkg-libs.sh







# TESTING
## Remove VM
VBoxManage unregistervm --delete "$VM_DEV_MACHINE"
##
```bash
#!/bin/bash
set -e
# Any subsequent(*) commands which fail will cause the shell script to exit immediately
```
## From host computer
`source .env`
### Download win vm image
`download-win-vm.sh`
### Import OVA
`import-ova.sh *.ova`
### Prepare for RDP
```bash
VBoxManage setproperty vrdeauthlibrary "VBoxAuthSimple"
VBoxManage modifyvm $VM_DEV_MACHINE --vrde on
VBoxManage modifyvm $VM_DEV_MACHINE --vrdeaddress 0.0.0.0
VBoxManage modifyvm $VM_DEV_MACHINE --vrdeauthtype external
```
### Set password for user
```bash
VBoxManage internalcommands passwordhash "password"
VBoxManage setextradata $VM_DEV_MACHINE "VBoxAuthSimple/users/username" previous hash
```
### Start VM
`vm-start.sh` or `VBoxHeadless --startvm $VM_DEV_MACHINE`

## Manually in guest
### Activate admin user
`net user administrator /active:yes`
### Change passwords "Demo" password
`net user User Demo`
`net user administrator Demo`
### Disable UAC
`reg HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /v EnableLUA /t REG_DWORD /d 0 /f`

## Back to from host computer
### Install lang pack es-ES
`vm-install-lang-es.sh`
### Install lang list (need to be logged, why?)
```bash
vm-login-user.sh
vm-install-lang-list.sh
vm-logoff.sh
```
### Install c++ desktop in vs
`vm-install-vs-desktop.sh`



https://learn.microsoft.com/en-us/visualstudio/install/use-command-line-parameters-to-install-visual-studio?view=vs-2022

Microsoft.VisualStudio.Workload.NativeDesktop
