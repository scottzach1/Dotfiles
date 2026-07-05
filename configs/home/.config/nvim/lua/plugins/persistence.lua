-- persistence.nvim — save/restore a session per working directory, so reopening
-- nvim in a project restores your windows, buffers, and layout.
-- Sessions save automatically on exit; loading is manual (no surprise restores).
return {
  'folke/persistence.nvim',
  event = 'BufReadPre',
  opts = {},
  keys = {
    { '<leader>qs', function() require('persistence').load() end, desc = 'Restore session (this dir)' },
    { '<leader>ql', function() require('persistence').load({ last = true }) end, desc = 'Restore last session' },
    { '<leader>qd', function() require('persistence').stop() end, desc = "Don't save this session" },
  },
}
