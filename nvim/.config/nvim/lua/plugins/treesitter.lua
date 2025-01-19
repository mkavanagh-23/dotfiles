return {
  "nvim-treesitter/nvim-treesitter",
  version = nil,
  build = function()
    require("nvim-treesitter.install").update({ with_sync = true })()
  end,

  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "regex", "lua", "python", "javascript", "c", "vim", "vimdoc", "query", "markdown", "markdown_inline", "cpp", "bash", "css", "html", "cmake", "hyprlang", "json", "latex", "make", "dockerfile", "typescript", "xml", "yaml" },
      -- A list of parser names, or "all" (the five listed parsers should always be installed)
      auto_install = true,

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}
