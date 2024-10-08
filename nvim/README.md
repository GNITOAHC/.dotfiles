# Nvim

## Setup

> Currently using nvim v0.10.1

### MacOS

1. Install `nvim` via [homebrew](https://brew.sh)

   ```shell
   brew install nvim
   ```

2. Link nvim directory to the default config folder

   ```shell
   cd ~/.config && ln -s ~/.dotfiles/nvim .
   ```

### Windows

1. Install `nvim` via [winget](https://winget.run/)

   ```shell
   winget install -e --id Neovim.Neovim
   ```

2. Link nvim directory to the default config folder

   ```shell
   New-Item -ItemType SymbolicLink -Path "$HOME\AppData\Local\nvim" -Target "$HOME\.dotfiles\nvim"
   ```

**NOTE**

1. To setup language server support for C/C++ on Windows, Visual Studio and LLVM is required.
   1. Install Visual Studio, check 'Desktop dev with C++' then add the optional tool 'C++ Clang'.
   2. `winget install -e --id LLVM.LLVM` then add binaries to Environment Variable. Binaries are generally installed at `C:\Program Files\LLVM\bin`.
2. Zig and GCC are required but not built-in.
   1. Use `winget install -e --id zig.zig` to install Zig (recommended).
   2. Use [MinGW](https://sourceforge.net/projects/mingw/) to install GCC then add to Environment Variable. Binaries are generally installed at `C:\MinGW\bin`.

## Plugins

Plugins are installed via [lazy.nvim](https://github.com/folke/lazy.nvim), for full list of plugins, see [plugins.lua](./lua/user/plugins.lua)

## Dependencies

| Plugin                                                                | Dependencies                                                                                    |
| --------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| [lazy.nvim](https://github.com/folke/lazy.nvim)                       | git                                                                                             |
| [treesitter.nvim](https://github.com/nvim-treesitter/nvim-treesitter) | (gcc for mac & zig for windows), git, (tree-sitter for TSInstallFromGrammar), node(npm)         |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)    | (rg i.e. [ripgrep](https://github.com/BurntSushi/ripgrep)), [fd](https://github.com/sharkdp/fd) |
| [tabnine-nvim](https://github.com/codota/tabnine-nvim)                | curl                                                                                            |
| [copilot.lua](https://github.com/zbirenbaum/copilot.lua)              | node >= 18.x or newer                                                                           |
