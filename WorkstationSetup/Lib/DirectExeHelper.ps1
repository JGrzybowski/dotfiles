# ==============================================================================
# Direct Executable Download & Checksum Helper
# Handles downloading .exe installers, SHA-256 verification, and silent execution.
# ==============================================================================

function Install-ViaDirectExecutable {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        $Package,

        [Parameter(Mandatory = $false)]
        [string]$TempDir = "$PSScriptRoot/../temp"
    )

    $name = if ($Package.name) { $Package.name } else { "Direct Executable" }
    $url = $Package.url
    $sha256 = $Package.sha256
    $fileName = $Package.fileName

    if (-not $fileName) {
        try {
            $uri = [System.Uri]$url
            $base = Split-Path -Leaf $uri.AbsolutePath
            $fileName = if ($base -and $base.EndsWith(".exe", [System.StringComparison]::OrdinalIgnoreCase)) { $base } else { "$($name -replace '[^\w\d]', '').exe" }
        } catch {
            $fileName = "$($name -replace '[^\w\d]', '').exe"
        }
    }

    if (!(Test-Path $TempDir)) {
        New-Item -ItemType Directory -Force -Path $TempDir | Out-Null
    }

    $targetFile = Join-Path $TempDir $fileName
    Write-Host "  -> Downloading $fileName from $url..." -ForegroundColor Gray

    try {
        Invoke-WebRequest -Uri $url -OutFile $targetFile

        # SHA-256 Checksum Verification
        if ($sha256) {
            Write-Host "  -> Verifying SHA-256 checksum..." -ForegroundColor Gray
            $actualSha256 = (Get-FileHash -Path $targetFile -Algorithm SHA256).Hash.ToLower()
            if ($actualSha256 -ne $sha256.ToLower()) {
                Remove-Item -Path $targetFile -Force -ErrorAction SilentlyContinue
                throw "SHA-256 checksum mismatch for $fileName!`n  Expected: $sha256`n  Actual:   $actualSha256`n  The downloaded file was deleted for security."
            }
            Write-Host "  [OK] SHA-256 checksum verified successfully ($actualSha256)." -ForegroundColor Green
        }

        Write-Host "  -> Launching installer: $fileName..." -ForegroundColor Gray
        $argList = if ($Package.installerArgs) { $Package.installerArgs -split ' ' } else { @() }
        $proc = Start-Process -FilePath $targetFile -ArgumentList $argList -Wait -PassThru
        if ($proc.ExitCode -eq 0 -or $null -eq $proc.ExitCode) {
            Write-Host "  [OK] Successfully executed $name." -ForegroundColor Green
            return $true
        } else {
            Write-Host "  [OK] $name process exited with code $($proc.ExitCode)." -ForegroundColor Gray
            return $true
        }
    } catch {
        Write-Error "  [FAIL] Failed to install $name via direct executable: $_"
        return $false
    }
}
