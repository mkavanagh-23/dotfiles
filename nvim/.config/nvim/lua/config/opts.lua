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
vim.opt.colorcolumn = "80,144,182"

-- yank to the system clipboard
vim.opt.clipboard = "unnamedplus"

-- Set formatting for HTML and Markdown files
local toggle_wrap = function()
  if vim.wo.wrap then
    vim.wo.wrap = false
    vim.wo.breakindent = false
    vim.wo.breakindentopt = ''
  else
    vim.wo.wrap = true
    vim.wo.breakindent = true
    vim.wo.breakindentopt = 'shift:3'
  end
end
-- And apply it with a keymap on filetype attach
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "html", "markdown" },
  callback = function()
    toggle_wrap()
    vim.keymap.set('n', '<leader>tw', toggle_wrap, { desc = "Toggle wrapping and indentatiton" })
  end
})
