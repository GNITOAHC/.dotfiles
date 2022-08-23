source $(brew --prefix)/opt/zplug/init.zsh

zplug romkatv/powerlevel10k, as:theme, depth:1

# zsh users
zplug "zsh-users/zsh-completions",              defer:0
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting",      defer:3, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search", defer:3, on:"zsh-users/zsh-syntax-highlighting"

# Then, source plugins and add commands to $PATH
zplug load 

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Make Neovim default editor
export VISUAL=nvim
export EDITOR="$VISUAL"
export TERM=xterm-256color

source ~/.dotfiles/zsh/.alias.zsh
[ -f ~/.fzf.zsh ] && source ~/.dotfiles/zsh/.fzf.zsh

