-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Set global vim options
vim.opt.showcmd = true
vim.opt.laststatus = 2
vim.opt.autoread = true

-- set spacing and use spaces instead of tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.wrap = false

-- set line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- set column at 80 chars
vim.opt.colorcolumn = "80,122,154,185"

-- yank to the system clipboard
vim.opt.clipboard = "unnamedplus"

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
