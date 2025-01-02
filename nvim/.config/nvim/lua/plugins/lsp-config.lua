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
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      -- Set keymaps for lsp actions
      local on_attach = function(_, _)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {})
        vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
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
        on_attach = on_attach,
        capabilities = capabilities
      })
      lspconfig.hyprls.setup({
        on_attach = on_attach,
        capabilities = capabilities
      })

    end
  }
}
