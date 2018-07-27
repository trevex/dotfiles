" Load plugins with pathogen
execute pathogen#infect()
" No vi compatibility
set nocompatible
filetype off
" Basic settings
syntax on
filetype plugin indent on
set noerrorbells
set number
set showcmd
set showmode
set noswapfile
set nobackup
set nowritebackup
set splitright
set splitbelow
set encoding=utf-8
set autowrite
set autoread
set laststatus=2
set hidden
set ruler
set fileformats=unix,dos,mac
set noshowmatch
set noshowmode
set incsearch
set hlsearch
set ignorecase
set smartcase
set ttyfast
set lazyredraw
set conceallevel=0
set wrap
set textwidth=79
set formatoptions=qrn1a
set autoindent
set complete-=i
set showmatch
set smarttab
set nrformats-=octal
set shiftround
set notimeout
set ttimeout
set ttimeoutlen=10
set cursorline
set nolist
set lcs+=space:·
au FocusLost * :wa
if has('mouse')
  set mouse=a
endif
" Set leader to ,
let mapleader = ","
let g:mapleader = ","
" Speed up syntax highlighting
syntax sync minlines=256
set synmaxcol=300
set re=1
" Setup nord colorscheme
set background=dark
let g:nord_italic = 1
let g:nord_underline = 1
let g:nord_italic_comments = 1
let g:nord_cursor_line_number_background = 1
colorscheme nord
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ }
" Extra commands
function! DeleteInactiveBufs() " Taken form jessfraz/.vim
  let tablist = []
  for i in range(tabpagenr('$'))
    call extend(tablist, tabpagebuflist(i + 1))
  endfor
  let nWipeouts = 0
  for i in range(1, bufnr('$'))
    if bufexists(i) && !getbufvar(i,"&mod") && index(tablist, i) == -1
      silent exec 'bwipeout' i
      let nWipeouts = nWipeouts + 1
    endif
  endfor
  echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! Ball :call DeleteInactiveBufs()
" Keybindings
nnoremap <C-x> :bnext<CR>
nnoremap <C-z> :bprev<CR>
" Setup CtrlP
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_max_height = 10
let g:ctrlp_switch_buffer = 'et'
let g:ctrlp_mruf_max=450
let g:ctrlp_max_files=0
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
" Setup NerdTree
nmap <C-n> :NERDTreeToggle<CR>
noremap <Leader>n :NERDTreeToggle<cr>
noremap <Leader>f :NERDTreeFind<cr>
