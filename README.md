# .dotfiles

## Installation

Fork it or simply clone it to your local.

```
cd
git clone git@github.com:GNITOAHC/.dotfiles.git
```

After cloning to your machine, link the files to the default configuration path.

## Quickstart

Toolsets: Neovim, Tmux, Fish shell
Using homebrew:

```sh
brew install neovim tmux fish
```

Link config files to config path

1. Neovim

   ```sh
   cd ~/.config
   ln -s ~.dotfiles/nvim .
   ```

2. Tmux
   `cd ~ && ln -s ~.dotfiles/tmux/.tmux.conf .`

3. Fish shell
   ```sh
   sudo sh -c 'echo /opt/homebrew/bin/fish >> /etc/shells' # Add fish to known shells
   ```
   Restart terminal
   ```sh
   chsh -s /opt/homebrew/bin/fish # Change default shell to fish
   ```
   Restart terminal and check if it launch with fish

## NVIM

### Plugins

Plugins using [packer.nvim](https://github.com/wbthomason/packer.nvim).

1. CMP plugins

   - [✓] nvim-cmp
   - [✓] cmp-buffer
   - [✓] cmp-path
   - [✓] cmp-cmdline
   - [✓] cmp_luasnip
   - [✓] cmp-nvim-lsp
   - [✓] cmp-nvim-lua
   - [✓] cmp-tabnine

2. Snippets

   - [✓] Luasnip
   - [✓] friendly-snippets

3. LSP

   - [✓] nvim-lspconfig
   - [✓] mason.nvim
   - [✓] mason-lspconfig.nvim
   - [✓] null-ls.nvim

4. Telescope

   - [✓] telescope.nvim
   - [✓] telescope-media-files.nvim
   - [✓] telescope-file-browser.nvim

5. Treesitter

   - [✓] nvim-treesitter
   - [✓] nvim-ts-rainbow
   - [✓] nvim-ts-context-commentstring

6. Pairs & Comment

   - [✓] nvim-autopairs
   - [✓] nvim-ts-autotag
   - [✓] Comment.nvim

7. Git

   - [✓] gitsigns.nvim

8. Nvim-tree

   - [✓] nvim-tree.lua

9. Bufferline & Lualine & Window line (barbecue.nvim)

   - [✓] bufferline.nvim
   - [✓] lualine.nvim
   - [✓] barbecue.nvim

10. ToggleTerm

    - [✓] toggleterm.nvim

11. Whichkey

    - [✓] which-key.nvim

12. Alpha

    - [✓] alpha-nvim

13. IndentBlankline & Pretty Fold

    - [✓] indent-blankline.nvim
    - [✓] pretty-fold.nvim

14. Transparent

    - [✓] nvim-transparent

15. LaTex

    - [✓] vimtex

16. code-runner

    - [✓] code_runner.nvim

17. Moving

    - [✓] neoscroll.nvim
    - [✓] hop.nvim
    - [✓] symbols-outline.nvim

18. Colors

    - [✓] tokyonight.nvim
    - [✓] nvim-colorizer.lua
    - [✓] nvim-web-devicons

19. Illuminate

    - [✓] vim-illuminate

20. Functions or API
    - [✓] plenary.nvim
    - [✓] popup.nvim

### Dependencies

- vimtex: `mactex` or `mactex-no-gui`

## TMUX

### TMUX Setup

1. Set prefix to <C-a>.

2. Some key-bindings

   - <prefix>X Kill-session
   - <prefix><C-c> New-session
   - <prefix><C-h> Previous-window
   - <prefix><C-l> Next-window
   - <prefix>{h,j,k,l} Pane-navigation

3. Default shell: fish shell

### TMUX Plugins

- Tmux plugins
  - [✓] tpm, tmux-sensible, tmux-yank
- Colorscheme
  - [✓] tmux-power
- Prefix
  - [✓] tmux-prefix-highlight
- Restore
  - [✓] tmux-resurrect, tmux-continuum

### Dependencies

- homebrew & fish shell: From `set-option -g default-shell $(brew --prefix)/bin/fish`

## FISH

### Installation

Install fish and plugin manager for fish.

1. Fish shell: [fish_install.md](https://gist.github.com/gagarine/cf3f65f9be6aa0e105b184376f765262)
2. Fisher: [install fisher](https://github.com/jorgebucaran/fisher)

### FILES

1. config.fish : Configurations for fish shell.
2. aliases.fish : Aliases for fish shell, sourced by `config.fish` when fish shell attached.

### PLUGINS

```shell
fisher install matchai/spacefish
fisher install PatrickF1/fzf.fish
fisher install jorgebucaran/autopair.fish
```

### Dependencies

fzf.fish requires fd -> `brew install fd`
aliases.fish requires tmux, git, exa

## PowerShell 

### QuickStart 

Put `. $HOME\.dotfiles\powershell\user_profile.ps1` inside `$PROFILE` of windows powershell. ### Dependencies `winget install --id Starship.Starship`
