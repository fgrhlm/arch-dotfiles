-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lspconfig = require('lspconfig')
lspconfig.jedi_language_server.setup {}
lspconfig.tsserver.setup {}
lspconfig.gopls.setup {}
lspconfig.clangd.setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>fmt', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
