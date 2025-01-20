return {
  {
    "mbbill/undotree",
    vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle, { desc = "Undo tree toggle" }),
    config = function()
      if vim.fn.has("persistent_undo") == 1 then
        local target_path = vim.fn.expand("~/.undodir")
        -- Create the directory if it doesn't exist
        if vim.fn.isdirectory(target_path) == 0 then
          vim.fn.mkdir(target_path, "p", 0700)
        end
        vim.opt.undodir = target_path
        vim.opt.undofile = true
      end
    end,
  },
}
