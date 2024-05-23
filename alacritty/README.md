# Alacritty

## Initialize Alacritty

```shell
cd
ln -s ~/.dotfiles/alacritty/.alacritty.toml .
```

## Setting True Color in Alacritty (with TMUX)

Setup `alacritty.toml`

```toml
[env]
TERM = "xterm-256color"
```

Setup TMUX config

```tmux
set -g default-terminal "xterm-256color"        # This tell TMUX to use xterm-256color.
set -ag terminal-overrides ",xterm-256color:Tc" # This tell TMUX that the terminal outside supports true color(Tc).
```

## Apply Changes

```tmux
tmux source-file ~/.alacritty.toml
```
