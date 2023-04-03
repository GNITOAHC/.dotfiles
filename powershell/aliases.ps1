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

# Utilities
function which ($command) {
  Get-Command -Name $command -ErrorAction SilentlyContinue |
    Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}

function touch ($filename) {
  New-Item -Path $filename -ItemType File
}
