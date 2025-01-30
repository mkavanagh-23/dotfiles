return {
  {
    "dgox16/oldworld.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("oldworld").setup({
        terminal_colors = true, -- enable terminal colors
        variants = "default",   -- Two variants availables: default and cooler
        styles = {              -- You can pass the style using the format: style = true
          comments = {},        -- style for comments
          keywords = {},        -- style for keywords
          identifiers = {},     -- style for identifiers
          functions = {},       -- style for functions
          variables = {},       -- style for variables
          booleans = {},        -- style for booleans
        },
        integrations = {        -- You can disable/enable integrations
          alpha = true,
          cmp = true,
          flash = true,
          gitsigns = true,
          hop = false,
          indent_blankline = false,
          lazy = true,
          lsp = true,
          markdown = true,
          mason = true,
          navic = false,
          neo_tree = false,
          neorg = false,
          noice = true,
          notify = true,
          rainbow_delimiters = true,
          telescope = true,
          treesitter = true,
        },
        highlight_overrides = {}
      })
      vim.cmd [[ colorscheme oldworld ]]
      vim.cmd [[ highlight Normal ctermbg=none guibg=none ]]
    end
  },
  --{
  --  "RRethy/base16-nvim",
  --  config = function()
  --    require('base16-colorscheme').with_config({
  --      telescope = true,
  --      indentblankline = true,
  --      notify = true,
  --      ts_rainbow = true,
  --      cmp = true,
  --      illuminate = true,
  --      dapui = true,
  --    })
  --  end,
  --},
}
