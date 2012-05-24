set nocompatible
set noerrorbells
set report=0 " report everything
set wildmenu " menu autocomplete
set smartcase " searching
set go-=T " remove toolbar in gvim
set directory=~/.vimswp " .swp files go here

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

