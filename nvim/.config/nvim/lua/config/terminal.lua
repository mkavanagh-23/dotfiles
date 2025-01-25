-- Set up terminal
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Set formatting for built-in terminal emulator',
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.api.nvim_buf_set_keymap(0, 't', '<S-Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
  end,
})

local terminal_win = nil
local terminal_buf = nil

function _G.toggle_terminal(win_width, win_height, command)
  -- Check if terminal is already open it, close if so
  if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
    vim.api.nvim_win_close(terminal_win, true)
    terminal_win = nil
    terminal_buf = nil
    return
  end

  -- Set values from input params
  win_width = win_width or 90      -- Width of the floating window
  win_height = win_height or 30    -- Height of the floating window
  command = command or vim.o.shell -- Use default shell if no command is specified

  -- Get the dimensions of the current window and calculate the center position
  local width = vim.o.columns
  local height = vim.o.lines
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

  -- Create an empty buffer if we dont have one
  if not terminal_buf or not vim.api.nvim_buf_is_valid(terminal_buf) then
    terminal_buf = vim.api.nvim_create_buf(false, true)
  end

  terminal_win = vim.api.nvim_open_win(terminal_buf, true, opts) -- Open a floating window

  local job_id = vim.fn.termopen(command, {
    on_exit = function()
      if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
        vim.api.nvim_win_close(terminal_win, true)
      end
      terminal_win = nil
      terminal_buf = nil
    end
  })

  -- Set the window height as per the requirement
  vim.api.nvim_win_set_height(terminal_win, win_height)
  vim.api.nvim_buf_set_option(terminal_buf, 'filetype', 'terminal')
  vim.cmd('startinsert') -- Start insert mode for the terminal
end

function _G.serial_monitor()
  -- Uncomment the below 7 lines to set serial monitor to short bottom window
  --   vim.cmd.vnew()
  --   vim.cmd.term()
  --   vim.cmd.wincmd("J")
  --   vim.api.nvim_win_set_height(0, 10)
  --   vim.fn.chansend(vim.b.terminal_job_id, "cat /dev/ttyUSB0\n")
  -- end

  -- Uncomment the below function to open serial monitor in floating window
  toggle_terminal(80, 20, "stty -F /dev/ttyUSB0 115200 && cat /dev/ttyUSB0")
end

function _G.find_and_replace()
  toggle_terminal(80, 30, "serpl")
end

-- Set the keymaps
vim.keymap.set("n", "<leader>sm", serial_monitor, { desc = "Open serial monitor on TTYUSB0" })
vim.keymap.set("n", "<leader>find", find_and_replace, { desc = "Find and replace" })
vim.keymap.set("n", "<leader>tt", toggle_terminal, { desc = "Toggle terminal" })
