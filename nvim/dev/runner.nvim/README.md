# runner.nvim

A small asynchronous code runner for Neovim. `:RunCode` searches upward from
the current buffer for `coderunner.sh`, executes it from its own directory, and
streams stdout and stderr into a dedicated Neovim buffer.

## Requirements

- Neovim 0.8 or newer

## Installation

With `lazy.nvim`:

```lua
{
  "gnitoahc/runner.nvim",
  opts = {},
}
```

## Usage

Run the first configured runner found in the current file's directory or one
of its parents:

```vim
:RunCode
```

Run a particular file instead (relative paths are resolved from Neovim's
working directory, then searched for in parent directories):

```vim
:RunCode scripts/run-project.sh
```

If a runner is executable, it is launched directly and its shebang is honored.
Otherwise it is passed to Neovim's configured `shell`. Starting another run
stops the previous run.

Press `<C-c>` in the output buffer to stop the active process. The same action
is also available as `:RunCodeStop` or `require("runner").stop()`.

If the output window has been closed while a process is still running, reopen
it without affecting the process:

```vim
:RunCodeOutput
```

The Lua equivalent is `require("runner").show_output()`.

Run an arbitrary shell command, similar to `:!`, while streaming its output to
the runner output buffer:

```vim
:RunCodeCmd make test
:RunCodeCmd git status --short
:RunCodeCmd printf 'hello\n' | sort
```

Commands run from Neovim's current working directory using its configured
`shell` and `shellcmdflag`. The Lua equivalent is
`require("runner").run_command("make test")`.

## Configuration

These are the defaults:

```lua
require("runner").setup({
  runner_files = { "coderunner.sh" },
  output = {
    layout = "horizontal", -- "horizontal", "vertical", "float", or "buffer"
    size = nil,             -- split height or vertical split width
    focus = false,          -- keep focus in the source window by default
    float = {
      width = 0.8,          -- fraction of editor width, or absolute columns
      height = 0.8,         -- fraction of editor height, or absolute rows
      border = "rounded",
    },
  },
})
```

For example, search for several project-specific files and show output in a
50-column vertical split:

```lua
require("runner").setup({
  runner_files = { "coderunner.sh", ".nvim/run.sh", "scripts/run.sh" },
  output = {
    layout = "vertical",
    size = 50,
  },
})
```

To use a centered floating window:

```lua
require("runner").setup({
  output = {
    layout = "float",
    focus = true,
    float = { width = 0.7, height = 0.6, border = "single" },
  },
})
```

Floating output windows close automatically when focus moves to another
window. Closing the float does not stop the process or discard its output;
use `:RunCodeOutput` to show it again.

Use `layout = "buffer"` to replace the current window with the output buffer
instead of creating another window. The original source remains in Neovim's
buffer list.

## Testing

Run the dependency-free headless smoke test with:

```sh
make test
```
