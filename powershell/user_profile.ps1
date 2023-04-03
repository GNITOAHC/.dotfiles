# StarShip config
# $ENV:STARSHIP_CONFIG = "$HOME\.dotfiles\starship\starship.toml"
# Invoke-Expression (&starship init powershell)

# Oh-my-posh config
oh-my-posh init pwsh --config ~/.dotfiles/oh-my-posh/bubblesextra.omp.json | Invoke-Expression

# Import-Module
# To list modules, run: `Get-Module -ListAvailable`
Import-Module -Name Terminal-Icons
Import-Module -Name PSReadLine

# Aliases
. $HOME\.dotfiles\powershell\aliases.ps1

# PSReadLine config 
. $HOME\.dotfiles\powershell\psreadline.ps1

# Tips for windows

# List all services
# services.msc
