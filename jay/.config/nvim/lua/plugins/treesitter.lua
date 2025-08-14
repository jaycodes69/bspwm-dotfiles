return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function () 
    local configs = require("nvim-treesitter.configs")

    configs.setup({

      -- A list of parser names, or "all" (the listed parsers MUST always be installed)
      ensure_installed = { 
        "c",
        "cpp",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "markdown",
        "markdown_inline"
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      highlight = { enable = true },
      indent = { enable = true },  
    })
  end
}
