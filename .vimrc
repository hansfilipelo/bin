set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'vim-scripts/a.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tikhomirov/vim-glsl'
Plugin 'rdnetto/YCM-Generator'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'vim-airline/vim-airline'
Plugin 'airblade/vim-gitgutter'
Plugin 'mhinz/vim-signify'
Plugin 'jmcantrell/vim-virtualenv'
Plugin 'scrooloose/nerdtree'
Plugin 'bjoernd/vim-ycm-tex'
Plugin 'guns/vim-sexp'
Plugin 'guns/vim-clojure-highlight'
Plugin 'tpope/vim-sexp-mappings-for-regular-people'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'tpope/vim-salve'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-classpath'
Plugin 'tpope/vim-dispatch'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured pluginsG
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

" Make Ctrl+C do copy to system clipboard
vnoremap <C-c> "+y
syntax on 
" Numbered lines and highlight searches
set number
set ruler
"set relativenumber
set hlsearch

" No tabs, just spaces
retab
set shiftwidth=4
set tabstop=4
set expandtab
set smartcase

" Toogle for case sensitivity
nmap <C-i> :set ignorecase! ignorecase?

" Make backspace work
set backspace=2

" Larger font
set guifont=Inconsolata:h14
" Color scheme
colorscheme slate

" Map leader to , instead of \
let mapleader=","

" Make Ycm close preview window after completion
let g:ycm_autoclose_preview_window_after_completion=1

" Clojure stuff
let g:salve_auto_start_repl=1

" Airline stuff
"map <C-> :NERDTreeToggle<CR>
command NT NERDTreeToggle


" Latex for ycm completion
let g:ycm_semantic_triggers = {
\  'tex'  : ['\ref{','\cite{'],
\ }

" Remove trailing whitespace from python files on save
autocmd BufWritePre *.py %s/\s\+$//e

