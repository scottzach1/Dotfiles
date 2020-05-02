" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

" Install Dracula color scheme
Plug 'dracula/vim', { 'as': 'dracula' }

" Initialize plugin system
call plug#end()

set relativenumber
set nu rnu
