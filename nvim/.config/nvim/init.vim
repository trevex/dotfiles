
" Plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'junegunn/fzf'
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-repeat'
Plug 'ap/vim-buftabline'
Plug 'itchyny/lightline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-multiple-cursors'
Plug 'easymotion/vim-easymotion'
Plug 'editorconfig/editorconfig-vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'shougo/echodoc.vim'
Plug 'kizza/actionmenu.nvim'
Plug 'brooth/far.vim', { 'on': 'Far' }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
Plug 'fatih/vim-go', { 'for': 'go', 'do': ':GoUpdateBinaries' }
Plug 'mbbill/undotree', { 'on':  'UndotreeToggle' }
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
call plug#end()

" Colorscheme
colorscheme gruvbox
set background=dark
let g:gruvbox_italic=1
let g:gruvbox_contrast_dark="medium"
let g:gruvbox_number_column="bg0"
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ }

" Basic settings
let mapleader = ',' " Use comma as leader
let g:mapleader = ','
if has('mouse') " If mouse is available, use it
  set mouse=a
endif
if has("persistent_undo") " persitance available, use it
  set undofile " enable undofile and let's keep them
  set undodir=~/.local/share/nvim-undo
endif
set number " Show line numbers
set hidden " If hidden is not set, TextEdit might fail.
set updatetime=300 " Smaller updatetime for CursorHold and CursorHoldI
set shortmess+=c " Don't give `ins-completion-menu` messages
set signcolumn=yes " Always show signcolumns
set splitright
set splitbelow
set encoding=utf-8
set noerrorbells
set ruler
set colorcolumn=80
set autoread
set autowrite
set noshowmode " We want to see echodoc instead and mode is part of lightline

" Additional keybindings
nnoremap <leader>u :UndotreeToggle<cr>
map <C-n> :NERDTreeToggle<CR>
map <C-p> :FZF<CR>
nnoremap <C-x> :bnext<CR>
nnoremap <C-z> :bprev<CR>
nmap <leader>w :w!<cr>
map <Up> gk
map <Down> gj
map k gk
map j gj
imap jk <ESC>l
imap <leader><leader> <C-X><C-O>
nnoremap <leader>d "_d
xnoremap <leader>d "_d
nnoremap <leader>p "0p
xnoremap <leader>p "0p

" Highlight and cleanup trailing whitespaces
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1

" Buftabline configuration
let g:buftabline_numbers=2 " Map buffers to numbers
nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(10)
hi! link BufTabLineFill StatusLineNC

" COC configuration
" Use tab for trigger completion with characters ahead and navigate.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()
" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)
" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use U to show documentation in preview window
nnoremap <silent> U :call <SID>show_documentation()<CR>
" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" Disable vim-go go-to definition binding
let g:go_def_mapping_enabled = 0
" Setup echodoc
let g:echodoc#enable_at_startup = 1
let g:echodoc#type = 'virtual'

" Actionmenu setup
" let s:code_actions = []
" func! ActionMenuCodeActions() abort
"   let s:code_actions = CocAction('codeActions')
"   let l:menu_items = map(copy(s:code_actions), { index, item -> item['title'] })
"   call actionmenu#open(l:menu_items, 'ActionMenuCodeActionsCallback')
" endfunc
" func! ActionMenuCodeActionsCallback(index, item) abort
"   if a:index >= 0
"     let l:selected_code_action = s:code_actions[a:index]
"     let l:response = CocAction('doCodeAction', l:selected_code_action)
"   endif
" endfunc
" nnoremap <silent> <Leader>s :call ActionMenuCodeActions()<CR>

" FZF configuration
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }
let g:fzf_history_dir = '~/.local/share/fzf-history'
