# Powershell

## Quick start

Put `. $HOME\.dotfiles\powershell\user_profile.ps1` inside `$PROFILE` of windows powershell.

## Prompt

1. oh-my-posh: Make sure to install OhMyPosh, `winget install -e --id JanDeDobbeleer.OhMyPosh`.
2. starship: Install starship `winget install -e --id Starship.Starship`, uncomment the starship config and comment out the OhMyPosh config inside `user_profile.ps1`.

## Setup

For module Terminal-Icons, find it with `Find-Module` and install it.

```pwsh
Find-Module -Name Terminal-Icons | Install-Module
```

## Debugging

If encountering error like this: "<file> cannot be loaded because running scripts is disabled on this system.", try following command to change the execution policy.

```pwsh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```
