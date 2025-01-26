-- SEE plugins.noice.lua BEFORE EDITING

-- Set up terminal
vim.api.nvim_create_autocmd('TermOpen', {
  desc = 'Set formatting for built-in terminal emulator',
  group = vim.api.nvim_create_augroup('custom-term-open', { clear = true }),
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.api.nvim_buf_set_keymap(0, 't', '<Esc><Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
  end,
})

local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

local function create_floating_window(opts)
  opts = opts or {}

  local scale = opts.scale or 0.8

  -- Default width and height are 80% of the screen dimensions
  local width = opts.width or math.floor(vim.o.columns * scale)
  local height = opts.height or math.floor(vim.o.lines * scale)

  -- Centered position
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Create a buffer
  local buf = opts.buf
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  -- Open the floating window
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal", -- Optionally, use "minimal" to remove window decorations
    border = "rounded",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local is_hidden = function(win)
  if not vim.api.nvim_win_is_valid(win) then
    return true -- If the window is invalid, consider it hidden or non-existent
  end

  -- Check the config for the window
  local config = vim.api.nvim_win_get_config(win)
  return config.relative == "" -- If relative config is empty then the window is hidden
end

local toggle_terminal = function()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window { buf = state.floating.buf }
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end

  if not is_hidden(state.floating.win) then
    vim.cmd("startinsert")
  end
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
  --toggle_terminal(80, 20, "stty -F /dev/ttyUSB0 115200 && cat /dev/ttyUSB0")
  local window = create_floating_window {
    scale = 0.5,
  }
  vim.fn.termopen("stty -F /dev/ttyUSB0 115200 && cat /dev/ttyUSB0", {
    on_exit = function()
      vim.api.nvim_buf_close(window.buf, true)
      vim.api.nvim_win_close(window.win, true)
    end
  })
  vim.cmd("startinsert")
end

function _G.find_and_replace()
  --toggle_terminal(80, 30, "serpl")
  local window = create_floating_window {
    scale = 0.6,
  }
  vim.fn.termopen("serpl", {
    on_exit = function()
      vim.api.nvim_win_close(window.win, true)
      vim.api.nvim_buf_close(window.buf, true)
    end
  })
  vim.cmd("startinsert")
end

-- Set the keymaps
vim.keymap.set("n", "<leader>sm", serial_monitor, { desc = "Open serial monitor on TTYUSB0" })
vim.keymap.set("n", "<leader>find", find_and_replace, { desc = "Find and replace" })
vim.keymap.set({ "n", "t" }, "<leader>tt", toggle_terminal, { desc = "Toggle terminal" })
vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
