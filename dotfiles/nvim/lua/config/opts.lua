local opt = vim.opt
local cmd = vim.api.nvim_command

-- Behaviour
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

cmd("au Filetype html setlocal sw=2 expandtab")
cmd("au Filetype javascript setlocal sw=2 expandtab")
cmd("au Filetype javascriptreact setlocal sw=2 expandtab")
cmd("au Filetype css setlocal sw=2 expandtab")

---- Tabs / indent
opt.shiftwidth = 4 
opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.wrap = false
opt.smartindent = true

-- Visual Experience TM
opt.number = true
opt.relativenumber = true
opt.cmdheight = 1
opt.scrolloff = 8

-- Completion
opt.completeopt = "menuone,noinsert,noselect"
