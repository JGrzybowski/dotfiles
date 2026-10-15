@echo off
setlocal
cd /d "%~dp0"

echo ====================================================================
echo Windows Workstation Setup (WinGet Primary + Chocolatey Fallback)
echo ====================================================================

:: Prefer PowerShell 7 (pwsh) if installed, fallback to Windows PowerShell 5.1
set "PS_EXE=pwsh.exe"
where %PS_EXE% >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    if exist "%ProgramFiles%\PowerShell\7\pwsh.exe" (
        set "PS_EXE=%ProgramFiles%\PowerShell\7\pwsh.exe"
    ) else (
        set "PS_EXE=%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe"
    )
)

echo Using shell: %PS_EXE%

echo [1/2] Installing workstation software, browsers, dev tools, and apps...
"%PS_EXE%" -NoProfile -NoLogo -ExecutionPolicy Bypass -File "software.ps1"

echo [2/2] Installing Visual Studio Code extensions...
"%PS_EXE%" -NoProfile -NoLogo -ExecutionPolicy Bypass -File "Software\VSCode\installExtensions.ps1"

echo ====================================================================
echo Workstation Setup Completed!
echo ====================================================================
pause
