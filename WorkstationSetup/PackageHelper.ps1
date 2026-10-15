# ==============================================================================
# Workstation Package Helper (Facade)
# Imports provider subroutines from Lib/ and dispatches package installations.
# ==============================================================================

# Automatically import all provider and catalog subroutines from Lib/
$libDir = Join-Path $PSScriptRoot "Lib"
if (Test-Path $libDir) {
    Get-ChildItem -Path (Join-Path $libDir "*.ps1") | ForEach-Object {
        . $_.FullName
    }
} else {
    Write-Error "Lib directory not found at $libDir"
}

# ------------------------------------------------------------------------------
# Main Dispatcher: Routes package object to WinGet -> Chocolatey -> Direct Exe
# ------------------------------------------------------------------------------
function Install-WorkstationPackage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        $Package
    )

    $name = if ($Package.name) { $Package.name } elseif ($Package.winget) { $Package.winget } elseif ($Package.choco) { $Package.choco } else { "Unnamed Package" }
    Write-Host "`n>>> Processing package: $name" -ForegroundColor Cyan

    # If it is purely a direct executable download (no winget or choco specified)
    if ($Package.url -and -not $Package.winget -and -not $Package.choco) {
        return (Install-ViaDirectExecutable -Package $Package)
    }

    # 1. Primary: WinGet
    if ($Package.winget) {
        $success = Install-ViaWinGet -Package $Package
        if ($success) { return $true }
    }

    # 2. Secondary: Chocolatey Fallback
    if ($Package.choco) {
        $success = Install-ViaChocolatey -Package $Package
        if ($success) { return $true }
    }

    # 3. Tertiary: Direct Executable Fallback (if WinGet and Choco both failed)
    if ($Package.url) {
        Write-Host "  -> Falling back to Direct Executable download for $name..." -ForegroundColor Yellow
        return (Install-ViaDirectExecutable -Package $Package)
    }

    Write-Error "  [FAIL] All installation methods failed for '$name'."
    return $false
}

# ------------------------------------------------------------------------------
# Category Runner: Iterates over any package array from packages.jsonc
# ------------------------------------------------------------------------------
function Install-PackageList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [string]$CategoryName,

        [Parameter(Mandatory = $true)]
        $Packages
    )

    if ($CategoryName) {
        Write-Host "`n----------------------------------------------------------" -ForegroundColor DarkCyan
        Write-Host " Category: $CategoryName" -ForegroundColor DarkCyan
        Write-Host "----------------------------------------------------------" -ForegroundColor DarkCyan
    }

    foreach ($item in $Packages) {
        if ($null -ne $item.enabled -and -not [bool]$item.enabled) {
            Write-Host "Skipping disabled package: $($item.name)" -ForegroundColor DarkGray
            continue
        }

        Install-WorkstationPackage -Package $item
    }
}
