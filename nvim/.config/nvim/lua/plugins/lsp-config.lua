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
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- Define actions on buffer attach to language server
      local on_attach = function(client, bufnr)
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
        --vim.api.nvim_create_autocmd("BufWritePre", {
        --  group = vim.api.nvim_create_augroup("LspAutoFormat", { clear = true }),
        --  buffer = bufnr,
        --  callback = function()
        --    vim.lsp.buf.format({ async = true })
        --  end,
        --})
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
        capabilities = capabilities,
      })
      lspconfig.hyprls.setup({
        on_attach = on_attach,
        capabilities = capabilities
      })
    end
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
  },
  {
    'Bekaboo/dropbar.nvim',
    -- optional, but required for fuzzy finder support
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
