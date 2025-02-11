return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup({
        hijack_netrw = true,
        git = {
          enable = true,
          ignore = false,
          timeout = 500,
        },
        filters = {
          dotfiles = false,
        }
      })
      -- Toggle nvim-tree with Ctrl-N
      vim.keymap.set('n', '<c-n>', ':NvimTreeFindFileToggle<CR>', { desc = "" })
    end,
  },
  --{
  --  "nvim-neo-tree/neo-tree.nvim",
  --  branch = "v3.x",
  --  dependencies = {
  --    "nvim-lua/plenary.nvim",
  --    "nvim-tree/nvim-web-devicons",   -- not strictly required, but recommended
  --    "MunifTanjim/nui.nvim",
  --    { "3rd/image.nvim", opts = {} }, -- Optional image support in preview window: See `# Preview Mode` for more information
  --  },
  --  config = function()
  --    -- Automatically open Neotree when entering a directory
  --    vim.api.nvim_create_autocmd("VimEnter", {
  --      pattern = "*",
  --      callback = function()
  --        if vim.fn.isdirectory(vim.fn.expand("%:p")) == 1 then
  --          vim.cmd("Neotree position=current")
  --        end
  --      end,
  --    })
  --    --Set the keymap to open sidebar
  --    --vim.keymap.set('n', '<c-n>', ':Neotree toggle<CR>', { desc = "" })
  --  end
  --},
}
