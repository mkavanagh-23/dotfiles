return {
    "nvim-treesitter/nvim-treesitter",
    version = nil,
    build = function()
        require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    config = function()
      require("nvim-treesitter.configs").setup({
	  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  	  ensure_installed = { "asm", "c", "cpp", "css", "go", "html", "lua", "vim", "vimdoc", "query" },

  	  -- Install parsers synchronously (only applied to `ensure_installed`)
  	  sync_install = false,

  	  -- Automatically install missing parsers when entering buffer
  	  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  	  auto_install = true,

  	  highlight = {
    		enable = true,
  	  },
      })
    end,
}
