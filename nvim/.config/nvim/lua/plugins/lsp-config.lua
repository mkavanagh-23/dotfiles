return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "bashls", "clangd", "cssls", "dockerls", "docker_compose_language_service", "arduino_language_server", "html", "hyprls" }
      })
    end
  },
  {
    "SmiteshP/nvim-navic",
    config = function()
      require("nvim-navic").setup({
        lsp = {
          auto_attach = true,
          preference = nil,
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local navic = require("nvim-navic")

      -- Define actions on buffer attach to language server
      local on_attach = function(client, bufnr)
        -- Set context for winbar
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
          vim.wo.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        end

        -- Set keymaps for lsp actions
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr, desc = "Rename current buffer" })
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr, desc = "Take code action" })
        vim.keymap.set('n', '<leader>fmt', function()
          vim.lsp.buf.format({ async = true })
        end, { buffer = bufnr, desc = "Format document" })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr, desc = "Get definition" })
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = bufnr, desc = "Get implementation" })
        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references,
          { buffer = bufnr, desc = "Get references" })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover details" })

        -- Auto-format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("LspAutoFormat", { clear = true }),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ async = true })
          end,
        })
      end

      local toggle_wrap = function()
        if vim.wo.wrap then
          vim.wo.wrap = false
          vim.wo.breakindent = false
          vim.wo.breakindentopt = ''
        else
          vim.wo.wrap = true
          vim.wo.breakindent = true
          vim.wo.breakindentopt = 'shift:3'
        end
      end

      local on_attach_html = function(client, bufnr)
        on_attach(client, bufnr)
        toggle_wrap()
        vim.keymap.set('n', '<leader>tw', toggle_wrap, { desc = "Toggle wrapping and indentation" })
      end

      lspconfig.lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities
      })
      lspconfig.bashls.setup({
        on_attach = on_attach,
        capabilities = capabilities
      })
      lspconfig.clangd.setup({
        on_attach = on_attach,
        capabilities = capabilities
      })
      lspconfig.cssls.setup({
        on_attach = on_attach,
        capabilities = capabilities
      })
      lspconfig.dockerls.setup({
        on_attach = on_attach,
        capabilities = capabilities
      })
      lspconfig.docker_compose_language_service.setup({
        on_attach = on_attach,
        capabilities = capabilities
      })
      lspconfig.arduino_language_server.setup({
        on_attach = on_attach,
        capabilities = capabilities
      })
      lspconfig.html.setup({
        on_attach = on_attach_html,
        capabilities = capabilities,
      })
      lspconfig.hyprls.setup({
        on_attach = on_attach,
        capabilities = capabilities
      })
    end
  },
  {
    "fgheng/winbar.nvim",
    config = function()
      -- Import winbar setup
      require("winbar").setup({
        enabled = true,
        show_context = true, -- Show context in winbar
        colors = {
          path = '',         -- You can customize colors like #c946fd
          file_name = '',
          symbols = '',
        },
        icons = {
          file_icon_default = '',
          seperator = '>',
          editor_state = '●',
          lock_icon = '',
        },
        exclude_filetype = {
          'help',
          'startify',
          'dashboard',
          'packer',
          'neogitstatus',
          'NvimTree',
          'Trouble',
          'alpha',
          'lir',
          'Outline',
          'spectre_panel',
          'toggleterm',
          'qf',
        }
      })

      -- Custom winbar setup to include nvim-navic
      local function get_lsp_context()
        local navic = require("nvim-navic")
        return navic.get_location()
      end

      -- Define excluded types to prevent setting bar again
      local excluded_filetypes = {
        help = true,
        startify = true,
        dashboard = true,
        packer = true,
        neogitstatus = true,
        NvimTree = true,
        Trouble = true,
        alpha = true,
        lir = true,
        Outline = true,
        spectre_panel = true,
        toggleterm = true,
        qf = true,
      }

      -- Update winbar dynamically
      vim.api.nvim_create_autocmd({ "BufWinEnter", "CursorMoved", "BufEnter" }, {
        callback = function()
          local filetype = vim.bo.filetype
          local lsp_context = get_lsp_context()
          if not excluded_filetypes[filetype] then
            if lsp_context ~= "" then
              vim.wo.winbar = vim.wo.winbar .. " > " .. lsp_context
            end
          end
        end,
      })
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          -- Defaults
          enable_close = true,         -- Auto close tags
          enable_rename = true,        -- Auto rename pairs of tags
          enable_close_on_slash = true -- Auto close on trailing </
        },
        -- Also override individual filetype configs, these take priority.
        -- Empty by default, useful if one of the "opts" global settings
        -- doesn't work well in a specific filetype
      })
    end
  }
}
