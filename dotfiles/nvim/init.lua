local g = vim.g
local opt = vim.opt
local keymappings = {}
local cmd = vim.api.nvim_command
local keymap = vim.api.nvim_set_keymap

local function map_key(mode, input, output, opts, note)
    vim.keymap.set(mode, input, output, opts)
    table.insert(keymappings, {
        mode = mode,
        input = input,
        output = output,
        opts = opts,
        note = note
    })
end

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
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    },                                  --https://github.com/lukas-reineke/indent-blankline.nvim
    "romgrk/barbar.nvim",               --https://github.com/romgrk/barbar.nvim
    "lewis6991/gitsigns.nvim",          --https://github.com/lewis6991/gitsigns.nvim
    "sbdchd/neoformat",                 --https://github.com/sbdchd/neoformat
    "rebelot/kanagawa.nvim",            --https://github.com/rebelot/kanagawa.nvim
    "preservim/tagbar",                 --https://github.com/preservim/tagbar
    "neovim/nvim-lspconfig",            --https://github.com/neovim/nvim-lspconfig
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function ()
          local configs = require("nvim-treesitter.configs")

          configs.setup({
              ensure_installed = { "c", "lua", "vim", "vimdoc", "javascript", "html" },
              sync_install = false,
              highlight = { enable = true },
              indent = { enable = true },
            })
        end
     },                                 --https://github.com/nvim-treesitter/nvim-treesitter
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
g.neoformat_try_node_exe = 1

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
opt.hlsearch = true
opt.incsearch = true

---- Filetype specific stuff
local ind_2 = {
    "html","dot","vue",
    "javascript","json",
    "javascriptreact","css",
    "haskell","jsx","ts",
    "tsx","typescript",
    "typescriptreact"
}
local ind_4 = {"c","cpp","lua","java"}

-- indentation
for i=1,#ind_2,1 do
    local _cmd = string.format("au FileType %s setlocal shiftwidth=2 softtabstop=2 expandtab", ind_2[i])
    cmd(_cmd)
end

for i=1,#ind_4,1 do
    local _cmd = string.format("au FileType %s setlocal shiftwidth=4 softtabstop=4 expandtab", ind_4[i])
    cmd(_cmd)
end

---- Clean up files on read/write
local function clean_up_buf()
    vim.cmd("retab")
    vim.cmd [[keeppatterns %substitute/\v\s+$//eg]]
end

vim.api.nvim_create_augroup("au_clean_up", {clear = true})
vim.api.nvim_create_autocmd("BufWritePre", {group = "au_clean_up", pattern = "*", callback = clean_up_buf})

---- Colorscheme
local kanagawa = require("kanagawa").setup {
    transparent = true,
    theme = "dragon",
    colors = {
    theme = {
        all = {
            ui = {
                bg_gutter = "none"
            }
        }
    }
}
}

vim.cmd.colorscheme "kanagawa"

cmd("highlight Comment guifg=#ff5d62")

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

-- Clipboard
opt.clipboard = "unnamedplus"

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
-- lspconfig.tsserver.setup {}

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
    map_key('n', 'gD', vim.lsp.buf.definition, bopts, "LSP: go to definition")
    map_key('n', 'gd', vim.lsp.buf.declaration, bopts, "LSP: go to declaration")
    map_key('n', 'gi', vim.lsp.buf.implementation, bopts, "LSP: go to implementation")
    map_key('n', '<leader>rn', vim.lsp.buf.rename, bopts, "LSP: rename")
  end,
})

---- Update diagnostics in I mode
vim.diagnostic.config({
  update_in_insert = true,
})

---- Diagnostics in window
local function open_diagnostic_win()
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

map_key({'n', 'i'}, '<C-d>', open_diagnostic_win, {}, "LSP: Open diagnostics")

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
    map_key(mode, "ö", "<esc>", { noremap = true }, "GENERAL: Replace <Esc> with Ö")
end

-- Disable arrow keys in normal mode
local arrow_keys = {"<Left>", "<Right>", "<Up>", "<Down>"}

for _, key in ipairs(arrow_keys) do
    keymap("n", key, "<Nop>", { noremap = true })
end

-- NetRW
map_key("n", "<leader>b", ":Lexplore<CR>", {}, "NetRW: Toggle")

-- TagBar
map_key("n", "<leader>tb", ":TagbarToggle<CR>", {}, "TagBar: Toggle")

-- Telescope
map_key("n", "<leader>ff", tscope.find_files, {}, "Telescope: Find files")
map_key("n", "<leader>fg", tscope.live_grep, {}, "Telescope: Live grep")
map_key("n", "<leader>fb", tscope.buffers, {}, "Telescope: Buffers")

-- Neoformat
map_key("n", "<leader>fmt", ":Neoformat<CR>", {}, "Neoformat: do it")

-- BarBar
-- navigation
map_key("n", "gq", ":BufferClose<CR>", { noremap = true }, "BarBar: close buffer")
map_key("n", "gt", ":BufferNext<CR>", { noremap = true }, "BarBar: go right")
map_key("n", "gT", ":BufferPrevious<CR>", { noremap = true }, "BarBar: go left")
map_key("n", "<leader>gt", ":BufferMoveNext<CR>", {}, "BarBar: move right")
map_key("n", "<leader>gT", ":BufferMovePrevious<CR>", {}, "BarBar: move left")
map_key("n", "<leader>g0", ":BufferLast<CR>", {}, "BarBar: go to last")
map_key("n", "<leader>gr", ":BufferRestore<CR>", {}, "BarBar: restore")
map_key("n", "<leader>gg", ":BufferPick<CR>", {}, "BarBar: magic pick")
map_key("n", "<leader>gacq", ":BufferCloseAllButCurrent<CR>", {}, "BarBar: close all but current")

for i=1,9,1 do
    map_key("n", string.format("g%d",i), string.format(":BufferGoto %d<CR>", i), {}, string.format("BarBar: go to %d", i))
end

-- sort
map_key("n", "<leader>god", ":BufferOrderByDirectory<CR>", {}, "BarBar: sort by dir")
map_key("n", "<leader>gon", ":BufferOrderByName<CR>", {}, "BarBar: sort by name")
map_key("n", "<leader>gob", ":BufferOrderByBufferNumber<CR>", {}, "BarBar: sort by buffer num")
map_key("n", "<leader>gol", ":BufferOrderByLanguage<CR>", {}, "BarBar: sort by language")
map_key("n", "<leader>gow", ":BufferOrderByWindowNumber<CR>", {}, "BarBar: sort by window num")

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
        theme = 'kanagawa',
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

------------------------------------------------
------------------------------------------------
------------------ BarBar
------------------------------------------------
------------------------------------------------
local barbar = require("barbar")

barbar.setup {
    animation = false,
    tabpages = false,
    hide = { extensions = true },
    auto_hide = 1
}

-- preserve normal buffer/window close behaviour
vim.api.nvim_create_autocmd("WinClosed", {
    callback = function(tbl)
        if vim.api.nvim_buf_is_valid(tbl.buf) then
            vim.api.nvim_buf_delete(tbl.buf, {})
        end
    end,
    group = vim.api.nvim_create_augroup("barbar_close_buf", {}),
})

------------------------------------------------
------------------------------------------------
------------------ Indent-Blankline
------------------------------------------------
------------------------------------------------
local ibl = require("ibl")
local hooks = require "ibl.hooks"

local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed",    { fg = "#892f31" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#7c6944" })
    vim.api.nvim_set_hl(0, "RainbowBlue",   { fg = "#415174" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#895634" })
    vim.api.nvim_set_hl(0, "RainbowGreen",  { fg = "#506538" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#714150" })
    vim.api.nvim_set_hl(0, "RainbowCyan",   { fg = "#42606d" })
end)

ibl.setup {
    indent = { highlight = highlight },
    whitespace = {
        highlight = highlight,
        remove_blankline_trail = false
    }
}
