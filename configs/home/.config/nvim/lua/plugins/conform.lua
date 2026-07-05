-- conform.nvim — format-on-save, per-language. Prefers dedicated formatters and
-- falls back to the LSP formatter when none is configured/installed.
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    { '<leader>cf', function() require('conform').format({ async = true, lsp_format = 'fallback' }) end, desc = 'Format buffer' },
  },
  opts = {
    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_organize_imports', 'ruff_format' },
      -- Web: matches the repo's Biome setup (biome.json). conform uses a local
      -- node_modules/.bin/biome if present, else a global one.
      javascript = { 'biome' },
      typescript = { 'biome' },
      javascriptreact = { 'biome' },
      typescriptreact = { 'biome' },
      json = { 'biome' },
      jsonc = { 'biome' },
      css = { 'biome' },
      -- C#: csharpier (dotnet global tool)
      cs = { 'csharpier' },
    },
    -- SQL/others with no formatter here fall back to the LSP formatter.
    default_format_opts = { lsp_format = 'fallback' },
    format_on_save = { timeout_ms = 2500, lsp_format = 'fallback' },
  },
}
