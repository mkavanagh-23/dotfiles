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
-- vim.keymap.set("n", "<leader>sm", function()
--   vim.cmd.vnew()
--   vim.cmd.term()
--   vim.cmd.wincmd("J")
--   vim.api.nvim_win_set_height(0, 10)
--   vim.fn.chansend(vim.b.terminal_job_id, "cat /dev/ttyUSB0\n")
-- end)

vim.keymap.set("n", "<leader>sm", function()
  -- Get the dimensions of the current window and calculate the center position
  local width = vim.o.columns
  local height = vim.o.lines
  local win_width = 80  -- Width of the floating window
  local win_height = 20 -- Height of the floating window
  local col = math.floor((width - win_width) / 2)
  local row = math.floor((height - win_height) / 2)

  -- Create a floating window
  local opts = {
    relative = 'editor',
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'single',
  }
  local buf = vim.api.nvim_create_buf(false, true)  -- Create an empty buffer
  local win = vim.api.nvim_open_win(buf, true, opts)  -- Open a floating window with the buffer

  -- Open terminal in the floating window and get the job ID
  local job_id = vim.fn.termopen("cat /dev/ttyUSB0", {
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        print("Terminal job failed!")
      end
    end
  })

  -- Set the window height as per the requirement
  vim.api.nvim_win_set_height(win, win_height)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'terminal')
  vim.cmd('startinsert')  -- Start insert mode for the terminal
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
