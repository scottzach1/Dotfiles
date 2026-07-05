-- vim-dadbod (+ UI) — run SQL against a database from inside nvim. For your
-- Supabase Postgres: `:DBUIAddConnection` and paste a connection string, e.g.
--   postgresql://postgres:<pw>@db.<ref>.supabase.co:5432/postgres
-- or set $DATABASE_URL and it appears automatically. `\` runs the query buffer.
return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
  },
  cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_show_database_icon = 1
  end,
  keys = {
    { '<leader>Db', '<cmd>DBUIToggle<cr>', desc = 'Toggle DB UI' },
    { '<leader>Da', '<cmd>DBUIAddConnection<cr>', desc = 'Add DB connection' },
    { '<leader>Df', '<cmd>DBUIFindBuffer<cr>', desc = 'Find DB buffer' },
  },
}
