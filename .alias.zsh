# "code [file or dir]" to open it in VScode
alias code='/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code -r'

# open moocs and moodle website in safari
alias mooc='open http://moocs.nccu.edu.tw/'
alias mood='open http://moodle.nccu.edu.tw/'

# open incognito pages in Chrome
alias inco='open -na "Google Chrome" --args --incognito ""'

# open toggl website in Chrome
alias toggl='browser "https://track.toggl.com/timer"'

# t for tmux
alias t='tmux'
alias tn='tmux new -s'

# google search in terminal type "google [what you want to search]"
alias chrome='{read -r arr; open -a "Google Chrome" "${arr}"} <<<'
alias browser='{read -r arr; chrome ${arr} } <<<'
alias google='{read -r arr; browser "https://google.com/search?q=${arr}";} <<<'

# make alias so that fzf with bat preview become default
# alias fzf="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"

# alias "FSync" to force iCloud to sync with running 'killall bird'
alias FSync='killall bird'

# Git
alias g="git"
alias gs="git status"
alias gc="git commit -m"
alias ga="git add"
