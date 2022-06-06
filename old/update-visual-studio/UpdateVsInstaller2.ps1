Write-Host "Update Visual Studio Installer" -ForegroundColor Cyan
$vsCommunityDownloadUrl = "https://download.visualstudio.microsoft.com/download/pr/" + 
#                          "8a973d5d-2ccb-428c-8204-290a15d30e2c/be8c694b12879a8f47f34369d55d453c/" +
                          "5e397ebe-38b2-4e18-a187-ac313d07332a/b5a4cfb2e2bef3f8878f7e36ec20b654f2ea093971c1dd60525cce2dfbbcbc62/"+
#                          "vs_community.exe";
                           "vs_setup.exe";
$vsSetupDirectory = "C:\Program Files (x86)\Microsoft Visual Studio\Shared\Setup";
$vsCommunitySetupPath = "$vsSetupDirectory\vs_setup.exe";
if((Test-Path -Path $vsSetupDirectory) -eq $false){  
  $r = md $vsSetupDirectory
}
if((Test-Path -Path $vsCommunitySetupPath) -eq $false){  
  Write-Host "Downloading VS Setup from $vsCommunityDownloadUrl..." -ForegroundColor Gray  
  (New-Object System.Net.WebClient).DownloadFile($vsCommunityDownloadUrl, $vsCommunitySetupPath);
}
Write-Host "Starting the VS setup to update the VS Installer" -ForegroundColor Gray
$installerUpdateProcess = Start-Process `
  -FilePath $vsCommunitySetupPath `
  -Wait `
  -PassThru `
  -ArgumentList @(
    "--update",
    "--quiet",
    "--wait"

    "modify",
    "--includeRecommended",
    "--norestart",
    "--quiet",
    "--installPath",
    "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community",
    "--add",
    "Microsoft.VisualStudio.Workload.VCTools"
);

$installerUpdateProcess.WaitForExit();
Write-Host "vs_setup.exe exited with code: $($installerUpdateProcess.ExitCode)" -ForegroundColor Gray

