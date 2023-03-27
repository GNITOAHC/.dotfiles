# StarShip config
# $ENV:STARSHIP_CONFIG = "$HOME\.dotfiles\starship\starship.toml"
# Invoke-Expression (&starship init powershell)

# Oh-my-posh config
oh-my-posh init pwsh --config ~/.dotfiles/oh-my-posh/bubblesextra.omp.json | Invoke-Expression

# Import-Module
Import-Module -Name Terminal-Icons

# Aliases

Set-Alias l ls
function la () { Get-ChildItem -Force }

Set-Alias g git 
function gs () { git status }
function gc () { git commit -m }
function ga () { git add }
function gp () { git push }

Set-Alias .. cd..
function ... () { cd ..\.. }
function .... () { cd ..\..\.. }

Set-Alias open ii
Set-Alias grep Select-String

# Tab for autocomplete
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function touch ($filename) {
  New-Item -Path $filename -ItemType File
}

# Tips for windows

# List all services
# services.msc
