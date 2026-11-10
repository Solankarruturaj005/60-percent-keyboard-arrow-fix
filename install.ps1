<#
.SYNOPSIS
    1-Click Installer for 60% Keyboard Navigation & Arrow Fix
.DESCRIPTION
    Installs AutoHotkey v2 (if missing via winget), registers the navigation script
    into the Windows Startup folder, and starts the layer immediately.
    Supports both local execution and remote one-liner execution:
    irm https://raw.githubusercontent.com/Solankarruturaj005/60-percent-keyboard-arrow-fix/main/install.ps1 | iex
#>

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  60% Keyboard Navigation & Productivity Fix Installer    " -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Locate or Install AutoHotkey v2
function Get-AHKExecutable {
    $candidates = @(
        "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey64.exe",
        "$env:LOCALAPPDATA\Programs\AutoHotkey\v2\AutoHotkey32.exe",
        "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe",
        "C:\Program Files\AutoHotkey\v2\AutoHotkey32.exe"
    )

    foreach ($path in $candidates) {
        if (Test-Path $path) {
            return $path
        }
    }

    $cmd = Get-Command AutoHotkey64.exe, AutoHotkey.exe, AutoHotkey32.exe -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($cmd) {
        return $cmd.Source
    }

    return $null
}

$ahkExe = Get-AHKExecutable

if (-not $ahkExe) {
    Write-Host "[*] AutoHotkey v2 not detected. Installing via winget..." -ForegroundColor Cyan
    try {
        winget install --id AutoHotkey.AutoHotkey -e --accept-package-agreements --accept-source-agreements --silent
        Start-Sleep -Seconds 2
        $ahkExe = Get-AHKExecutable
    } catch {
        Write-Warning "winget installation encountered an issue: $_"
    }

    if (-not $ahkExe) {
        Write-Error "Could not find or install AutoHotkey v2. Please install it manually from https://www.autohotkey.com/"
        return
    }
}

Write-Host "[+] Found AutoHotkey v2 at: $ahkExe" -ForegroundColor Green

# 2. Determine Script Source (Local or Remote)
$startupFolder = [System.Environment]::GetFolderPath([System.Environment+SpecialFolder]::Startup)
$destination = Join-Path $startupFolder "60percent_navigation.ahk"

$localSource = $null
if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "60percent_navigation.ahk"))) {
    $localSource = Join-Path $PSScriptRoot "60percent_navigation.ahk"
} elseif (Test-Path ".\60percent_navigation.ahk") {
    $localSource = (Resolve-Path ".\60percent_navigation.ahk").Path
}

if ($localSource) {
    Write-Host "[*] Installing from local repository..." -ForegroundColor Cyan
    Copy-Item -Path $localSource -Destination $destination -Force
} else {
    Write-Host "[*] Fetching latest 60percent_navigation.ahk from GitHub..." -ForegroundColor Cyan
    $rawUrl = "https://raw.githubusercontent.com/Solankarruturaj005/60-percent-keyboard-arrow-fix/main/60percent_navigation.ahk"
    Invoke-RestMethod -Uri $rawUrl -OutFile $destination
}

Write-Host "[+] Installed to: $destination" -ForegroundColor Green

# 3. Stop older running instances
Write-Host "[*] Refreshing running navigation instances..." -ForegroundColor Cyan
Get-Process -Name "AutoHotkey*" -ErrorAction SilentlyContinue | ForEach-Object {
    try {
        $cmdLine = (Get-CimInstance Win32_Process -Filter "ProcessId = $($_.Id)").CommandLine
        if ($cmdLine -match "60percent_navigation" -or $cmdLine -match "MK1500_Navigation") {
            Stop-Process -Id $_.Id -Force
            Write-Host "    Stopped prior instance (PID: $($_.Id))" -ForegroundColor Gray
        }
    } catch {}
}

# 4. Launch the Script
Write-Host "[*] Starting the navigation layer..." -ForegroundColor Cyan
Start-Process -FilePath $ahkExe -ArgumentList "`"$destination`""
Start-Sleep -Milliseconds 500

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Green
Write-Host "  Installation Successful! The layer is now active!       " -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Quick Cheatsheet (Hold CapsLock):" -ForegroundColor Yellow
Write-Host "  CapsLock + I / J / K / L  ->  Up / Left / Down / Right (Home Row)"
Write-Host "  CapsLock + W / A / S / D  ->  Up / Left / Down / Right (WASD)"
Write-Host "  CapsLock + 1 .. =         ->  F1 .. F12 (Function Row)"
Write-Host "  CapsLock + [ / ] / \      ->  Vol- / Vol+ / Mute"
Write-Host "  CapsLock + Esc            ->  Backtick (`) / Tilde (~)"
Write-Host "  CapsLock + U / O          ->  Home / End"
Write-Host "  CapsLock + H / N          ->  PageUp / PageDown"
Write-Host "  CapsLock + Backspace      ->  Delete"
Write-Host "  Tap CapsLock alone        ->  Toggle CapsLock (shows Windows 11 translucent pill)"
Write-Host ""
Write-Host "You never need to hold Fn+O again! Enjoy coding." -ForegroundColor Cyan
Write-Host ""
