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
au FocusLost * :wa
if has('mouse')
  set mouse=a
endif
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
" Setup CtrlP
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_max_height = 10		" maxiumum height of match window
let g:ctrlp_switch_buffer = 'et'	" jump to a file if it's open already
let g:ctrlp_mruf_max=450 		" number of recently opened files
let g:ctrlp_max_files=0  		" do not limit the number of searchable files
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
