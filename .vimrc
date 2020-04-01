" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Install Dracula color scheme
Plug 'dracula/vim', { 'as': 'dracula' }

" Initialize plugin system
call plug#end()
