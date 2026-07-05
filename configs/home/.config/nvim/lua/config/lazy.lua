-- Bootstrap lazy.nvim (clones itself on first launch), then load lua/plugins/*.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = { { import = 'plugins' } },
  -- Fall back to dracula while plugins install on first run
  install = { colorscheme = { 'dracula', 'habamax' } },
  -- You pin versions via lazy-lock.json + :Lazy update, not auto-updates
  checker = { enabled = false },
  change_detection = { notify = false },
})
