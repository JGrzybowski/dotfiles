# ==============================================================================
# Chocolatey Package Management Helper
# Handles Chocolatey bootstrapping, installation, return codes, and pinning.
# ==============================================================================

function Ensure-Chocolatey {
    [CmdletBinding()]
    param()

    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        $chocoBin = "$env:ALLUSERSPROFILE\chocolatey\bin"
        if (Test-Path (Join-Path $chocoBin "choco.exe")) {
            $env:PATH = "$chocoBin;$env:PATH"
            return $true
        }

        Write-Host "Chocolatey is required for fallback package(s). Bootstrapping Chocolatey..." -ForegroundColor Cyan
        try {
            Set-ExecutionPolicy Bypass -Scope Process -Force
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
            $env:PATH = "$chocoBin;$env:PATH"
            return $true
        } catch {
            Write-Error "Failed to install Chocolatey: $_"
            return $false
        }
    }
    return $true
}

function Install-ViaChocolatey {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Package
    )

    if (-not (Ensure-Chocolatey)) {
        Write-Error "  [FAIL] Chocolatey could not be prepared for '$($Package.name)'."
        return $false
    }

    $id = $Package.choco
    $name = if ($Package.name) { $Package.name } else { $id }
    Write-Host "  -> Attempting install via Chocolatey: $id..." -ForegroundColor Yellow

    $argList = @("install", $id, "-y")
    if ($Package.chocoArgs) {
        $argList += ($Package.chocoArgs -split ' ')
    }

    $chocoProc = Start-Process -FilePath "choco" -ArgumentList $argList -NoNewWindow -Wait -PassThru
    if ($chocoProc.ExitCode -eq 0 -or $chocoProc.ExitCode -eq 1641 -or $chocoProc.ExitCode -eq 3010) {
        Write-Host "  [OK] Successfully installed via Chocolatey ($id)." -ForegroundColor Green

        if ([bool]$Package.pin) {
            Write-Host "  -> Pinning $id in Chocolatey..." -ForegroundColor Gray
            Start-Process -FilePath "choco" -ArgumentList @("pin", "add", "-n=$id") -NoNewWindow -Wait
        }
        return $true
    }

    Write-Error "  [FAIL] Chocolatey failed to install '$name' (exit code $($chocoProc.ExitCode))."
    return $false
}
