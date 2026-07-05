-- Editor options. `vim.o` is the modern unified setter (0.10+).

local o = vim.o

-- Line numbers (ported from your init.vim: `set nu rnu`)
o.number = true
o.relativenumber = true

-- Mouse (ported: `set mouse=a`)
o.mouse = 'a'

-- True colour — required for modern themes / treesitter highlighting
o.termguicolors = true

-- Keep the sign column always on so gitsigns/diagnostics don't shift text
o.signcolumn = 'yes'

-- Sensible search
o.ignorecase = true
o.smartcase = true   -- case-sensitive only if the query has a capital
o.hlsearch = true

-- Splits open where you'd expect
o.splitright = true
o.splitbelow = true

-- Keep some context around the cursor
o.scrolloff = 6

-- Persistent undo across sessions
o.undofile = true

-- Faster CursorHold + gitsigns updates
o.updatetime = 250

-- Indentation fallback. Neovim honours .editorconfig natively, so per-project
-- rules (C# = 4, web = 2, etc.) win over these defaults.
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2

-- Treesitter-based folding, but start fully unfolded (no surprise closed folds)
o.foldmethod = 'expr'
o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
o.foldlevelstart = 99

-- Reflect external edits (e.g. from git, formatters, or another tool) into open
-- buffers. `autoread` + an explicit checktime on focus does the actual work.
o.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
  callback = function()
    if vim.fn.mode() ~= 'c' and vim.fn.getcmdwintype() == '' then
      vim.cmd('checktime')
    end
  end,
})
