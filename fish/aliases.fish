# TMUX
alias t='tmux'
alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tn='tmux new -s'

# Git
alias g="git"
alias gs="git status"
alias gc="git commit -m"
alias ga="git add"
alias gp="git push"

# exa
alias l='exa'
alias la='exa --all'
alias ll="exa --long"
function lt --description 'alias lt=exa --tree --level $level $dir'
    # if not set -q $argv
    if [ "$argv[1]" = "" ]
        exa --tree --level 2
    else if [ "$argv[2]" = "" ]
        exa --tree --level $argv[1] .
    else 
        exa --tree --level $argv[1] $argv[2]
    end
end

# Force iCloud sync
alias FSync='killall bird'

# Navigator
alias ...='cd ../..'
alias ....='cd ../../..'

# Open VSCode 
alias code='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code -r'

# Open incognito pages in Chrome
alias inco='open -na "Google Chrome" --args --incognito ""'

