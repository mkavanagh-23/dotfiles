-- lazy.nvim
return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- add any options here
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      routes = {
        {
          -- Disable popups on save
          filter = {
            event = "msg_show",
            kind = "",
            find = "written",
          },
          opts = { skip = true },
        },
        {
          -- Disable popups on yank
          filter = {
            event = "msg_show",
            kind = "",
            find = "more lines",
          },
          opts = { skip = true },
        },
        {
          -- Filter wonky error on closing terminal
          -- COMMENT OUT BEFORE EDITNG terminal.lua
          filter = {
            event = "msg_show",
            kind = "",
            find = ".config/nvim/lua/config/terminal.lua",
          },
          opts = { skip = true },
        },
        {
          -- Filter out empty notifications
          filter = {
            event = "msg_show",
            kind = "",
            find = "^%s*$",
          },
          opts = { skip = true },
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false,        -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = true,        -- add a border to hover docs and signature help
      },
    })
    --require("notify").setup({
    --  background_colour = "#000000",
    --})
  end
}
