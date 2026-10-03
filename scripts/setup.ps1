$ErrorActionPreference = 'Stop'
$siteRoot = Split-Path -Parent $PSScriptRoot
$hugoVersion = '0.167.0'
$runtimeDir = Join-Path $siteRoot '.tools/hugo'
$hugoExe = Join-Path $runtimeDir 'hugo.exe'

if (-not (Test-Path -LiteralPath $hugoExe)) {
    New-Item -ItemType Directory -Path $runtimeDir -Force | Out-Null
    $archiveName = "hugo_${hugoVersion}_windows-amd64.zip"
    $releaseUrl = "https://github.com/gohugoio/hugo/releases/download/v$hugoVersion"
    $zipPath = Join-Path $runtimeDir $archiveName
    $checksPath = Join-Path $runtimeDir 'checksums.txt'
    Invoke-WebRequest "$releaseUrl/$archiveName" -OutFile $zipPath
    Invoke-WebRequest "$releaseUrl/hugo_${hugoVersion}_checksums.txt" -OutFile $checksPath
    $entry = Get-Content -LiteralPath $checksPath | Where-Object { ($_ -split '\s+')[-1] -eq $archiveName }
    if (-not $entry) { throw 'Hugo checksum entry not found.' }
    $expected = ($entry.Trim() -split '\s+')[0]
    $actual = (Get-FileHash -LiteralPath $zipPath -Algorithm SHA256).Hash.ToLower()
    if ($actual -ne $expected) { throw 'Hugo download checksum mismatch.' }
    Expand-Archive -LiteralPath $zipPath -DestinationPath $runtimeDir -Force
}

$themeTemplate = Join-Path $siteRoot 'themes/PaperMod/layouts/baseof.html'
if (-not (Test-Path -LiteralPath $themeTemplate)) {
    git -C $siteRoot submodule update --init --recursive
    if ($LASTEXITCODE -ne 0) { throw 'Unable to initialize PaperMod theme.' }
}
& $hugoExe version
if ($LASTEXITCODE -ne 0) { throw 'Unable to run Hugo.' }
