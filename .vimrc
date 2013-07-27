" reference: http://blog.sanctum.geek.nz/gracefully-degrading-vimrc/

silent! execute pathogen#infect()

set nocompatible
set noerrorbells
set report=0 " report everything
set wildmenu " menu autocomplete
set smartcase " searching
set go-=T " remove toolbar in gvim
set directory=~/.vimswp " .swp files go here
set term=xterm

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
:noremap ; :
:map q: :q

" tabs
set autoindent
set cindent
set tabstop=2
set shiftwidth=2
set expandtab

" fix auto indent
filetype on
filetype plugin on
filetype indent on

" spelling ( [s ]s z= )
map <F5> :setlocal spell! spelllang=en_gb<cr>

" format xml
function! DoPrettyXML()
     let l:origft = &ft
     set ft=
     1s/<?xml .*?>//e
     0put ='<PrettyXML>'
     $put ='</PrettyXML>'
     silent %!xmllint --format -
     2d
     $d
     silent %<
     1
     exe "set ft=" . l:origft
     endfunction
command! PrettyXML call DoPrettyXML()
map <F6> :PrettyXML<CR>

" file types
if exists("g:loaded_pathogen")
"if exists('g:loaded_octopress') " not sure why this does not work :(
  autocmd BufNewFile,BufRead *.markdown set filetype=octopress
endif

" markdown
" https://github.com/plasticboy/vim-markdown
let g:vim_markdown_folding_disabled=1

" emacs follow
" http://stackoverflow.com/questions/6873076/auto-scrollable-pagination-with-vim-using-vertical-split
:nmap <silent> <Leader>ef :vsplit<bar>wincmd l<bar>exe "norm! Ljz<c-v><cr>"<cr>:set scb<cr>:wincmd h<cr> :set scb<cr>

