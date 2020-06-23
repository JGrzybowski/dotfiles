#Installs all dev packages
cinst poshgit -Y 
& "$PSScriptRoot\dev.ps1"
& "$PSScriptRoot\dev_cs.ps1"
& "$PSScriptRoot\dev_data.ps1"
