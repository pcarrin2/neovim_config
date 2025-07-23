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
vim.o.foldlevel = 999
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.updatetime = 1000
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

-- DIAGNOSTICS BEHAVIOR

-- show current line's diagnostics in message area
-- vim.cmd [[ autocmd! CursorHold * lua require'utils'.print_diagnostics() ]]

vim.api.nvim_create_autocmd({ "CursorHold" }, 
                            { pattern = "*",
                              callback = function() utils.print_diagnostics() end })

-- PLUGIN SUPPORT

-- install lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  print("Installing lazy.nvim...")
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
  print("Lazy.nvim installed!")
end
vim.opt.rtp:prepend(lazypath)

-- install plugins
return require("lazy").setup({
  -- Treesitter for syntax parsing
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    priority = 100,
  },
  
  -- Language Server Protocol support
  {
    "dundalek/lazy-lsp.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("lazy-lsp").setup {
        excluded_servers = {
          "pylyzer", -- false-positive errors regarding imports, overzealous type-checking
          "pyright" -- subset of basedpyright's capabilities
        }
      }
    end
  },
})
