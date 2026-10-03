$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'setup.ps1')
$siteRoot = Split-Path -Parent $PSScriptRoot
$hugoExe = Join-Path $siteRoot '.tools/hugo/hugo.exe'
& $hugoExe server --source $siteRoot --bind 127.0.0.1 --port 1313 --buildDrafts --renderToMemory
if ($LASTEXITCODE -ne 0) { throw 'Hugo preview failed.' }
