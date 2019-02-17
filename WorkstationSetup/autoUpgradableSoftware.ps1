$url = "https://ninite.com/chrome-operaChromium-steam-vscode/ninite.exe"
$outpath = "$PSScriptRoot/temp/InstallAutoUpgradableSoftware.exe"
$path = "$PSScriptRoot/temp"

If(!(test-path $path))
{
  New-Item -ItemType Directory -Force -Path $path
}

"Downloading the Ninite installer"
Invoke-WebRequest -Uri $url -OutFile $outpath
"Download finished"
"I will install software"
Start-Process -Filepath "$PSScriptRoot/temp/InstallAutoUpgradableSoftware.exe"
"Installation Finished!"