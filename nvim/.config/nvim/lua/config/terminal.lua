function _G.serial_monitor()
  -- Uncomment the below 7 lines to set serial monitor to short bottom window
  --   vim.cmd.vnew()
  --   vim.cmd.term()
  --   vim.cmd.wincmd("J")
  --   vim.api.nvim_win_set_height(0, 10)
  --   vim.fn.chansend(vim.b.terminal_job_id, "cat /dev/ttyUSB0\n")
  -- end

  --Uncomment the below 36 lines to open serial monitor in floating window
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
  local buf = vim.api.nvim_create_buf(false, true)   -- Create an empty buffer
  local win = vim.api.nvim_open_win(buf, true, opts) -- Open a floating window with the buffer

  -- Open terminal in the floating window and get the job ID
  local job_id = vim.fn.termopen("stty -F /dev/ttyUSB0 115200 && cat /dev/ttyUSB0", {
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        print("Terminal job failed!")
      end
    end
  })

  -- Set the window height as per the requirement
  vim.api.nvim_win_set_height(win, win_height)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'terminal')
  vim.cmd('startinsert') -- Start insert mode for the terminal
  vim.wo.winbar = '' -- Disable winbar in the terminal
end

function _G.find_and_replace()
  -- Get the dimensions of the current window and calculate the center position
  local width = vim.o.columns
  local height = vim.o.lines
  local win_width = 80  -- Width of the floating window
  local win_height = 30 -- Height of the floating window
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
  local buf = vim.api.nvim_create_buf(false, true)   -- Create an empty buffer
  local win = vim.api.nvim_open_win(buf, true, opts) -- Open a floating window with the buffer

  -- Open terminal in the floating window and get the job ID
  local job_id = vim.fn.termopen("serpl", {
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        print("Terminal job failed!")
      end
    end
  })

  -- Set the window height as per the requirement
  vim.api.nvim_win_set_height(win, win_height)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'terminal')
  vim.cmd('startinsert') -- Start insert mode for the terminal
  vim.wo.winbar = '' -- Disable winbar in the terminal
end

-- Set the keymaps
vim.keymap.set("n", "<leader>sm", serial_monitor, { desc = "Open serial monitor on TTYUSB0" })
vim.keymap.set("n", "<leader>find", find_and_replace, { desc = "Find and replace" })
