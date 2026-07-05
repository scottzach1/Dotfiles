-- gitsigns.nvim — gutter signs, hunk navigation, inline blame.
-- Replaces vim-gitgutter (and does much more). Worktree-aware automatically.
return {
  'lewis6991/gitsigns.nvim',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    on_attach = function(bufnr)
      local gs = require('gitsigns')
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- Navigate hunks (nav_hunk is the current API; next_hunk/prev_hunk are deprecated)
      map('n', ']h', function() gs.nav_hunk('next') end, 'Next git hunk')
      map('n', '[h', function() gs.nav_hunk('prev') end, 'Prev git hunk')

      -- Act on hunks
      map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
      map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
      map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
      map('n', '<leader>hp', gs.preview_hunk, 'Preview hunk')
      map('n', '<leader>hb', function() gs.blame_line({ full = true }) end, 'Blame line')
      map('n', '<leader>hd', gs.diffthis, 'Diff against index')
    end,
  },
}
