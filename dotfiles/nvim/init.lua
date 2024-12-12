local g = vim.g
local opt = vim.opt
local cmd = vim.api.nvim_command
local keymap = vim.api.nvim_set_keymap

------------------------------------------------
------------------------------------------------
------------------ Plugins (Lazy)
------------------------------------------------
------------------------------------------------

-- install lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

local lazy = require('lazy')
lazy.setup({
    "pineapplegiant/spaceduck",         --https://github.com/pineapplegiant/spaceduck
    "preservim/tagbar",                 --https://github.com/preservim/tagbar
    "neovim/nvim-lspconfig",            --https://github.com/neovim/nvim-lspconfig
    "nvim-treesitter/nvim-treesitter",  --https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-lualine/lualine.nvim",        --https://github.com/nvim-lualine/lualine.nvim
    "nvim-tree/nvim-web-devicons",      --https://github.com/nvim-tree/nvim-web-devicons
    "mattn/emmet-vim",                  --https://github.com/mattn/emmet-vim
    {
        "nvim-telescope/telescope.nvim",--https://github.com/nvim-telescope/telescope.nvim
        dependencies = {
            "nvim-lua/plenary.nvim"     --https://github.com/nvim-lua/plenary.nvim
        }
    },
    {
      "scalameta/nvim-metals",          --https://github.com/scalameta/nvim-metals
      dependencies = {
        "nvim-lua/plenary.nvim",        --https://github.com/nvim-lua/plenary.nvim
      },
      ft = { "scala", "sbt", "java" },
      opts = function()
        local metals_config = require("metals").bare_config()
        metals_config.on_attach = function(client, bufnr)
        end

        return metals_config
      end,
      config = function(self, metals_config)
        local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = self.ft,
          callback = function()
            require("metals").initialize_or_attach(metals_config)
          end,
          group = nvim_metals_group,
        })
      end
    }
})

------------------------------------------------
------------------------------------------------
------------------ Globals
------------------------------------------------
------------------------------------------------

vim.o.updatetime = 100
g.netrw_winsize = 30
g.netrw_banner = 0
g.netrw_liststyle = 3

------------------------------------------------
------------------------------------------------
------------------ Opts
------------------------------------------------
------------------------------------------------

---- Behaviour
opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.expand("~/.vim/undodir")
opt.backspace = "indent,eol,start"
opt.mouse:append('a')
opt.clipboard:append("unnamedplus")
opt.modifiable = true
opt.guicursor = "n-v-c:block,i-ci-ve:block"
opt.hlsearch = false
opt.incsearch = true

---- Filetype specific stuff

-- tab width
cmd("au Filetype html setlocal sw=2 expandtab")
cmd("au Filetype vue setlocal sw=2 expandtab")
cmd("au Filetype javascript setlocal sw=2 expandtab")
cmd("au Filetype javascriptreact setlocal sw=2 expandtab")
cmd("au Filetype css setlocal sw=2 expandtab")
cmd("au FileType haskell setlocal shiftwidth=2 softtabstop=2 expandtab")

---- Retab files on read/write
cmd("au BufRead,BufWrite setlocal retab")

---- Colorscheme
vim.cmd.colorscheme "spaceduck"
cmd("highlight Comment guifg=#F10E55")

---- Tabs / indent
opt.shiftwidth = 4 
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.wrap = false

---- Visual Experience TM
opt.number = true
opt.relativenumber = true
opt.cmdheight = 1
opt.scrolloff = 8

---- Completion
opt.completeopt = "menuone,noinsert,noselect"

------------------------------------------------
------------------------------------------------
------------------ LSP
------------------------------------------------
------------------------------------------------

--[[ 
    Pacman: 
    
    sudo pacman -s \
        bash-language-server \
        jedi-language-server \
        typescript-language-server \
        gopls \
        clang \
        haskell-language-server \
        lua-language-server
    
    NPM:
    npm install -g \
        @angular/language-server \
        @vue/language-server \
        vscode-langservers-extracted \
    
    AUR:
    https://aur.archlinux.org/packages/ruby-solargraph
--]]

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lspconfig = require('lspconfig')

---- Bash
-- pacman -S bash-language-server
lspconfig.bashls.setup{}

---- Jedi
-- pacman -S jedi-language-server
lspconfig.jedi_language_server.setup {}

---- TSServer
-- pacman -S typescript-language-server
lspconfig.tsserver.setup {}

---- Gopls
-- pacman -S gopls
lspconfig.gopls.setup {}

---- Clangd
-- pacman -S clang
lspconfig.clangd.setup {
    filetypes = { "c", "cpp", "cuda", "cu"}
}

---- Angular
-- npm install -g @angular/language-server
lspconfig.angularls.setup{}

---- Vue.js
-- npm install -g @vue/language-server
lspconfig.volar.setup{
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
    init_options = {
        vue = {
            hybridMode = false,
        },
    },
}

---- CSS
-- npm i -g vscode-langservers-extracted
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.cssls.setup{
    capabilities = capabilities,
}

---- Haskell
-- pacman -S haskell-language-server
lspconfig.hls.setup{
    filetypes = { 'haskell', 'lhaskell', 'cabal' }
}

---- Ruby
-- https://aur.archlinux.org/packages/ruby-solargraph
lspconfig.solargraph.setup{}

---- Lua Language Server
-- sudo pacman -S lua-language-server
-- Love2d
lspconfig.lua_ls.setup {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT'
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/love2d/library"
        }
      }
    })
  end,
  settings = {
    Lua = {}
  }
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
    local bopts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bopts)
    vim.keymap.set('n', '<leader>fmt', function()
      vim.lsp.buf.format { async = true }
    end, bopts)
  end,
})

---- Update diagnostics in I mode
vim.diagnostic.config({
  update_in_insert = true,
})

---- Diagnostics in window
function open_diagnostic_win()
  local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
end

vim.keymap.set({'n', 'i'}, '<C-d>', open_diagnostic_win)

---- Gutter symbols
local signs = { Error = "🕱", Warn = "🏱", Hint = "🏷", Info = "🕮 " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

------------------------------------------------
------------------------------------------------
------------------ Keybindings
------------------------------------------------
------------------------------------------------

local tscope = require("telescope.builtin")

-- Leader
keymap("n", " ", "<Nop>", {silent = true})
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set 'ö' to <Esc>
local modes = {"i", "n", "v"}

for _, mode in ipairs(modes) do
    keymap(mode, "ö", "<esc>", { noremap = true })
end

-- Disable arrow keys in normal mode
local arrow_keys = {"<Left>", "<Right>", "<Up>", "<Down>"}

for _, key in ipairs(arrow_keys) do
    keymap("n", key, "<Nop>", { noremap = true })
end

-- NetRW
keymap("n", "<leader>b", ":Lexplore<CR>", {})

-- TagBar
keymap("n", "<leader>tb", ":TagbarToggle<CR>", {})

-- Telescope
vim.keymap.set("n", "<leader>ff", tscope.find_files, {})
vim.keymap.set("n", "<leader>fg", tscope.live_grep, {})
vim.keymap.set("n", "<leader>fb", tscope.buffers, {})

------------------------------------------------
------------------------------------------------
------------------ Lualine
------------------------------------------------
------------------------------------------------
---
local lualine = require('lualine')

lualine.setup {
    options = {
        icons_enabled = true,
        theme = 'spaceduck',
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {},
        lualine_z = {}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {}
    },
}


------------------------------------------------
------------------------------------------------
------------------ Treesitter
------------------------------------------------
------------------------------------------------
local treesitter = require('nvim-treesitter.configs')

treesitter.setup {
  indent = {
    enable = true,
  },
  ensure_installed = { "python", "javascript", "typescript", "c", "lua", "haskell" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
