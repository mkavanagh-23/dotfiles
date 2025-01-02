-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- vim options
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


-- Set up terminal
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Set formatting for buil-in terminal emulator',
  group = vim.api.nvim_create_augroup('custom-term-open', {clear = true}),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
  end,
})
-- Set custom mapping for serial monitor
vim.keymap.set("n", "<leader>sm", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 10)
  vim.fn.chansend(vim.b.terminal_job_id, "cat /dev/ttyUSB0\n")
end)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- import your plugins
    { import = "plugins" },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
