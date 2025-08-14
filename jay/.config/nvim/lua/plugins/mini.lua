return {
  'echasnovski/mini.nvim',
  version = false,
  config = function()
    local pairs = require("mini.pairs")
    local surround = require("mini.surround")
    local icons = require("mini.icons")
    local trailspace = require("mini.trailspace")
    local basics = require("mini.basics")

    pairs.setup({
    })

    surround.setup({
    })

    icons.setup({
    })

    trailspace.setup({
    })

    basics.setup({
    })


  end,
}
