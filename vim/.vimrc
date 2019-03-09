" Load plugins with pathogen
execute pathogen#infect()
" No vi compatibility
set nocompatible
filetype off
" Basic settings
syntax on
filetype plugin indent on
set clipboard=unnamed
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
set textwidth=0
set wrapmargin=0
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
set wildmenu
set wildmode=list:full
set completeopt-=preview
set tabstop=4
set shiftwidth=4
set expandtab
au FocusLost * :wa
if has('mouse')
  set mouse=a
  noremap <M-LeftMouse> <4-LeftMouse>
  inoremap <M-LeftMouse> <4-LeftMouse>
  onoremap <M-LeftMouse> <C-C><4-LeftMouse>
  noremap <M-LeftDrag> <LeftDrag>
  inoremap <M-LeftDrag> <LeftDrag>
  onoremap <M-LeftDrag> <C-C><LeftDrag>
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
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark="medium"
let g:gruvbox_number_column="bg0"
colorscheme gruvbox
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
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
" Disable auto-comment
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Keybindings
nnoremap <C-x> :bnext<CR>
nnoremap <C-z> :bprev<CR>
nnoremap <space> zz
nmap <leader>w :w!<cr>
map <Up> gk
map <Down> gj
map k gk
map j gj
imap jk <ESC>l
imap <leader><leader> <C-X><C-O>
" Setup fzf
nnoremap <C-p> :Files<cr>
" Setup NerdTree
nmap <C-n> :NERDTreeToggle<CR>
noremap <Leader>n :NERDTreeToggle<cr>
noremap <Leader>f :NERDTreeFind<cr>
" Setup better whitespace
let g:better_whitespace_enabled = 1
let g:strip_whitespace_on_save = 1
" Setup supertab
let g:SuperTabCrMapping = 1
