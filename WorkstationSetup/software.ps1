# ==============================================================================
# Windows Workstation Software Setup
# Reads packages and configuration from packages.jsonc
# Primary installer: WinGet | Secondary fallback: Chocolatey | Direct Executable
# ==============================================================================

[CmdletBinding(DefaultParameterSetName = "All")]
param (
    [Parameter(ParameterSetName = "Category", Mandatory = $false, Position = 0, HelpMessage = "Category name(s) to install (e.g. browsers, communications, audioTools)")]
    [Alias("Section", "Categories")]
    [string[]]$Category,

    [Parameter(ParameterSetName = "App", Mandatory = $false, HelpMessage = "Specific application name(s) or package ID(s) to install (e.g. 'Zen Browser', 'git', 'peace')")]
    [Alias("Name", "Package")]
    [string[]]$App,

    [Parameter(ParameterSetName = "List", Mandatory = $false, HelpMessage = "List all available categories and applications in the catalog")]
    [switch]$List
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
if (-not $scriptDir) { $scriptDir = $PSScriptRoot }
. "$scriptDir/PackageHelper.ps1"

$configPath = Join-Path $scriptDir "packages.jsonc"
$catalog = Import-JsoncFile -Path $configPath

# ------------------------------------------------------------------------------
# Mode 1: List all categories & apps
# ------------------------------------------------------------------------------
if ($List) {
    Show-CatalogList -Catalog $catalog
    return
}

# ------------------------------------------------------------------------------
# Mode 2: Install specific application(s) by name or ID
# ------------------------------------------------------------------------------
if ($App) {
    Write-Host "==========================================================" -ForegroundColor Magenta
    Write-Host " Targeted App Installation: $($App -join ', ')" -ForegroundColor Magenta
    Write-Host "==========================================================" -ForegroundColor Magenta

    $matched = Find-CatalogPackages -Catalog $catalog -SearchTerms $App
    if ($matched.Count -eq 0) {
        Write-Error "No matching applications or modules found for: $($App -join ', ')"
        return
    }

    foreach ($entry in $matched) {
        if ($entry.Type -eq 'Module') {
            Install-PSGalleryModule -ModuleName $entry.Name
        } else {
            Install-WorkstationPackage -Package $entry.Item
        }
    }
    Write-Host "`nTargeted installation finished!" -ForegroundColor Green
    return
}

# ------------------------------------------------------------------------------
# Mode 3: Install specific category / categories
# ------------------------------------------------------------------------------
if ($Category) {
    Write-Host "==========================================================" -ForegroundColor Magenta
    Write-Host " Targeted Category Installation: $($Category -join ', ')" -ForegroundColor Magenta
    Write-Host "==========================================================" -ForegroundColor Magenta

    foreach ($cat in $Category) {
        $prop = $catalog.PSObject.Properties | Where-Object { $_.Name -ieq $cat }
        if (-not $prop) {
            Write-Warning "Category '$cat' not found in catalog. Use -List to see available categories."
            continue
        }

        if ($prop.Name -eq 'psModules') {
            Write-Host "`n----------------------------------------------------------" -ForegroundColor DarkCyan
            Write-Host " Category: PowerShell Modules (PSGallery)" -ForegroundColor DarkCyan
            Write-Host "----------------------------------------------------------" -ForegroundColor DarkCyan
            foreach ($mod in $prop.Value) {
                Install-PSGalleryModule -ModuleName $mod
            }
        } else {
            Install-PackageList -CategoryName $prop.Name -Packages $prop.Value
        }
    }
    Write-Host "`nCategory installation finished!" -ForegroundColor Green
    return
}

# ------------------------------------------------------------------------------
# Mode 4: Default - Install Full Workstation Suite
# ------------------------------------------------------------------------------
Write-Host "==========================================================" -ForegroundColor Magenta
Write-Host " Starting Full Workstation Software Installation" -ForegroundColor Magenta
Write-Host " Catalog: packages.jsonc" -ForegroundColor Magenta
Write-Host "==========================================================" -ForegroundColor Magenta

# 1. Web Browsers
Install-PackageList -CategoryName "Web Browsers" -Packages $catalog.browsers

# 2. Communications
Install-PackageList -CategoryName "Communication Software" -Packages $catalog.communications

# 3. Developer Editors & Git
Install-PackageList -CategoryName "Developer Editors, Git & Version Control" -Packages $catalog.devEditorsAndGit

# 4. Terminal Customization & Fonts
Install-PackageList -CategoryName "Terminal Customization & Fonts" -Packages $catalog.terminalAndFonts

# Native PowerShell Modules
if ($catalog.psModules) {
    Write-Host "`n----------------------------------------------------------" -ForegroundColor DarkCyan
    Write-Host " Category: PowerShell Modules (PSGallery)" -ForegroundColor DarkCyan
    Write-Host "----------------------------------------------------------" -ForegroundColor DarkCyan
    foreach ($mod in $catalog.psModules) {
        Install-PSGalleryModule -ModuleName $mod
    }
}

# 5. General Software Development
Install-PackageList -CategoryName "General Software Development" -Packages $catalog.generalDev

# 6. C# / .NET & Azure Cloud Development
Install-PackageList -CategoryName "C# / .NET & Azure Cloud Development" -Packages $catalog.dotnetAndCloud

# 7. Data Analysis & Runtimes
Install-PackageList -CategoryName "Data Analysis & Runtimes" -Packages $catalog.runtimesAndData

# 8. Containers & Kubernetes
Install-PackageList -CategoryName "Containers & Kubernetes" -Packages $catalog.containersAndK8s

# 9. Media & Gaming
Install-PackageList -CategoryName "Media & Gaming" -Packages $catalog.mediaAndGaming

# 10. Document Readers, PDF & Ebooks
Install-PackageList -CategoryName "Document Readers, PDF & Ebooks" -Packages $catalog.documentsAndPdf

# 11. 2D Graphics Editors & Viewers
Install-PackageList -CategoryName "2D Graphics Editors & Viewers" -Packages $catalog.graphics2D

# 12. 3D Graphics & 3D Printing
Install-PackageList -CategoryName "3D Graphics & 3D Printing" -Packages $catalog.graphics3DAndPrinting

# 13. Hardware Monitoring & Diagnostics
Install-PackageList -CategoryName "Hardware Monitoring & Diagnostics" -Packages $catalog.diagnosticsAndHardware

# 14. Disk Utilities & Remote Access
Install-PackageList -CategoryName "Disk Utilities & Remote Access" -Packages $catalog.diskAndRemote

# 15. Everyday Essential Tools
Install-PackageList -CategoryName "Everyday Essential Tools" -Packages $catalog.essentialEveryday

# Dedicated Chocolatey Suite (KeePass base + plugins)
Install-PackageList -CategoryName "KeePass Suite (Chocolatey Dedicated Provider)" -Packages $catalog.keepassSuite

# 16. Audio Tools (EarTrumpet, Equalizer APO, Peace Extension)
Install-PackageList -CategoryName "Audio Tools" -Packages $catalog.audioTools

# 17. General Utilities & File Management
Install-PackageList -CategoryName "General Utilities & File Management" -Packages $catalog.generalUtilities

Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host " Workstation software installation complete!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
