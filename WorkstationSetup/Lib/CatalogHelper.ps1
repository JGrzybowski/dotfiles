# ==============================================================================
# Catalog & PowerShell Module Helper
# Handles loading packages.jsonc, searching apps, listing categories, and PS modules.
# ==============================================================================

function Import-JsoncFile {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "Cannot find JSONC file at: $Path"
    }

    $raw = Get-Content -Path $Path -Raw
    # Strip multi-line comments /* ... */ and single-line comments // ... or # ...
    $clean = $raw -replace '(?s)/\*.*?\*/', '' -replace '(?m)^\s*(//|#).*$', ''
    return ($clean | ConvertFrom-Json)
}

function Install-PSGalleryModule {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ModuleName
    )

    Write-Host "`n>>> Processing PowerShell Module: $ModuleName" -ForegroundColor Cyan
    try {
        $repo = Get-PSRepository -Name 'PSGallery' -ErrorAction SilentlyContinue
        if ($repo -and $repo.InstallationPolicy -ne 'Trusted') {
            Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted -ErrorAction SilentlyContinue
        }

        if (-not (Get-Module -ListAvailable -Name $ModuleName)) {
            Write-Host "  -> Installing module '$ModuleName' from PSGallery..." -ForegroundColor Gray
            Install-Module -Name $ModuleName -Scope CurrentUser -Force -SkipPublisherCheck -AllowClobber
            Write-Host "  [OK] Module '$ModuleName' installed successfully." -ForegroundColor Green
        } else {
            Write-Host "  [OK] Module '$ModuleName' is already installed." -ForegroundColor Green
        }
    } catch {
        Write-Warning "  [WARN] Failed to install PowerShell module '$ModuleName': $_"
    }
}

function Show-CatalogList {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Catalog
    )

    Write-Host "`n==========================================================" -ForegroundColor Magenta
    Write-Host " Available Package Categories & Applications" -ForegroundColor Magenta
    Write-Host "==========================================================" -ForegroundColor Magenta

    foreach ($prop in $Catalog.PSObject.Properties) {
        if ($prop.Name -eq 'psModules') {
            Write-Host "`n[$($prop.Name)] (PowerShell Modules)" -ForegroundColor DarkCyan
            foreach ($mod in $prop.Value) {
                Write-Host "  * $mod" -ForegroundColor Gray
            }
        } elseif ($prop.Value -is [System.Collections.IEnumerable] -and $prop.Value -isnot [string]) {
            Write-Host "`n[$($prop.Name)]" -ForegroundColor DarkCyan
            foreach ($item in $prop.Value) {
                $status = if ($null -ne $item.enabled -and -not [bool]$item.enabled) { " (disabled)" } else { "" }
                $pin = if ([bool]$item.pin) { " [pinned]" } else { "" }

                if ($item.url) {
                    $hashShort = if ($item.sha256) { " | SHA-256: $($item.sha256.Substring(0,12))..." } else { "" }
                    $fn = if ($item.fileName) { $item.fileName } else { "direct download" }
                    Write-Host "  * $($item.name)$pin$status (direct: $fn$hashShort)" -ForegroundColor Gray
                } else {
                    $winget = if ($item.winget) { "winget: $($item.winget)" } else { "winget: N/A" }
                    $choco = if ($item.choco) { "choco: $($item.choco)" } else { "choco: N/A" }
                    Write-Host "  * $($item.name)$pin$status ($winget | $choco)" -ForegroundColor Gray
                }
            }
        }
    }
    Write-Host "`n----------------------------------------------------------" -ForegroundColor DarkGray
    Write-Host "CLI Usage Examples:" -ForegroundColor Yellow
    Write-Host "  ./software.ps1 -Category browsers" -ForegroundColor Gray
    Write-Host "  ./software.ps1 -Category audioTools" -ForegroundColor Gray
    Write-Host "  ./software.ps1 -App 'Zen Browser'" -ForegroundColor Gray
    Write-Host "  ./software.ps1 -App peace" -ForegroundColor Gray
    Write-Host "  ./software.ps1 -App git" -ForegroundColor Gray
    Write-Host "  ./software.ps1 -List" -ForegroundColor Gray
    Write-Host "  ./software.ps1                            (installs everything)`n" -ForegroundColor Gray
}

function Find-CatalogPackages {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Catalog,

        [Parameter(Mandatory = $true)]
        [string[]]$SearchTerms
    )

    $results = @()
    foreach ($term in $SearchTerms) {
        $foundForTerm = 0

        foreach ($prop in $Catalog.PSObject.Properties) {
            if ($prop.Name -eq 'psModules') {
                foreach ($mod in $prop.Value) {
                    if ($mod -like "*$term*" -or $mod -eq $term) {
                        $results += [PSCustomObject]@{
                            Category = $prop.Name
                            Type     = 'Module'
                            Name     = $mod
                        }
                        $foundForTerm++
                    }
                }
            } elseif ($prop.Value -is [System.Collections.IEnumerable] -and $prop.Value -isnot [string]) {
                foreach ($item in $prop.Value) {
                    $matchesName = $item.name -and ($item.name -like "*$term*")
                    $matchesWinget = $item.winget -and ($item.winget -like "*$term*")
                    $matchesChoco = $item.choco -and ($item.choco -like "*$term*")
                    $matchesFileName = $item.fileName -and ($item.fileName -like "*$term*")

                    if ($matchesName -or $matchesWinget -or $matchesChoco -or $matchesFileName) {
                        $results += [PSCustomObject]@{
                            Category = $prop.Name
                            Type     = 'Package'
                            Item     = $item
                        }
                        $foundForTerm++
                    }
                }
            }
        }
        if ($foundForTerm -eq 0) {
            Write-Warning "No package or module matched query: '$term'"
        }
    }
    return $results
}
