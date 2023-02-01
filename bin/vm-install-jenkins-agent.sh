#!/bin/sh
set -e

#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" if not exist c:\\tools mkdir c:\\tools

#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" if not exist c:\\tools\\jenkins-agent mkdir c:\\tools\\jenkins-agent

#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe -command "\$ProgressPreference = 'SilentlyContinue';Invoke-WebRequest https://aka.ms/download-jdk/microsoft-jdk-11.0.18-windows-x64.zip -OutFile c:\tools\microsoft-jdk-11.0.18-windows-x64.zip"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe -command "\$ProgressPreference = 'SilentlyContinue';Invoke-WebRequest https://github.com/winsw/winsw/releases/download/v3.0.0-alpha.11/WinSW-x64.exe -OutFile c:\tools\jenkins-agent\jenkins-agent.exe"

#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe -command "Add-Type -Assembly 'System.IO.Compression.Filesystem';[System.IO.Compression.ZipFile]::ExtractToDirectory('c:\\tools\\microsoft-jdk-11.0.18-windows-x64.zip', 'c:\\tools')"


#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe -command "\$ProgressPreference = 'SilentlyContinue';Invoke-WebRequest http://192.168.0.11:8001/jnlpJars/agent.jar -OutFile c:\tools\jenkins-agent\agent.jar"


