return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        background = {   -- :h background
          light = "latte",
          dark = "mocha",
        },
        transparent_background = true, -- disables setting the background color.
        show_end_of_buffer = false,  -- shows the '~' characters after the end of buffers
        term_colors = true,          -- sets terminal colors (e.g. `g:terminal_color_0`)
        dim_inactive = {
          enabled = false,           -- dims the background color of inactive window
          shade = "dark",
          percentage = 0.15,         -- percentage of the shade to apply to the inactive window
        },
        no_italic = false,           -- Force no italic
        no_bold = false,             -- Force no bold
        no_underline = false,        -- Force no underline
        styles = {                   -- Handles the styles of general hi groups (see `:h highlight-args`):
          comments = { "italic" },   -- Change the style of comments
          conditionals = { "italic" },
          loops = {},
          functions = {},
          keywords = {},
          strings = {},
          variables = {},
          numbers = {},
          booleans = {},
          properties = {},
          types = {},
          operators = {},
          -- miscs = {}, -- Uncomment to turn off hard-coded styles
        },
        color_overrides = {},
        custom_highlights = {},
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          mini = {
            enabled = true,
            indentscope_color = "",
          },
          mason = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { "italic" },
              hints = { "italic" },
              warnings = { "italic" },
              information = { "italic" },
            },
            underlines = {
              errors = { "underline" },
              hints = { "underline" },
              warnings = { "underline" },
              information = { "underline" },
            },
            inlay_hints = {
              background = true,
            },
          },
          telescope = {
            enabled = true,
            -- style = "nvchad"
          },
          alpha = true,
          indent_blankline = {
            enabled = true,
            scope_color = "#6c7086",
            colored_indent_levels = true,
          },
          markdown = true,
          noice = true,
          navic = {
            enabled = true,
            custom_bg = "lualine"
          },
          notify = true,
          which_key = true,
        },
      })
      vim.o.termguicolors = true
      vim.cmd [[ colorscheme catppuccin ]]
    end,
  },
  --{
  --  "dgox16/oldworld.nvim",
  --  lazy = false,
  --  priority = 1000,
  --  config = function()
  --    require("oldworld").setup({
  --      terminal_colors = true, -- enable terminal colors
  --      variants = "default",   -- Two variants availables: default and cooler
  --      styles = {              -- You can pass the style using the format: style = true
  --        comments = {},        -- style for comments
  --        keywords = {},        -- style for keywords
  --        identifiers = {},     -- style for identifiers
  --        functions = {},       -- style for functions
  --        variables = {},       -- style for variables
  --        booleans = {},        -- style for booleans
  --      },
  --      integrations = {        -- You can disable/enable integrations
  --        alpha = true,
  --        cmp = true,
  --        flash = true,
  --        gitsigns = true,
  --        hop = false,
  --        indent_blankline = true,
  --        lazy = true,
  --        lsp = true,
  --        markdown = true,
  --        mason = true,
  --        navic = false,
  --        neo_tree = false,
  --        neorg = false,
  --        noice = true,
  --        notify = true,
  --        rainbow_delimiters = true,
  --        telescope = true,
  --        treesitter = true,
  --      },
  --      highlight_overrides = {}
  --    })
  --  vim.cmd [[ colorscheme oldworld ]]
  --  end
  --},
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
