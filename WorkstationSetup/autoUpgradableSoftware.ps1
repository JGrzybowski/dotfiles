﻿$softwareList = @(
  "chrome",
  "operaChromium",
  "vscode",
  "spotify",
  "steam",
  "discord",
  "zoom"
)

$softwareList = $softwareList -join "-"

$url = "https://ninite.com/$softwareList/ninite.exe"
$exeInstallerFilePath = "$PSScriptRoot/temp/InstallAutoUpgradableSoftware.exe"
$path = "$PSScriptRoot/temp"

If (!(test-path $path)) {
  New-Item -ItemType Directory -Force -Path $path
}

"Downloading the Ninite installer"
Invoke-WebRequest -Uri $url -OutFile $exeInstallerFilePath
"Download finished"
"I will install software"
Start-Process -Filepath $exeInstallerFilePath
"Installation Finished!"
