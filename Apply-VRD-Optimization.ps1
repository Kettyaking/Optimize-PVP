param([Parameter(Mandatory=$true)][string]$Resources)
$ErrorActionPreference = "Stop"
$root = (Resolve-Path $Resources).Path
$backup = Join-Path (Split-Path $root -Parent) ("VRD_backup_" + (Get-Date -Format "yyyyMMdd_HHmmss"))
Copy-Item $root $backup -Recurse -Force
Write-Host "Backup: $backup"
@("[esx_addons]\\xsound","[esx_addons]\\esx_vehicleshop") | ForEach-Object { $p=Join-Path $root $_; if(Test-Path -LiteralPath $p){ Remove-Item -LiteralPath $p -Recurse -Force; Write-Host "Removed $_" } }
$src = Join-Path $PSScriptRoot "patch\\[main-core]\\cfx-vrd-weapons\\garbageCollector.lua"
$dst = Join-Path $root "[main-core]\\cfx-vrd-weapons\\garbageCollector.lua"
Copy-Item -LiteralPath $src -Destination $dst -Force
function Patch-Text($relative) { $p=Join-Path $root $relative; if(!(Test-Path -LiteralPath $p)){ Write-Warning "Missing: $relative"; return }; $s=[IO.File]::ReadAllText($p); if($s -notmatch "const VRD_RESOURCE_NAME = GetParentResourceName"){ $s="const VRD_RESOURCE_NAME = GetParentResourceName();" + [Environment]::NewLine + $s }; $s=$s.Replace("GetParentResourceName()","VRD_RESOURCE_NAME"); $s=$s.Replace("const VRD_RESOURCE_NAME = VRD_RESOURCE_NAME;","const VRD_RESOURCE_NAME = GetParentResourceName();"); [IO.File]::WriteAllText($p,$s,(New-Object Text.UTF8Encoding($false))); Write-Host "Optimized $relative" }
Patch-Text "[main-core]\\cfx-vrd-report\\html\\script.js"
Patch-Text "[main-core]\\cfx-vrd-deathscreen\\html\\index-KROnsNVz.js"
Patch-Text "[main-core]\\cfx-vrd-scoreboard\\html\\app.js"
Patch-Text "[main-core]\\cfx-vrd-chat\\web\\app.js"
Write-Host "Optimization patch applied. Keep the backup until testing is complete."
