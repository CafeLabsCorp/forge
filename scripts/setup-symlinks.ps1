# Symlinks the agent definitions in this repo into ~/.claude/agents/, so Claude
# Code picks them up as available subagent types. Windows/PowerShell version of
# setup-symlinks.sh. Needs Windows Developer Mode (or an elevated shell) to create symlinks.
# Run once after cloning, and again any time an agent file is added, renamed, or removed under agents/.
$ErrorActionPreference = 'Stop'

$repoDir = Split-Path -Parent $PSScriptRoot
$targetDir = Join-Path $HOME '.claude\agents'
New-Item -ItemType Directory -Force -Path $targetDir | Out-Null

Get-ChildItem (Join-Path $repoDir 'agents') -Filter *.md -File | ForEach-Object {
    $dest = Join-Path $targetDir $_.Name
    $existing = Get-Item $dest -Force -ErrorAction SilentlyContinue
    if ($existing) {
        if ($existing.LinkType -eq 'SymbolicLink') {
            Remove-Item $dest -Force
        } else {
            Write-Warning "$dest already exists and is not a symlink - skipping. Move/delete it manually and re-run if you want it linked."
            return
        }
    }
    # cmd's mklink honours Developer Mode on Windows PowerShell 5.1, where New-Item -ItemType SymbolicLink does not.
    cmd /c mklink "$dest" "$($_.FullName)" | Out-Null
    if ($LASTEXITCODE -ne 0) { throw "mklink failed for $dest" }
    Write-Host "linked: $dest -> $($_.FullName)"
}

Write-Host 'Done.'
