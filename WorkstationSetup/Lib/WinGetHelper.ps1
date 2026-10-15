# ==============================================================================
# WinGet Package Management Helper
# Handles verification, silent installation, return codes, and pinning in WinGet.
# ==============================================================================

function Ensure-WinGet {
    [CmdletBinding()]
    param()

    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        $wingetAppPath = Join-Path $env:LOCALAPPDATA "Microsoft\WindowsApps"
        if (Test-Path (Join-Path $wingetAppPath "winget.exe")) {
            $env:PATH = "$wingetAppPath;$env:PATH"
        }
    }

    if (Get-Command winget -ErrorAction SilentlyContinue) {
        return $true
    } else {
        Write-Warning "WinGet CLI ('winget') is not available in PATH or WindowsApps."
        Write-Warning "Ensure Windows 'App Installer' is installed from Microsoft Store or GitHub."
        return $false
    }
}

function Install-ViaWinGet {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Package
    )

    if (-not (Ensure-WinGet)) {
        return $false
    }

    $id = $Package.winget
    $name = if ($Package.name) { $Package.name } else { $id }
    Write-Host "  -> Attempting install via WinGet: $id..." -ForegroundColor Gray

    $argList = @(
        "install",
        "--id", $id,
        "--exact",
        "--accept-package-agreements",
        "--accept-source-agreements",
        "--silent"
    )
    if ($Package.wingetArgs) {
        $argList += ($Package.wingetArgs -split ' ')
    }

    $process = Start-Process -FilePath "winget" -ArgumentList $argList -NoNewWindow -Wait -PassThru
    $exitCode = $process.ExitCode

    # Return codes: 0 (Success), -1978335189 (Already installed), -1978335165 (No update available)
    if ($exitCode -eq 0 -or $exitCode -eq -1978335189 -or $exitCode -eq -1978335165 -or $exitCode -eq -1978335215) {
        Write-Host "  [OK] Successfully installed/verified via WinGet ($id)." -ForegroundColor Green

        if ([bool]$Package.pin) {
            Write-Host "  -> Pinning $id in WinGet to prevent automatic upgrade conflicts..." -ForegroundColor Gray
            Start-Process -FilePath "winget" -ArgumentList @("pin", "add", "--id", $id) -NoNewWindow -Wait
        }
        return $true
    }

    Write-Warning "  [WARN] WinGet installation for '$name' exited with code $exitCode."
    return $false
}
