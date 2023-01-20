" reference: http://blog.sanctum.geek.nz/gracefully-degrading-vimrc/

set nocompatible
set noerrorbells
set report=0 " report everything
set wildmenu " menu autocomplete
set directory=~/.vimswp " .swp files go here
set term=xterm
set encoding=utf-8

" tabs
" navigate: gt and gT
nnoremap <C-t> :tabnew<CR>

" stop typos
:command WQ wq
:command Wq wq
:command W w
:command Q q
:noremap ; :
:map q: :q

" paste last yank (not replaced by pasting)
:noremap <C-p> "0p

" Nicer split-window navigation
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-l> :wincmd l<CR>

" tabs
set autoindent
set cindent
set tabstop=2
set shiftwidth=2
set expandtab

" searching http://vim.wikia.com/wiki/Searching
set ignorecase
set smartcase
"set hlsearch

" fix auto indent
filetype on
filetype plugin on
filetype indent on

" use system clipboard as main register
"set clipboard=unnamed

" spelling ( [s ]s z= )
map <F5> :setlocal spell! spelllang=en_gb<cr>

" non-printing chars.
set list
set listchars=nbsp:¬,tab:>-,extends:»,precedes:«,trail:•

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

" format json
map <F7> :%!python3 -mjson.tool<cr>

" format html
map <F8> :%!tidy -iq -w 0<cr>

" emacs follow
" http://stackoverflow.com/questions/6873076/auto-scrollable-pagination-with-vim-using-vertical-split
:nmap <silent> <Leader>ef :vsplit<bar>wincmd l<bar>exe "norm! Ljz<c-v><cr>"<cr>:set scb<cr>:wincmd h<cr> :set scb<cr>


if has("gui_running")
  set go-=T
  set guifont=M+\ 1m\ Medium\ 11
  set guioptions=em
  set number
  set lines=999
endif


" mkdir -p ~/.vim/autoload
" curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" vim +"PlugInstall" +qall
function! InstallPlugins()
  call plug#begin('~/.vim/plugged')

  Plug 'godlygeek/tabular'
  Plug 'plasticboy/vim-markdown'
  Plug 'tangledhelix/vim-octopress'

  call plug#end()
endfunction

function! ConfigurePlugins()

  " auto align pipe-separated tables while editing, eg, cucumber feature files
  function! s:align()
    let p = '^\s*|\s.*\s|\s*$'
    if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
      let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
      let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
      Tabularize/|/l1
      normal! 0
      call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
    endif
  endfunction
  inoremap <silent> <Bar> <Bar><Esc>:call <SID>align()<CR>a

  " for plasticboy/vim-markdown
  let g:vim_markdown_folding_disabled=1

  " for tangledhelix/vim-octopress
  autocmd BufNewFile,BufRead *.markdown set filetype=octopress

endfunction

function! ConfigureWithoutPlugins()
endfunction

if !empty(glob("~/.vim/autoload/plug.vim"))
  call InstallPlugins()
  call ConfigurePlugins()
else
  call ConfigureWithoutPlugins()
endif

" appearance
syntax on
set background=dark
colorscheme slate
silent! colorscheme faerie

" colour fixes.
set t_Co=256
"if &term == "screen"
"  set t_kN=^[[6;*~
"  set t_kP=^[[5;*~
"endif
hi Normal ctermbg=none

" file types
" http://vimdoc.sourceforge.net/htmldoc/autocmd.html
autocmd BufNewFile,BufRead *.json set filetype=javascript
autocmd BufNewFile,BufRead Gemfile set filetype=ruby
autocmd BufNewFile,BufRead */httpd*/*.conf set filetype=apachestyle
