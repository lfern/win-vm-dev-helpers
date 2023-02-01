#!/bin/sh
set -e

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" mkdir c:\\tools

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" mkdir c:\\tools\\jenkins-agent

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe -command "\$ProgressPreference = 'SilentlyContinue';Invoke-WebRequest https://aka.ms/download-jdk/microsoft-jdk-11.0.18-windows-x64.zip -OutFile c:\\tools\\"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe -command "Add-Type -Assembly 'System.IO.Compression.Filesystem';[System.IO.Compression.ZipFile]::ExtractToDirectory('c:\\tools\\microsoft-jdk-11.0.18-windows-x64.zip', 'c:\\tools')
"


