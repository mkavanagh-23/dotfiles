return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {}
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      -- Toggle nvim-tree with Ctrl-N
      vim.keymap.set('n', '<c-n>', ':NvimTreeFindFileToggle<CR>')
  end,
}
