local o = vim.o

o.number = true
o.numberwidth = 5
o.relativenumber = true
o.termguicolors = true

o.ignorecase = true
o.smartcase = true
o.incsearch = true

o.scrolloff = 8
o.sidescrolloff = 5
o.wrap = false

-- Colors & UI
o.background = "dark"
o.termguicolors = true
o.syntax = "on"

-- Search highlight
o.hlsearch = true

-- Cursor highlight
o.cursorline = true
o.cursorlineopt = "both"

-- Spell check (only when needed)
-- o.spell = true
-- o.spelllang = { "en" }

o.showmode = false
o.splitbelow = true
o.splitright = true

o.mouse = 'a'


o.undofile = true

o.shiftwidth = 2
o.tabstop = 2
o.smarttab = true
o.softtabstop = 2
o.expandtab = true
o.smartindent = true
o.cindent = true

o.foldenable = false
o.backup = false
o.swapfile = false

o.virtualedit = "block"
o.signcolumn = "yes"
