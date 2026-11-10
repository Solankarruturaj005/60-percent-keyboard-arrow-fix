<#
.SYNOPSIS
    Uninstaller for 60% Keyboard Navigation & Arrow Fix
.DESCRIPTION
    Stops the active AutoHotkey navigation process and removes the script from Startup.
#>

[CmdletBinding()]
param()

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  60% Keyboard Navigation Fix - Uninstaller               " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Stop any running instances
Write-Host "[*] Stopping running navigation processes..." -ForegroundColor Cyan
$stopped = 0
Get-Process -Name "AutoHotkey*" -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        $cmdLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
        if ($cmdLine -match "60percent_navigation" -or $cmdLine -match "MK1500_Navigation") {
            Stop-Process -Id $_.Id -Force
            $stopped++
            Write-Host "    Terminated process ID: $($_.Id)" -ForegroundColor Gray
        }
    } catch {}
}

if ($stopped -eq 0) {
    Write-Host "    No running instances found." -ForegroundColor Gray
}

# 2. Remove from Startup
$startupFolder = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Startup)
$targets = @(
    (Join-Path $startupFolder "60percent_navigation.ahk"),
    (Join-Path $startupFolder "MK1500_Navigation.ahk")
)

foreach ($target in $targets) {
    if (Test-Path $target) {
        Remove-Item -Path $target -Force
        Write-Host "[+] Removed from Startup: $target" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  Successfully uninstalled. Normal keyboard behavior restored." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
