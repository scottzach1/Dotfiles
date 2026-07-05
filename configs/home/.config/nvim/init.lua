-- Modern native Neovim config (0.12+). This is the default config (plain `nvim`).
-- Old vim-plug config backed up at ~/.config/nvim-old (and ~/.local/{share,state}/nvim-old).

-- Leader MUST be set before lazy.nvim loads, so plugin `keys` specs bind correctly.
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.options')
require('config.keymaps')
require('config.lazy')
