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
" Setup better whitespace
let g:better_whitespace_enabled = 1
let g:strip_whitespace_on_save = 1
" Setup supertab
let g:SuperTabCrMapping = 1
autocmd FileType *
  \ if &omnifunc != '' |
  \   call SuperTabChain(&omnifunc, "<c-p>") |
  \ endif
" Configure ALE
let g:ale_linters_explicit = 1
let g:ale_linters = {
\   'cs': ['omnisharp'],
\}
" Setup omnisharp amd C# language defaults
let g:OmniSharp_server_path = $HOME.'/Development/tmp/omnisharp/omnisharp/OmniSharp.exe'
let g:OmniSharp_server_use_mono = 1
let g:OmniSharp_timeout = 5
autocmd Filetype cs setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
augroup omnisharp_commands
    autocmd!
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>
    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>
    autocmd FileType cs nnoremap <F2> :OmniSharpRename<CR>
augroup END
