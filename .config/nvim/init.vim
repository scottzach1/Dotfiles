" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.config/nvim/plugged')

" Install Dracula color scheme
Plug 'dracula/vim', { 'as': 'dracula' }

" File gutter
Plug 'preservim/nerdtree'

" Git Gutter
Plug 'airblade/vim-gitgutter'

" Fizzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Initialize plugin system
call plug#end()

set relativenumber
set nu rnu

map <C-o> :NERDTreeToggle<CR>
map ; :Files<CR>
