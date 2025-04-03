# Function to scan for files
function Scan-Files {
    param (
        [string]$path,
        [string]$extension
    )
    return Get-ChildItem -Path $path -Recurse -Filter $extension -ErrorAction SilentlyContinue | Select-Object -ExpandProperty FullName
}

function Check-ModDate {
    param (
        [string]$path,
        [string]$desc
    )
    if (Test-Path $path) {
        Write-Host "`n[!] checking $desc..." -ForegroundColor Green
        
        # Get all folders sorted by last write time
        $allFolders = Get-ChildItem -Path $path -Directory | Sort-Object LastWriteTime -Descending
        
        if ($allFolders) {
            foreach ($folder in $allFolders) {
                Write-Host "`n[!] Found folder: $($folder.Name)" -ForegroundColor Yellow
                Write-Host "Last modified: $($folder.LastWriteTime)" -ForegroundColor Cyan
                
                # Get all files in the folder sorted by last write time
                $files = Get-ChildItem -Path $folder.FullName -File | Sort-Object LastWriteTime -Descending
                foreach ($file in $files) {
                    Write-Host "[$($file.LastWriteTime)] $($file.Name)" -ForegroundColor Green
                }
            }
        }
        
        # Check for files in the root path
        $rootFiles = Get-ChildItem -Path $path -File | Sort-Object LastWriteTime -Descending
        if ($rootFiles) {
            Write-Host "`nFiles in root folder:" -ForegroundColor Cyan
            foreach ($file in $rootFiles) {
                Write-Host "[$($file.LastWriteTime)] $($file.Name)" -ForegroundColor Green
            }
        }
        
        return $true
    }
    Write-Host "`n$desc path not found" -ForegroundColor Red
    return $false
}

function Show-Menu {
    Clear-Host
    Write-Host "=== Macro Checker ===" -ForegroundColor Cyan
    Write-Host "made by pace"
    Write-Host "github: github.com/httpace"
    Write-Host
    Write-Host "1. Check AutoHotkey scripts"
    Write-Host "2. Check AutoIt scripts"
    Write-Host "3. Check Ajazz/Glorious"
    Write-Host "4. Check ASUS ROG"
    Write-Host "5. Check Blackweb"
    Write-Host "6. Check Bloody7"
    Write-Host "7. Check Coolermaster"
    Write-Host "8. Check Corsair"
    Write-Host "9. Check Redragon"
    Write-Host "10. Check Noganet"
    Write-Host "11. Check Krom"
    Write-Host "12. Check Roccat"
    Write-Host "13. Check Running Processes"
    Write-Host "14. Check All"
    Write-Host "Q. Quit"
    Write-Host
    Write-Host "Enter your choice (1-14 or Q): " -NoNewline
}

function Check-AutoHotkey {
    $PcaSvcStatus = Get-Service -Name "PcaSvc" -ErrorAction SilentlyContinue
    if ($PcaSvcStatus.Status -eq "Running") {
        Write-Host "`nlooking for AHK scripts..." -ForegroundColor Green
        
        # Ask for custom directory
        Write-Host "`nWant to check a specific directory? (default is C:\Users)" -ForegroundColor Yellow
        Write-Host "Enter directory path or press Enter for default: " -NoNewline
        $customPath = Read-Host
        $searchPath = if ($customPath -and (Test-Path $customPath)) { $customPath } else { "C:\Users" }
        
        # Ask about subdirectories
        Write-Host "`nCheck subdirectories? (Y/N): " -NoNewline
        $checkSubdirs = (Read-Host) -eq 'Y'
        
        Write-Host "`nSearching in: $searchPath" -ForegroundColor Cyan
        if ($checkSubdirs) {
            Write-Host "Including subdirectories" -ForegroundColor Cyan
        } else {
            Write-Host "Excluding subdirectories" -ForegroundColor Cyan
        }
        
        $ahkFiles = if ($checkSubdirs) {
            Get-ChildItem -Path $searchPath -Recurse -Filter "*.ahk" -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending
        } else {
            Get-ChildItem -Path $searchPath -Filter "*.ahk" -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending
        }
        
        if ($ahkFiles) {
            Write-Host "`nfound some AHK stuff:" -ForegroundColor Yellow
            foreach ($file in $ahkFiles) {
                Write-Host "[$($file.LastWriteTime)] $($file.FullName)" -ForegroundColor Cyan
            }
        } else {
            Write-Host "`nno AHK scripts here" -ForegroundColor Red
        }
    } else {
        Write-Host "`nPcaSvc isn't running, can't check AHK" -ForegroundColor Red
    }
}

function Check-AutoIt {
    $SearchIndexerStatus = Get-Service -Name "SearchIndexer" -ErrorAction SilentlyContinue
    if ($SearchIndexerStatus.Status -eq "Running") {
        Write-Host "`nlooking for AutoIt scripts..." -ForegroundColor Green
        $au3Files = Get-ChildItem -Path "C:\Users" -Recurse -Filter "*.au3" -ErrorAction SilentlyContinue |
            Sort-Object LastWriteTime -Descending
        if ($au3Files) {
            Write-Host "found some AutoIt stuff:" -ForegroundColor Yellow
            foreach ($file in $au3Files) {
                Write-Host "[$($file.LastWriteTime)] $($file.FullName)" -ForegroundColor Cyan
            }
        } else {
            Write-Host "no AutoIt scripts here" -ForegroundColor Red
        }
    } else {
        Write-Host "`nSearchIndexer isn't running, skipping AutoIt check" -ForegroundColor Red
    }
}

function Check-AjazzGlorious {
    Check-ModDate -path "C:\users\$env:USERNAME\appdata\BYCOMBO-2" -desc "Ajazz/Glorious"
}

function Check-AsusROG {
    Check-ModDate -path "C:\users\$env:USERNAME\documents\ASUS\ROG\ROG Armoury\common" -desc "ASUS ROG"
}

function Check-Blackweb {
    Check-ModDate -path "C:\Blackweb Gaming AP\config" -desc "Blackweb"
}

function Check-Bloody7 {
    Check-ModDate -path "C:\Program Files (x86)\Bloody7\Bloody7\Data\Mouse\English\ScriptsMacros\GunLib" -desc "Bloody7"
}

function Check-Coolermaster {
    Check-ModDate -path "C:\Program Files (x86)\CoolerMaster\MasterPlus" -desc "CoolerMaster"
}

function Check-Corsair {
    Check-ModDate -path "C:\users\$env:USERNAME\appdata\corsair\CUE" -desc "Corsair"
}

function Check-Redragon {
    foreach ($path in @(
        "C:\Users\$env:USERNAME\Documents\M715 Gaming Mouse\MacroDB",
        "C:\Users\$env:USERNAME\Documents\INVADER Gaming Mouse\MacroDB"
    )) {
        Check-ModDate -path $path -desc "Redragon"
    }
}

function Check-Noganet {
    Check-ModDate -path "C:\Program Files\AYAX GamingMouse" -desc "Noganet"
}

function Check-Krom {
    Check-ModDate -path "C:\Users\$env:USERNAME\AppData\Local\VirtualStore\Program Files (x86)\KROM KOLT\Config" -desc "Krom"
}

function Check-Roccat {
    foreach ($path in @(
        "C:\Users\$env:USERNAME\AppData\Roaming\ROCCAT\SWARM\macro",
        "C:\Users\$env:USERNAME\AppData\Roaming\ROCCAT\SWARM\preset_macro"
    )) {
        Check-ModDate -path $path -desc "Roccat"
    }
}

function Check-Processes {
    Write-Host "`nchecking what's running..." -ForegroundColor Green
    foreach ($process in @("SteelSeriesGGClient", "dwm")) {
        $running = Get-Process -Name $process -ErrorAction SilentlyContinue
        if ($running) {
            Write-Host "$process is running - might wanna check that out" -ForegroundColor Yellow
        }
    }
}

function Check-All {
    Check-AutoHotkey
    Check-AutoIt
    Check-AjazzGlorious
    Check-AsusROG
    Check-Blackweb
    Check-Bloody7
    Check-Coolermaster
    Check-Corsair
    Check-Redragon
    Check-Noganet
    Check-Krom
    Check-Roccat
    Check-Processes
}

# Main loop
do {
    Show-Menu
    $choice = Read-Host

    switch ($choice) {
        "1" { Check-AutoHotkey }
        "2" { Check-AutoIt }
        "3" { Check-AjazzGlorious }
        "4" { Check-AsusROG }
        "5" { Check-Blackweb }
        "6" { Check-Bloody7 }
        "7" { Check-Coolermaster }
        "8" { Check-Corsair }
        "9" { Check-Redragon }
        "10" { Check-Noganet }
        "11" { Check-Krom }
        "12" { Check-Roccat }
        "13" { Check-Processes }
        "14" { Check-All }
        "Q" { return }
        "q" { return }
        default { Write-Host "`nInvalid choice. Press any key to continue..." -ForegroundColor Red; $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") }
    }

    if ($choice -match "^[1-9]|1[0-4]$") {
        Write-Host "`nPress any key to continue..."
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
} while ($true)