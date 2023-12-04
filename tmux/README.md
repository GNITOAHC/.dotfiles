# Tmux

## Tmux Cheatcheet

1. Prefix: `<C-a>`

2. Some key-bindings

   - \<prefix>X Kill-session
   - \<Prefix>P Set current path as default path of new panes
   - \<prefix>\<C-c> New-session
   - \<prefix>\<C-h> Previous-window
   - \<prefix>\<C-l> Next-window
   - \<prefix>" Split horizontally
   - \<prefix>% Split vertically
   - \<prefix>{h,j,k,l} Pane-navigation
   - \<prefix>{n,p} Move pane forward or backward

3. Plugins management

   - \<prefix>I Install listed plugins
   - \<prefix>U Update installed plugins
   - \<prefix>C Clean the plugins thats not on the plugin list

## Tmux Plugins

1. First, clone `tpm`, the tmux plugin manager.

```shell
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

2. Reload TMUX environment so TPM is sourced.

```shell
# type this in terminal if tmux is already running
tmux source ~/.tmux.conf
```

3. Used plugins

   - Tmux plugins
     - [✓] tpm, tmux-sensible, tmux-yank
   - Colorscheme
     - [✓] tmux-power
   - Prefix
     - [✓] tmux-prefix-highlight
   - Restore
     - [✓] tmux-resurrect, tmux-continuum
