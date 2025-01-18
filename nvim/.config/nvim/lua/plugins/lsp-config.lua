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
        ensure_installed = { "lua_ls", "bashls", "clangd", "cssls", "dockerls", "docker_compose_language_service", "arduino_language_server", "html", "hyprls"}
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
      -- Set keymaps for lsp actions
      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
          vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
        end
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
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
  }
}
