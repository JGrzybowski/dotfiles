# Communications software
cinst slack -Y
choco pin add -n=slack
cinst skype -Y
cinst obs-studio -Y

# Git
cinst git -Y
cinst git-lfs.install -Y
cinst gh -Y

# Terminal customization
cinst nerd-fonts-cascadiacode -Y
cinst poshgit -Y 
cinst oh-my-posh -Y
cinst jetbrainsmononf -Y
cinst terminal-icons.powershell -Y
cinst psake -Y

# General software development
cinst logexpert -Y

# Software for C#/.Net development
cinst jetbrainstoolbox -Y
choco pin add -n=jetbrainstoolbox
cinst azure-cli -Y
cinst azure-data-studio -Y
choco pin add -n=azure-data-studio

# Data analysis/visualization software
cinst python3 -Y
cinst r.project -Y
cinst r.studio -Y

# Node.js development
cinst nodejs -Y

# Java environment
cinst openjdk -Y 

# Docker and Kubernetes
cinst kubernetes-cli -Y
cinst kubernetes-helm -Y
cinst kustomize -Y
cinst flux -Y
cinst Minikube -Y

# Reading Ebooks editing PDFs
cinst adobereader -Y
cinst pdftk -Y
cinst calibre -Y
cinst naps2 -Y

# 2D graphics editors and viewers
cinst irfanview --params="'/assoc=1'"  -Y # IrfanView (1 associates with images only)
cinst irfanviewplugins -Y 
cinst inkscape -Y
cinst paint.net -Y

# 3D graphics editors and viewers
cinst blender -Y
cinst openscad -Y

# 3D printing
cinst cura-new -Y
cinst meshmixer -Y
cinst prusaslicer -Y

# Hardware monitoring (temperatures, frequencies, device identification)
cinst hwinfo -Y
cinst cpu-z.portable -Y
cinst gpu-z -Y

# Mainly drive cleaning and usage tools
cinst wiztree -Y
cinst crystaldiskinfo -Y

cinst teamviewer -Y

# Must have everyday tools
cinst notepadplusplus.install -Y
cinst 7zip.install -Y
cinst keepass.install -Y
cinst keepass-plugin-keepassnatmsg -Y
cinst keepass-plugin-keepassotp -Y

# Audio tools
cinst eartrumpet -Y
cinst equalizerapo -Y

# Peace setup WIP
Invoke-WebRequest `
    -Uri "https://sourceforge.net/projects/peace-equalizer-apo-extension/files/PeaceSetup.exe/download" `
    -OutFile "$PSScriptRoot/temp/PeaceSetup.exe"
Invoke-Expression "$PSScriptRoot/temp/PeaceSetup.exe"

# Useful tools but not everyday use ones
cinst winscp.install -Y
cinst hashcheck -Y
cinst winmerge -Y
cinst doublecmd -Y
cinst powertoys -Y

# Video playback codecs and players
cinst k-litecodecpackfull -Y
