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
        ensure_installed = { "lua_ls", "bashls", "clangd", "cssls", "html", "sqls", "pylsp", "gopls" }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- === Universal LSP Keybindings (LspAttach replaces on_attach) ===
      vim.api.nvim_create_autocmd("LspAttach", {
        desc = "LSP keybindings and setup",
        callback = function(args)
          local bufnr = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          -- Core LSP keymaps
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map('n', '<leader>rn', vim.lsp.buf.rename, "Rename symbol")
          map('n', '<leader>ca', vim.lsp.buf.code_action, "Code action")
          map('n', '<leader>fmt', function() vim.lsp.buf.format({ async = true }) end, "Format document")
          map('n', 'gd', vim.lsp.buf.definition, "Go to definition")
          map('n', 'gi', vim.lsp.buf.implementation, "Go to implementation")
          map('n', 'gr', require('telescope.builtin').lsp_references, "References")
          map('n', 'K', vim.lsp.buf.hover, "Hover details")

          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { buffer = bufnr, desc = "Diagnostics" })

          vim.diagnostic.config({
            virtual_text = false,
            virtual_lines = true,
          })

          map('n', 'gK', function()
            local new = not vim.diagnostic.config().virtual_lines
            vim.diagnostic.config({ virtual_lines = new })
          end, "Toggle diagnostic virtual_lines")

          -- Optional autoformat on save (commented)
          -- vim.api.nvim_create_autocmd("BufWritePre", {
          --   group = vim.api.nvim_create_augroup("LspAutoFormat", { clear = true }),
          --   buffer = bufnr,
          --   callback = function()
          --     vim.lsp.buf.format({ async = true })
          --   end,
          -- })
        end
      })

      -- === New Config API ===
      local lsp = vim.lsp

      -- Define per-server configs using vim.lsp.config
      lsp.config.lua_ls = {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
          },
        },
      }

      lsp.config.bashls = { capabilities = capabilities }
      lsp.config.clangd = { capabilities = capabilities }
      lsp.config.cssls = { capabilities = capabilities }
      lsp.config.html = { capabilities = capabilities }
      lsp.config.sqls = { capabilities = capabilities }
      lsp.config.pylsp = { capabilities = capabilities }
      lsp.config.gopls = { capabilities = capabilities }

      -- Enable the servers
      for name, _ in pairs(lsp.config) do
        lsp.enable(name)
      end
    end
  },
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true
        },
      })
    end
  },
  {
    'Bekaboo/dropbar.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make'
    },
    config = function()
      local dropbar_api = require('dropbar.api')
      vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
      vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
      vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
    end
  },
}

