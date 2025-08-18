return {
  {
    'norcalli/nvim-colorizer.lua',
    config = function()
      -- Attaches to every FileType mode
      require 'colorizer'.setup()

    end,
  },
  {
    'chomosuke/typst-preview.nvim',
    ft = 'typst',
    version = '1.*',
    opts = {}, -- lazy.nvim will implicitly calls `setup {}`
  }
}
