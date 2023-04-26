if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.config/fish/aliases.fish  # Source aliases 
end

# Add homebrew path 
# Install homebrew first [homebrew](brew.sh)
set -gx PATH /opt/homebrew/bin/ /opt/homebrew/sbin $PATH

# Set nvim as default editor
set -gx EDITOR nvim

# If ~/.cargo/bin exists, add it to path
if test -d ~/.cargo/bin/ 
    set -gx PATH ~/.cargo/bin $PATH
end

# Add C++ headers files installed from homebrew
# brew install boost
if ls $(brew --prefix) | grep "include" > /dev/null
    set -gx CPATH $(brew --prefix)/include
end

# fisher install PatrickF1/fzf.fish
if cat $__fish_config_dir/fish_plugins | grep fzf.fish > /dev/null
    set -gx fzf_preview_dir_cmd exa --all --icons --color=always
end

# Check if starship exist
# if type -q starship 
#     set -gx STARSHIP_CONFIG ~/.dotfiles/starship/starship.toml
#     starship init fish | source
# end


# If oh-my-posh exists, use it as shell prompt. 
if type -q oh-my-posh
    oh-my-posh init fish --config ~/.dotfiles/oh-my-posh/bubblesextra.omp.json | source
end
