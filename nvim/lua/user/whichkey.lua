local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

local setup = {
    plugins = {
        marks = true, -- shows a list of your marks on ' and `
        registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = false, -- adds help for motions
            text_objects = false, -- help for text objects triggered after entering an operator
            windows = true, -- default bindings on <c-w>
            nav = true, -- misc bindings to work with windows
            z = true, -- bindings for folds, spelling and others prefixed with z
            g = true, -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    -- operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+", -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    window = {
        border = "rounded", -- none, single, double, shadow
        position = "bottom", -- bottom, top
        margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 25 }, -- min and max height of the columns
        width = { min = 20, max = 50 }, -- min and max width of the columns
        spacing = 3, -- spacing between columns
        align = "left", -- align columns left, center or right
    },
    ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    triggers = "auto", -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
}

local opts = {
    mode = "n", -- NORMAL mode
    prefix = "<leader>",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
    ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    ["d"] = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Diagnose window" },
    ["w"] = { "<cmd>w<cr>", "Write" },
    ["q"] = { "<cmd>q<cr>", "Quit" },
    ["x"] = { "<cmd>bd<cr>", "Buffer delete" },
    ["v"] = { "<cmd>vsp<cr>", "Vertical split" },
    ["V"] = { "<cmd>sp<cr>", "Horizontal split" },
    ["f"] = { "<cmd>Telescope file_browser<cr>", "Find file" },
    ["F"] = { "<cmd>Telescope live_grep<cr>", "Live grep" },
    ["s"] = { "<cmd>SymbolsOutline<cr>", "Outline toggle" },
    ["m"] = { "<cmd>Format<cr>", "Format" },
    ["nh"] = { "<cmd>noh<cr>", "No highlight" },

    g = {
        name = "Git",
        r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
        R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
        p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview changes" },
        n = { "<cmd>Gitsigns next_hunk<cr>", "Next Hunk" },
        N = { "<cmd>Gitsigns prev_hunk<cr>", "Prev Hunk" },
        s = { "<cmd>Telescope git_status<cr>", "Git status" },
        b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
        c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
        d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
    },

    b = {
        name = "Buffer",
        l = { "<cmd>BufferLineCloseLeft<cr>", "Close left" },
        r = { "<cmd>BufferLineCloseRight<cr>", "Close right" },
        a = { "<cmd>BufferLineCloseRight<cr><cmd>BufferLineCloseLeft<cr>", "Close except current" },
        n = { "<cmd>BufferLineMoveNext<cr>", "Move next" },
        p = { "<cmd>BufferLineMovePrev<cr>", "Move prev" },
    },

    t = {
        name = "Tabs/Terminal/Transparent",
        t = { "<cmd>TransparentToggle<cr>", "Toggle transparent" },
        f = { "<cmd>ToggleTerm direction=float<cr>", "Float terminal" },
        b = { "<cmd>ToggleTerm direction=tab<cr>", "Tab terminal" },
        h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal terminal" },
        v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical terminal" },
        e = { "<cmd>tabedit<cr>", "New tab" },
        n = { "<cmd>tabnext<cr>", "Next tab" },
        p = { "<cmd>tabprevious<cr>", "Previous tab" }
    },

    h = {
        name = "Help",
        J = { "", "Make curLine after prevLine" },
        n = {
            name = "Nvim Tree",
            m = { "", "Bookmakrs, \'bmv\' to move"},
            r = { "", "Rename file" },
            a = { "", "Add file, leave / behind for dir" },
            d = { "", "Delete file" },
            C = {
                name = "Ctrl",
                v = { "", "Open in vertical" },
                x = { "", "Open in horivontal" },
                t = { "", "Open in tab" },
            }

        },
        m = {
            name = "Move/Hop",
            p = { "", "Pattern" },
            v = { "", "Up" },
            V = { "", "Down" },
        },
        g = {
            name = "Goto",
            d = { "", "Definition" },
            D = { "", "Declaration" },
            l = { "", "Show error message" },
            i = { "", "Inplementation" },
        },
        d = {
            name = "Diagnostic",
            p = { "", "Previos" },
            n = { "", "Next" },
        },
        K = { "", "Hover information"},
        C = {
            name = "Ctrl",
            e = { "", "Scroll down" },
            y = { "", "Scroll up" },
            u = { "", "Up without moving cursor" },
            d = { "", "Down without moving cursor" },
            f = { "", "Page down" },
            b = { "", "Page up" },
            -- For ufo.lua 
            --[[ n = { "", "Next closed fold" }, ]]
            --[[ p = { "", "Previous closed fold" }, ]]
            k = { "", "Signature help" },
        },
        q = {
            name = "Quick",
            f = { "", "Fix"},
            h = { "", "Hover information" },
        }
    }
}

-- local vopts = {
--     mode = "v", -- VISUAL mode
--     prefix = "<leader>",
--     buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
--     silent = true, -- use `silent` when creating keymaps
--     noremap = true, -- use `noremap` when creating keymaps
--     nowait = true, -- use `nowait` when creating keymaps
-- }
-- local vmappings = {
--     ["/"] = { "<ESC><CMD>lua require(\"Comment.api\").toggle_linewise_op(vim.fn.visualmode())<CR>", "Comment" },
-- }

which_key.setup(setup)
which_key.register(mappings, opts)
-- which_key.register(vmappings, vopts)
