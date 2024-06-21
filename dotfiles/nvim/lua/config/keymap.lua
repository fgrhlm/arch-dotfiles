local keymap = vim.api.nvim_set_keymap

keymap("n", " ", "<Nop>", {silent = true})
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- behaviour

local modes = {"i", "n", "v"}

for _, mode in ipairs(modes) do
    keymap(mode, "ö", "<esc>", { noremap = true })
end

local arrow_keys = {"<Left>", "<Right>", "<Up>", "<Down>"}

for _, key in ipairs(arrow_keys) do
    keymap("n", key, "<Nop>", { noremap = true })
end

-- NetRW
keymap("n", "<leader>b", ":Lexplore<CR>", {})

-- TagBar
keymap("n", "<leader>tb", ":TagbarToggle<CR>", {})

-- Prettier
keymap("n", "<leader>fmj", ":silent %!prettier --stdin-filepath %<CR>", {})

-- Black
keymap("n", "<leader>fmp", ":silent %!black -q - < %<CR>", {})

-- Telescope
local tscope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tscope.find_files, {})
vim.keymap.set("n", "<leader>fg", tscope.live_grep, {})
vim.keymap.set("n", "<leader>fb", tscope.buffers, {})
