-- Dracula, ported to the Lua-native port (real treesitter + LSP semantic
-- highlighting, unlike the old vimscript dracula/vim).
return {
  'Mofiqul/dracula.nvim',
  lazy = false,      -- the main UI theme should always load
  priority = 1000,   -- ...and load before everything else
  config = function()
    require('dracula').setup({})
    vim.cmd.colorscheme('dracula')
  end,
}
