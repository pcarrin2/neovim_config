local utils = require("utils")

-- BASIC SETTINGS
vim.o.number = true
vim.o.tabstop = 8
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.expandtab = true
vim.o.smartindent =  true
vim.o.wrap = false
vim.o.foldmethod = "syntax"
vim.o.splitright = true
vim.o.splitbelow = true
vim.cmd('syntax enable')
vim.cmd('filetype plugin indent on')

-- LEADER KEYBINDS
vim.g.mapleader = ' '

-- save files with sudo
vim.keymap.set('n', '<Leader>w', utils.sudo_write, 
  { silent = true, desc = "Save file with sudo" })

vim.keymap.set('n', '<Leader>q', utils.sudo_write_quit, 
  { silent = true, desc = "Save file with sudo, then quit" })

-- ergonomically handle split panes
vim.keymap.set('n', '<Leader>v', ":vnew<CR>", 
  { silent = true, desc = "Open a new buffer in a vsplit" })

vim.keymap.set('n', '<Leader>b', ":new<CR>", 
  { silent = true, desc = "Open a new buffer in an hsplit" })

vim.keymap.set('n', '<Leader>V', ":vsplit<CR>", 
  { silent = true, desc = "Open the current buffer in a vsplit" })

vim.keymap.set('n', '<Leader>B', ":split<CR>", 
  { silent = true, desc = "Open the current buffer in an hsplit" })

vim.keymap.set('n', '<Leader>h', ":wincmd h<CR>",
  { silent = true, desc = "Navigate splits: move left" })

vim.keymap.set('n', '<Leader>j', ":wincmd j<CR>",
  { silent = true, desc = "Navigate splits: move down" })

vim.keymap.set('n', '<Leader>k', ":wincmd k<CR>",
  { silent = true, desc = "Navigate splits: move up" })

vim.keymap.set('n', '<Leader>l', ":wincmd l<CR>",
  { silent = true, desc = "Navigate splits: move right" })
