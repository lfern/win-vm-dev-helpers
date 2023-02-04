#!/bin/bash
set -e

if [ "M$2" == "M" ]; then
    echo "Uso: `basename $0` agent-name agent-secret"
    exit -1
fi

NAME=$1
SECRET=$2
MYTMPFILE="$(mktemp)"
trap 'rm -f -- "$MYTMPFILE"' EXIT

cat <<EOF > "$MYTMPFILE"
<service>
  <id>jenkins-windows-agent</id>
  <name>Jenkins Agent for Windows</name>
  <description>This service runs the agent process connected to jenkins:8080</description>
  <executable>c:\tools\jdk-11.0.18+10\bin\java.exe</executable>
  <arguments>-jar c:\tools\jenkins-agent\agent.jar -jnlpUrl $VM_DEV_JENKINS_URL/computer/$NAME/jenkins-agent.jnlp -secret $SECRET -workDir "c:\tools\jenkins-agent"</arguments>
  <log mode="roll" />
  <onfailure action="restart" />
    <serviceaccount>
    <user>User</user>
    <password>Demo</password>
    <allowservicelogon>true</allowservicelogon>
  </serviceaccount>
</service>
EOF
cat $MYTMPFILE
VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" if not exist c:\\tools mkdir c:\\tools

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" if not exist c:\\tools\\jenkins-agent mkdir c:\\tools\\jenkins-agent

#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe -command "\$ProgressPreference = 'SilentlyContinue';Invoke-WebRequest https://aka.ms/download-jdk/microsoft-jdk-11.0.18-windows-x64.zip -OutFile c:\tools\microsoft-jdk-11.0.18-windows-x64.zip"

#VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe -command "Add-Type -Assembly 'System.IO.Compression.Filesystem';[System.IO.Compression.ZipFile]::ExtractToDirectory('c:\\tools\\microsoft-jdk-11.0.18-windows-x64.zip', 'c:\\tools')"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe -command "\$ProgressPreference = 'SilentlyContinue';Invoke-WebRequest https://github.com/winsw/winsw/releases/download/v3.0.0-alpha.11/WinSW-x64.exe -OutFile c:\tools\jenkins-agent\jenkins-agent.exe"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" copyto "$MYTMPFILE" --target-directory "c:\\tools\\jenkins-agent\\jenkins-agent.xml"

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" powershell.exe -command "\$ProgressPreference = 'SilentlyContinue';Invoke-WebRequest $VM_DEV_JENKINS_URL/jnlpJars/agent.jar -OutFile c:\tools\jenkins-agent\agent.jar"

set +e

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" c:\\tools\\jenkins-agent\\jenkins-agent.exe install

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" c:\\tools\\jenkins-agent\\jenkins-agent.exe start

VBoxManage guestcontrol "$VM_DEV_MACHINE" --username "$VM_DEV_USER" --password "$VM_DEV_PASS" run --exe "cmd.exe" -- "cmd.exe" "/c" c:\\tools\\jenkins-agent\\jenkins-agent.exe status


enable powershell execution