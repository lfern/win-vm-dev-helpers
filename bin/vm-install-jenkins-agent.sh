#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. "$SCRIPT_DIR/vm-lib.sh"

set -e

if [ "M$2" == "M" ]; then
    echo "Uso: $(basename "$0") agent-name agent-secret"
    exit 1
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
cat "$MYTMPFILE"

vm_run if not exist c:\\tools mkdir c:\\tools

vm_run if not exist c:\\tools\\jenkins-agent mkdir c:\\tools\\jenkins-agent

java_installed=$(vm_run \if EXIST c:\\tools\\jdk-11.0.18+10 echo 1)

if [ "M$java_installed" != "M1" ]; then
  vm_run powershell.exe -command "\$ProgressPreference = 'SilentlyContinue';Invoke-WebRequest https://aka.ms/download-jdk/microsoft-jdk-11.0.18-windows-x64.zip -OutFile c:\tools\microsoft-jdk-11.0.18-windows-x64.zip"

  vm_run powershell.exe -command "Add-Type -Assembly 'System.IO.Compression.Filesystem';[System.IO.Compression.ZipFile]::ExtractToDirectory('c:\\tools\\microsoft-jdk-11.0.18-windows-x64.zip', 'c:\\tools')"
fi

vm_run powershell.exe -command "\$ProgressPreference = 'SilentlyContinue';Invoke-WebRequest https://github.com/winsw/winsw/releases/download/v3.0.0-alpha.11/WinSW-x64.exe -OutFile c:\tools\jenkins-agent\jenkins-agent.exe"

vm_copyto "$MYTMPFILE" "c:\\tools\\jenkins-agent\\jenkins-agent.xml"

vm_run powershell.exe -command "\$ProgressPreference = 'SilentlyContinue';Invoke-WebRequest $VM_DEV_JENKINS_URL/jnlpJars/agent.jar -OutFile c:\tools\jenkins-agent\agent.jar"

set +e

vm_powershell "Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service"

vm_run c:\\tools\\jenkins-agent\\jenkins-agent.exe install

vm_run sc.exe config "jenkins-windows-agent" obj= ".\\$VM_DEV_USER" password= "$VM_DEV_PASS" type= own

vm_run c:\\tools\\jenkins-agent\\jenkins-agent.exe start

vm_run c:\\tools\\jenkins-agent\\jenkins-agent.exe status
