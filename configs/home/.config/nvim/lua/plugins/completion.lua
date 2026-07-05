-- blink.cmp — completion engine (the modern, fast alternative to nvim-cmp).
-- `version = '1.*'` pulls a prebuilt fuzzy-matcher binary from the release, so
-- there is NO Rust/cargo compile step.
return {
  'saghen/blink.cmp',
  version = '1.*',
  event = 'InsertEnter',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' = vim-idiomatic: <C-space> open, <C-y> accept, <C-n>/<C-p> cycle,
    -- <C-e> hide. (Switch to 'super-tab' or 'enter' if you'd rather Tab/CR accept.)
    keymap = { preset = 'default' },

    appearance = { nerd_font_variant = 'mono' },

    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
      menu = { border = 'rounded' },
    },

    signature = { enabled = true },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- Warn (don't hard-fail) if the prebuilt binary ever isn't available
    fuzzy = { implementation = 'prefer_rust_with_warning' },
  },
  opts_extend = { 'sources.default' },
}
