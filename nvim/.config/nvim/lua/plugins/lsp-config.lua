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
          vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"
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
      })

      -- Custom winbar setup to include nvim-navic
      local function get_winbar()
        local navic = require("nvim-navic")
        local winbar_text = vim.api.nvim_eval('"%f"') -- Get the file name as the base winbar

        -- Append LSP context if available
        if navic.is_available() then
          return winbar_text .. " " .. navic.get_location()
        else
          return winbar_text
        end
      end

      -- Update winbar dynamically
      vim.api.nvim_create_autocmd({ "BufWinEnter", "CursorMoved", "BufEnter" }, {
        callback = function()
          vim.o.winbar = get_winbar()
        end,
      })
    end,
  },
}
