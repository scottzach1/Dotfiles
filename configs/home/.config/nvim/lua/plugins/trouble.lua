-- trouble.nvim — a pretty, navigable list for diagnostics, LSP results, quickfix,
-- and symbols. Pairs with the native diagnostics from lsp.lua.
return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  opts = {
    focus = true, -- move into the panel when it opens
  },
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics: project (Trouble)' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Diagnostics: buffer (Trouble)' },
    { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols outline (Trouble)' },
    { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP defs/refs (Trouble)' },
    { '<leader>xL', '<cmd>Trouble loclist toggle<cr>', desc = 'Location list (Trouble)' },
    { '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix list (Trouble)' },
  },
}
