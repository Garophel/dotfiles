execute pathogen#infect()

filetype plugin on
runtime macros/matchit.vim

"	map leader to space
let mapleader = " "

"       use system clipboard the default register
set clipboard=unnamedplus

source ~/.vim-au.vim

"	encoding
set encoding=utf-8
set fileencoding=utf-8

set wildmenu
set path+=**
set nocompatible
set incsearch
set wrapscan

"	disable the in-the-face startup screen
set shortmess+=I

"	disable gvim annoyances
set mouse=c
set ai
set si
set nocin
set noudf
set nobackup
set backspace=indent,eol,start

"	tab stuff
set ts=4
set softtabstop=0
set shiftwidth=4
set et
set nosta

"	regular nice-to-have settings
syntax on
set nu
set relativenumber

"	visuals
set gfn=Consolas:h10:cANSI:qDRAFT
colorscheme desert
hi Normal ctermbg=NONE

"	mappings
" make better use of our extra letters
map ö ^
map ä $

nmap å <C-]>

" map <a-j> ddp
" map <a-k> ddP

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>

"	commands
command! -nargs=* Calc r !echo -n `calc -- <q-args>`
command! -nargs=0 W w
command! -nargs=1 Mkdir call mkdir(<q-args>)
command! -nargs=0 Jorma %s/\t/   /g
command! -nargs=0 Filename echo expand('%')

"	leaders
"autocmd! BufRead *.java imap ,print <esc>cF,System.out.println();<esc>F(i
