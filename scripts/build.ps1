$ErrorActionPreference = 'Stop'
& (Join-Path $PSScriptRoot 'setup.ps1')
$siteRoot = Split-Path -Parent $PSScriptRoot
$hugoExe = Join-Path $siteRoot '.tools/hugo/hugo.exe'
& $hugoExe --source $siteRoot --gc --minify --cleanDestinationDir
if ($LASTEXITCODE -ne 0) { throw 'Hugo build failed.' }
