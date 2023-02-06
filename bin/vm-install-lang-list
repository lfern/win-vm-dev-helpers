#!/bin/bash

#Maybe this should be executed when user logged
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe Set-WinUserLanguageList -LanguageList "es-ES", "en-US" -Force
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe Install-Language -Language es-ES -CopyToSettings

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe Set-WinDefaultInputMethodOverride -InputTip "0c0a:0000040a"
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_ADMINUSER" --password "$VM_DEV_ADMINPASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe Set-WinDefaultInputMethodOverride -InputTip "0c0a:0000040a"
