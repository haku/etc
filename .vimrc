set nocompatible
set noerrorbells
set report=0 " report everything
set wildmenu " menu autocomplete
set smartcase " searching
set go-=T " remove toolbar in gvim

" tabs
" navigate: gt and gT
nnoremap <C-t> :tabnew<CR>

" appearance
:syntax on
set background=dark
colorscheme slate

" stop typos
:command WQ wq
:command Wq wq
:command W w
:command Q q
