# Import-Module posh-git
# $omp_config = Join-Path $PSScriptRoot ".\negligible.omp.json"
# oh-my-posh init pwsh --config $omp_config | Invoke-Expression
$ENV:STARSHIP_CONFIG = "$HOME\.dotfiles\starship\starship.toml"
Invoke-Expression (&starship init powershell)

# Aliases
Set-Alias l ls
Set-Alias .. cd..
function la () { Get-ChildItem -Force }


# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function touch ($filename) {
  New-Item -Path $filename -ItemType File
}
