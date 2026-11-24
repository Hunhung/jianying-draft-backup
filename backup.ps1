# JianyingPro draft auto-snapshot
# Copies only small project metadata (*.json) so a hard freeze cannot destroy
# an in-progress edit. Runs every 3 minutes via scheduled task.
$ErrorActionPreference = 'SilentlyContinue'
$src  = 'E:\JianyingPro Drafts'
$root = 'D:\JianyingDraftBackup'

if (-not (Test-Path -LiteralPath $src)) { exit }
New-Item -ItemType Directory -Path $root -Force | Out-Null

$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$dst   = Join-Path $root $stamp
$init  = Join-Path $root '.initialized'

$all = Get-ChildItem -LiteralPath $src -Recurse -File -Filter '*.json' -Force |
       Where-Object { $_.FullName -notmatch '\\\.recycle_bin\\' }

if (Test-Path -LiteralPath $init) {
    $cut   = (Get-Date).AddMinutes(-20)
    $files = $all | Where-Object { $_.LastWriteTime -ge $cut }
} else {
    $files = $all
    New-Item -ItemType File -Path $init -Force | Out-Null
}

if ($files) {
    New-Item -ItemType Directory -Path $dst -Force | Out-Null
    foreach ($f in $files) {
        $rel = $f.FullName.Substring($src.Length).TrimStart('\')
        $t   = Join-Path $dst $rel
        New-Item -ItemType Directory -Path (Split-Path $t -Parent) -Force | Out-Null
        Copy-Item -LiteralPath $f.FullName -Destination $t -Force
    }
}

# keep the newest 15 snapshots
Get-ChildItem -LiteralPath $root -Directory | Where-Object { $_.Name -match '^\d{8}-\d{6}$' } |
    Sort-Object Name -Descending | Select-Object -Skip 15 |
    ForEach-Object { [System.IO.Directory]::Delete($_.FullName, $true) }

Add-Content -Path (Join-Path $root 'backup.log') -Value ("$stamp files=" + @($files).Count)
