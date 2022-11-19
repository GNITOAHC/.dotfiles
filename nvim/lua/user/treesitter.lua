local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

local autotag_filetypes = {
    'html', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'tsx', 'jsx', 'rescript',
    'xml',
    'php',
    'markdown',
    'glimmer','handlebars','hbs'
}

configs.setup {
    ensure_installed = { "c", "cpp", "lua", "python", "c_sharp", "typescript", "javascript", "markdown", "scss", "fish" },
    sync_install = false,
    ignore_install = { "" }, -- List of parsers to ignore installing
    autopairs = {
        enable = true,
    },
    autotag = {
        enable = true,
        filetypes = autotag_filetypes,
    },
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "" }, -- list of language that will be disabled
        additional_vim_regex_highlighting = false,

    },
    indent = { enable = true, disable = { "yaml" } },
    rainbow = {
        enable = true,
        -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
        extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
        max_file_lines = nil, -- Do not enable for files with more than n lines, int
        -- colors = {}, -- table of hex strings
        -- termcolors = {} -- table of colour name strings
    }
}
