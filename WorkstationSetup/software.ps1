# Communications software
cinst slack -Y
choco pin add -n=slack
cinst skype -Y

# General software development
cinst poshgit -Y 

# Software for C#/.Net development
cinst jetbrainstoolbox -Y
choco pin add -n=jetbrainstoolbox

# Data analysis/visualization software
cinst python2 -Y
cinst python3 -Y
cinst r.project -Y
cinst r.studio -Y

# Node.js development
cinst nodejs -Y
cinst yarn -Y

# Java environment
cinst openjdk -Y 

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

# 3D printing
cinst cura-new -Y
cinst meshmixer -Y

# Hardware monitoring (temperatures, frequencies, device identification)
cinst hwinfo -Y
cinst cpu-z.portable -Y
cinst gpu-z -Y

# Mainly drive cleaning and usage tools
cinst windirstat -Y
cinst ccleaner -Y
cinst defraggler -Y
cinst crystaldiskinfo -Y

cinst teamviewer -Y
# Must have everyday tools
cinst notepadplusplus.install -Y
cinst f.lux -Y
cinst 7zip.install -Y
cinst keepass.install -Y
cinst keepass-plugin-keepassnatmsg -Y
cinst eartrumpet -Y

# Useful tools but not everyday use ones
cinst winscp.install -Y
cinst hashcheck -Y
cinst winmerge -Y
cinst doublecmd -Y
cinst powertoys -Y

# Video playback codecs and players
cinst k-litecodecpackfull -Y
