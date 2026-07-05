-- snacks.nvim — one plugin covering picker, explorer, terminal, lazygit, plus
-- quality-of-life modules. This is your fzf.vim + nerdtree replacement.
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },   -- disable heavy features on huge files
    quickfile = { enabled = true }, -- render a file before plugins load
    notifier = { enabled = true },  -- pretty :messages / vim.notify
    input = { enabled = true },     -- nicer vim.ui.input
    indent = { enabled = true },    -- indent guides
    picker = { enabled = true },
    explorer = { enabled = true },
    terminal = { enabled = true },
    lazygit = { enabled = true },
  },
  keys = {
    -- Muscle memory carried over from your init.vim:
    { ';', function() Snacks.picker.files() end, desc = 'Find files (was :Files)' },
    -- NOTE: this shadows the built-in <C-o> (jumplist back). Kept per your
    -- current mapping; revisit in Phase 2 when LSP navigation makes jumplist
    -- more valuable — you may want to move the explorer to <leader>e.
    { '<C-o>', function() Snacks.explorer() end, desc = 'File explorer (was NERDTree)' },

    -- Picker
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find files' },
    { '<leader>fg', function() Snacks.picker.grep() end, desc = 'Grep (live)' },
    { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Buffers' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent files' },
    { '<leader>fh', function() Snacks.picker.help() end, desc = 'Help pages' },
    { '<leader>fw', function() Snacks.picker.grep_word() end, desc = 'Grep word under cursor', mode = { 'n', 'x' } },
    { '<leader>fk', function() Snacks.picker.keymaps() end, desc = 'Keymaps' },

    -- Explorer / terminal / git
    { '<leader>e', function() Snacks.explorer() end, desc = 'File explorer' },
    -- Toggle from both normal AND terminal mode, so the same key closes it from inside
    { '<C-/>', function() Snacks.terminal() end, desc = 'Toggle terminal', mode = { 'n', 't' } },
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
  },
}
