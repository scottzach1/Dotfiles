-- Plugin-agnostic keymaps. Plugin keymaps live in each plugin's spec (`keys`).
local map = vim.keymap.set

-- Clear search highlight with Esc
map('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

-- Move between windows without the <C-w> prefix
map('n', '<C-h>', '<C-w>h', { desc = 'Window left' })
map('n', '<C-j>', '<C-w>j', { desc = 'Window down' })
map('n', '<C-k>', '<C-w>k', { desc = 'Window up' })
map('n', '<C-l>', '<C-w>l', { desc = 'Window right' })

-- Keep visual selection when re-indenting
map('v', '<', '<gv', { desc = 'Dedent and keep selection' })
map('v', '>', '>gv', { desc = 'Indent and keep selection' })

-- Terminal: double-Esc leaves terminal-insert mode (friendlier than <C-\><C-n>)
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
