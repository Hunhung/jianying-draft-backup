# Runs until a file named STOP appears in D:\JianyingDraftBackup
# Started at logon by a shortcut in the user's Startup folder.
$ErrorActionPreference = 'SilentlyContinue'
$stop = 'D:\JianyingDraftBackup\STOP'
while (-not (Test-Path -LiteralPath $stop)) {
    & 'D:\JianyingDraftBackup\backup.ps1'
    Start-Sleep -Seconds 180
}
