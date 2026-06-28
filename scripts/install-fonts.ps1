<#
.SYNOPSIS
    Install UDEV Gothic on native Windows (per-user, no admin needed).

.DESCRIPTION
    Downloads the latest UDEV Gothic release from GitHub, then installs the
    TTFs for the current user by copying them into the per-user Fonts folder
    and registering them under HKCU.  Idempotent.

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File .\scripts\install-fonts.ps1
#>

$ErrorActionPreference = 'Stop'

$repo = 'yuru7/udev-gothic'
$api  = "https://api.github.com/repos/$repo/releases/latest"

Write-Host 'Looking up the latest UDEV Gothic release...'
$release = Invoke-RestMethod -Uri $api -Headers @{ 'User-Agent' = 'emacs-config' }

# Standard family asset (UDEVGothic_vX...), not the NF/HS/LG/35 variants.
$asset = $release.assets |
    Where-Object { $_.name -match 'UDEVGothic_v\d' } |
    Select-Object -First 1
if (-not $asset) { throw 'Could not find a UDEV Gothic asset in the latest release.' }

$tmp = Join-Path $env:TEMP ("udevgothic_" + [System.Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $tmp -Force | Out-Null
$zip = Join-Path $tmp 'udevgothic.zip'

Write-Host "Downloading: $($asset.browser_download_url)"
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zip
Expand-Archive -Path $zip -DestinationPath $tmp -Force

# Per-user font locations (Windows 10 1809+ supports per-user font install).
$fontDir = Join-Path $env:LOCALAPPDATA 'Microsoft\Windows\Fonts'
New-Item -ItemType Directory -Path $fontDir -Force | Out-Null
$regKey = 'HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts'

$count = 0
Get-ChildItem -Path $tmp -Recurse -Filter '*.ttf' | ForEach-Object {
    $dest = Join-Path $fontDir $_.Name
    Copy-Item -Path $_.FullName -Destination $dest -Force
    # Registry value name carries a display label; point it at the file.
    Set-ItemProperty -Path $regKey -Name "$($_.BaseName) (TrueType)" -Value $dest
    $count++
}

Remove-Item -Recurse -Force $tmp
Write-Host "Done. Installed $count TTF(s) for the current user."
Write-Host 'You may need to restart Emacs (and sometimes sign out/in) to see the font.'
