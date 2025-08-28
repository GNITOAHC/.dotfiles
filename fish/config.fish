if status is-interactive
    # Commands to run in interactive sessions can go here
    source ~/.config/fish/aliases.fish  # Source aliases 
end

# Add homebrew path 
# Install homebrew first [homebrew](brew.sh)
set -gx PATH /opt/homebrew/bin /opt/homebrew/sbin $PATH

# Set nvim as default editor
set -gx EDITOR nvim

# If ~/.cargo/bin exists, add it to path
if test -d ~/.cargo/bin/ 
    set -gx PATH ~/.cargo/bin $PATH
end

# If Install Java with homebrew
if test -d /opt/homebrew/opt/openjdk/bin
    set -gx PATH /opt/homebrew/opt/openjdk/bin $PATH
    # set -gx CPPFLAGS "-I/opt/homebrew/opt/openjdk/include"
end

# If ~/go exists, add it to path
if test -d ~/go
    set -gx GOPATH ~/go
    # If ~/go/bin exists, add it to path
    if test -d ~/go/bin
        set -gx PATH ~/go/bin/ $PATH
    end
end

# If llvm exists, add it to path
if test -d /opt/homebrew/opt/llvm/
    set -gx PATH /opt/homebrew/opt/llvm/bin/ $PATH
    set -gx LDFLAGS "-L/opt/homebrew/opt/llvm/lib"
    set -gx CPPFLAGS "-I/opt/homebrew/opt/llvm/include"
    set -gx CPATH "/opt/homebrew/opt/llvm/include" $CPATH
end

# Link mason lsp server and share with helix
if test -d ~/.local/share/nvim/mason/bin
    set -gx PATH ~/.local/share/nvim/mason/bin $PATH
end

# Add C++ headers files installed from homebrew, e.g. boost, glew, glfw...
if ls $(brew --prefix) | grep "include" > /dev/null
    set -gx CPATH $(brew --prefix)/include $CPATH
end

# fisher install PatrickF1/fzf.fish
if cat $__fish_config_dir/fish_plugins | grep fzf.fish > /dev/null
    set -gx fzf_preview_dir_cmd eza --all --color=always
end

# Export variables setted at specific files
# Should be formatted as KEY="val"
for file in ~/.env ~/.local/.env ~/.config/.env
    if test -f $file
        for line in (cat $file)
            set key (echo $line | cut -d'=' -f1)
            set value (echo $line | cut -d'=' -f2- | sed 's/^"//' | sed 's/"$//')
            set -x $key $value
        end
    end
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
