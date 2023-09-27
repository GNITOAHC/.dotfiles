# Fish

## Installation

Install fish shell and plugin manager for fish.

1. Fish shell: [fish_install.md](https://gist.github.com/gagarine/cf3f65f9be6aa0e105b184376f765262)
2. Fisher: [install fisher](https://github.com/jorgebucaran/fisher)

## Files

1. config.fish : Configurations for fish shell.
2. aliases.fish : Aliases for fish shell, sourced by `config.fish` when fish shell attached.

### PLUGINS

```shell
fisher install PatrickF1/fzf.fish
fisher install jorgebucaran/autopair.fish
```

### Dependencies

`fzf.fish`:

| CLI                                    | Minimum version required | Description                             |
| -------------------------------------- | ------------------------ | --------------------------------------- |
| [fish](https://fishshell.com)          | 3.4.0                    | a modern shell                          |
| [fzf](https://github.com/junegunn/fzf) | 0.27.2                   | fuzzy finder that powers this plugin    |
| [fd](https://github.com/sharkdp/fd)    | 8.5.0                    | faster, colorized alternative to `find` |
| [bat](https://github.com/sharkdp/bat)  | 0.16.0                   | smarter `cat` with syntax highlighting  |

#### Cheatsheets

| Description      | Key Bindings                            |
| ---------------- | --------------------------------------- |
| Search directory | `Ctrl` + `alt` + `f` (`f` for file)     |
| Git log          | `Ctrl` + `alt` + `l` (`l` for log)      |
| Git status       | `Ctrl` + `alt` + `s` (`s` for status)   |
| Search history   | `Ctrl` + `r` (`r` for reverse-i-search) |
| Search variables | `Ctrl` + `v` (`v` for variables)        |

> For more key-bindings, see the [docs](https://github.com/PatrickF1/fzf.fish)

## Other Setups

1. [nvim](https://neovim.io/)

   ```shell
   set -gx EDITOR nvim # Set default editor to nvim
   ```

2. eza

   Auto remap `l`, `lt` and `ll` ... to use [`eza`](https://github.com/eza-community/eza)

3. alias `code` to vscode and `chrome` to google chrome

   ```shell
   $ code <file or dir>        # Open file or directory via vscode
   $ chrome <file or dir>      # Open file or directory via google chrome
   ```

   It's convenient to view markdown file when you have [markdown extension](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
   in vscode or
   [markdown viewer](https://chrome.google.com/webstore/detail/markdown-viewer/ckkdlimhmcjmikdlpkmbgfkaikojcbjk)
   in google chrome
