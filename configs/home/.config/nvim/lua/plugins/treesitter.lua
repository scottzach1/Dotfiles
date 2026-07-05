-- nvim-treesitter (MAIN branch — the current rewrite for Neovim 0.11+).
-- The old `require('nvim-treesitter.configs').setup{ensure_installed=...}` API
-- is gone; parsers are installed with `.install{}` and highlighting is enabled
-- via Neovim's native `vim.treesitter.start()`.
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,           -- main branch does not support lazy-loading
  build = ':TSUpdate',
  config = function()
    -- The main branch ships highlight/indent QUERIES under <plugin>/runtime/, and
    -- requires that dir on the runtimepath (otherwise parsers work but nothing is
    -- highlighted for languages Neovim doesn't bundle queries for, e.g. C#/TS/SQL).
    vim.opt.rtp:prepend(vim.fn.stdpath('data') .. '/lazy/nvim-treesitter/runtime')

    -- Parsers for the Marloo stack. Idempotent: already-installed ones are skipped.
    require('nvim-treesitter').install({
      'c_sharp',                                  -- API (.NET)
      'typescript', 'tsx', 'javascript',          -- Web (React)
      'python',                                   -- Lambdas
      'sql',                                      -- Supabase
      'hcl', 'terraform',                        -- Infrastructure
      'lua', 'json', 'yaml', 'toml',
      'markdown', 'markdown_inline',
      'bash', 'dockerfile', 'html', 'css',
      'gitcommit', 'diff',
    })

    -- Start highlighting whenever a buffer has a parser available.
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(ev)
        pcall(vim.treesitter.start, ev.buf)
      end,
    })
  end,
}
