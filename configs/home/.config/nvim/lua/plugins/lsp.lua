-- Native LSP (Neovim 0.11+ API): configure with vim.lsp.config(), turn on with
-- vim.lsp.enable(). No `require('lspconfig').xxx.setup{}` (that's the legacy path).
--
-- nvim-lspconfig is present only as a DATA provider — it ships lsp/<server>.lua
-- files (default cmd/root_markers/filetypes) that vim.lsp.enable() reads. We never
-- call its setup functions.
--
-- C# is handled separately by roslyn.nvim (see roslyn.lua).
return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = { 'saghen/blink.cmp' },
  config = function()
    -- 1) Diagnostics UI
    vim.diagnostic.config({
      virtual_text = { spacing = 2, prefix = '●' },
      severity_sort = true,
      float = { border = 'rounded', source = true },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = '',
          [vim.diagnostic.severity.WARN]  = '',
          [vim.diagnostic.severity.HINT]  = '',
          [vim.diagnostic.severity.INFO]  = '',
        },
      },
    })

    -- 2) Advertise blink.cmp's completion capabilities to every server
    vim.lsp.config('*', {
      capabilities = require('blink.cmp').get_lsp_capabilities(),
    })

    -- 3) Per-server overrides (on top of nvim-lspconfig's defaults)
    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          -- recognise the `vim` global in your config files
          diagnostics = { globals = { 'vim', 'Snacks' } },
        },
      },
    })

    vim.lsp.config('basedpyright', {
      settings = {
        basedpyright = {
          analysis = { typeCheckingMode = 'standard', autoImportCompletions = true },
        },
      },
    })

    -- ruff runs alongside basedpyright as linter+formatter; silence its hover so
    -- basedpyright owns hover docs.
    vim.lsp.config('ruff', {
      on_attach = function(client)
        client.server_capabilities.hoverProvider = false
      end,
    })

    -- 4) Turn the servers on (roslyn is enabled by roslyn.nvim, not here)
    vim.lsp.enable({ 'lua_ls', 'vtsls', 'basedpyright', 'ruff' })

    -- 5) Buffer-local keymaps, set when any server attaches
    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(ev)
        local function map(keys, fn, desc)
          vim.keymap.set('n', keys, fn, { buffer = ev.buf, desc = 'LSP: ' .. desc })
        end
        -- Navigation via the snacks picker (consistent UI with the rest of the setup)
        map('gd', function() Snacks.picker.lsp_definitions() end, 'Definition')
        map('gr', function() Snacks.picker.lsp_references() end, 'References')
        map('gI', function() Snacks.picker.lsp_implementations() end, 'Implementation')
        map('gy', function() Snacks.picker.lsp_type_definitions() end, 'Type definition')
        map('<leader>ss', function() Snacks.picker.lsp_symbols() end, 'Document symbols')
        -- Call hierarchy: who calls this function (incoming) / what it calls (outgoing).
        -- Results land in the quickfix — view them with <leader>xQ (Trouble).
        map('<leader>ci', vim.lsp.buf.incoming_calls, 'Incoming calls (callers)')
        map('<leader>co', vim.lsp.buf.outgoing_calls, 'Outgoing calls (callees)')
        -- Actions
        map('K', vim.lsp.buf.hover, 'Hover')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
        map('<leader>rn', vim.lsp.buf.rename, 'Rename')
        map('<leader>ds', vim.diagnostic.open_float, 'Line diagnostics')
        -- Inlay hints toggle
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
        end, 'Toggle inlay hints')
      end,
    })
  end,
}
