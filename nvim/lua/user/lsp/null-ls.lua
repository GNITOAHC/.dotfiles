local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
    return
end

local util_status_ok, util = pcall(require, 'vim.lsp.util')
if not util_status_ok then
    return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
-- local diagnostics = null_ls.builtins.diagnostics

local formatting_callback = function(client, bufnr)
  vim.keymap.set('n', '<leader>m', function()
    local params = util.make_formatting_params({})
    client.request('textDocument/formatting', params, nil, bufnr)
  end, {buffer = bufnr})
end

null_ls.setup {
    debug = false,
    -- on_init = function(new_client, _)
    --     -- new_client.offset_encoding = 'utf-8'
    -- end,
    sources = {
        formatting.prettier.with { extra_args = {} },
        formatting.black.with { extra_args = { "--fast" } },
        -- formatting.yapf,
        -- formatting.stylua,
        -- diagnostics.flake8,
        formatting.clang_format.with {
            extra_args = {
                vim.fn.expand "--style=file:$HOME/.clang_format",
            },
        }
    },
    on_attach = function(client, bufnr)
        local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
        if filetype == 'cpp' then
            client.offset_encoding = 'utf-8'
        end
        formatting_callback(client, bufnr)
    end
}
