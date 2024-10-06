# TMUX
alias t="tmux"
alias tl="tmux list-sessions"
alias tn="tmux new -s"
function ta --description 'alias ta=tmux attach $session'
    if [ "$argv[1]" = "" ]
        tmux attach-session
    else
        tmux attach-session -t $argv[1] # Attach to a specific session
    end
end

# Fish
alias fp="fish --private"

# Git
alias g="git"
alias gs="git status"
alias gc="git commit -m"
alias ga="git add"
alias gp="git push"
alias gb="git branch"
alias gl="git log --oneline -n 5"

# eza
alias l="eza"
alias la="eza --all"
alias ll="eza --long --icons"
alias lla="eza --long --icons --all"
alias lg="eza --long --icons --git"
function lt --description 'alias lt=eza --tree --level $level $dir'
    # if not set -q $argv
    if [ "$argv[1]" = "" ]
        eza --tree --level 2
    else if [ "$argv[2]" = "" ]
        if test -d $argv[1]
            eza --tree --level 2 $argv[1] # lt [dir]
        else
            eza --tree --level $argv[1] . # lt [level]
        end
    else 
        if test -d $argv[2]
            eza --tree --level $argv[1] $argv[2] # lt [level] [dir]
        else
            eza --tree --level $argv[2] $argv[1] # lt [dir] [level]
        end
    end
end

# Force iCloud sync
alias FSync="killall bird"

# Navigator
alias ...="cd ../.."
alias ....="cd ../../.."

# Some useful functions
function show --description 'show section of the file, usage: show $file $start $end'
    head -n $argv[3] $argv[1] | tail -n (math $argv[3] - $argv[2] + 1)
end

# Chrome
# alias chrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome -open"
function chrome --description 'alias chrome=/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome -open $file'
    if [ "$argv[1]" != "" ]
        /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome -open (realpath $argv[1])
    else
        /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome -open (realpath .)
    end
end
