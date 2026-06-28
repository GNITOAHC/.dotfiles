<#
.SYNOPSIS
  Expand ~/.claude/settings.json with a preset of personal defaults (Windows).

.DESCRIPTION
  - If settings.json does not exist, it is created from the preset.
  - If it exists, the preset is deep-merged in: preset values override existing
    fields, and fields not yet present are added. Anything you have that the
    preset doesn't mention is left untouched.

.EXAMPLE
  irm https://raw.githubusercontent.com/GNITOAHC/.dotfiles/main/claude/setup.ps1 | iex
#>

$ErrorActionPreference = 'Stop'

$PresetUrl = if ($env:CLAUDE_SETTINGS_PRESET_URL) { $env:CLAUDE_SETTINGS_PRESET_URL } `
  else { 'https://raw.githubusercontent.com/GNITOAHC/.dotfiles/main/claude/settings.json' }
$SettingsDir  = Join-Path $HOME '.claude'
$SettingsFile = Join-Path $SettingsDir 'settings.json'

# Recursively deep-merge two PSCustomObjects; values from $override win.
function Merge-Object($base, $override) {
  if ($base -isnot [psobject] -or $override -isnot [psobject] -or
      $base -is [array] -or $override -is [array]) {
    return $override
  }
  $result = [ordered]@{}
  foreach ($p in $base.PSObject.Properties)     { $result[$p.Name] = $p.Value }
  foreach ($p in $override.PSObject.Properties) {
    if ($result.Contains($p.Name)) {
      $result[$p.Name] = Merge-Object $result[$p.Name] $p.Value
    } else {
      $result[$p.Name] = $p.Value
    }
  }
  return [pscustomobject]$result
}

# --- fetch preset ----------------------------------------------------------
try {
  $presetRaw = Invoke-RestMethod -Uri $PresetUrl -ErrorAction Stop
  # Re-fetch as raw text so we keep exact JSON for the no-file case.
  $presetText = (Invoke-WebRequest -Uri $PresetUrl -UseBasicParsing).Content
} catch {
  throw "failed to download preset from $PresetUrl"
}
$preset = $presetText | ConvertFrom-Json

if (-not (Test-Path $SettingsDir)) { New-Item -ItemType Directory -Path $SettingsDir | Out-Null }

# --- write or merge --------------------------------------------------------
if (-not (Test-Path $SettingsFile)) {
  Write-Host "No existing settings found; writing preset to $SettingsFile"
  $presetText | Set-Content -Path $SettingsFile -Encoding utf8
  Write-Host 'Done.'
  return
}

try { $existing = Get-Content -Raw $SettingsFile | ConvertFrom-Json }
catch { throw "$SettingsFile exists but is not valid JSON; aborting" }

$backup = "$SettingsFile.bak.$(Get-Date -Format 'yyyyMMddHHmmss')"
Copy-Item $SettingsFile $backup
Write-Host "Backed up existing settings to $backup"

$merged = Merge-Object $existing $preset
$merged | ConvertTo-Json -Depth 100 | Set-Content -Path $SettingsFile -Encoding utf8
Write-Host "Merged preset into $SettingsFile"
