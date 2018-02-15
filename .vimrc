set nocompatible              " be iMproved, required
filetype off                  " required

" remap leader
let mapleader = "-"

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
Plugin 'rust-lang/rust.vim'
Plugin 'mkitt/tabline.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'gerw/vim-latex-suite'
Plugin 'vim-syntastic/syntastic'
Plugin 'chiedo/vim-case-convert'
Plugin 'zcodes/vim-colors-basic'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'junegunn/fzf'
Plugin 'rking/ag.vim'
Plugin 'majutsushi/tagbar'
Plugin 'jaxbot/semantic-highlight.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'danro/rename.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'loolo78/vim-breakpoint'

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

" Automatic reloading of .vimrc
autocmd! bufwritepost .vimrc source %

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
set shiftwidth=2
set tabstop=2
set expandtab
set smartcase

" Toogle for case sensitivity
nmap <F7> :set ignorecase! ignorecase?
set ignorecase

" Make backspace work
set backspace=2

" Mouse integration
set mouse=a

" If file changed on disk, reload it
set autoread

" Larger font
set guifont=Inconsolata:h14
" Color scheme
colorscheme slate

" Map leader to , instead of \
let mapleader=","

" Make Ycm close preview window after completion
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_python_binary_path = 'python3'
let g:ycm_rust_src_path = '/usr/local/share/rustc-1.13.0/src'
nmap <C-f> :YcmCompleter FixIt<CR>
nmap <C-d> :YcmCompleter GoTo<CR>
let g:ycm_semantic_triggers = { 'cpp': [ 're!.' ] }


" Clojure stuff
let g:salve_auto_start_repl=1

" Airline stuff
map <C-m> :NERDTreeToggle<CR>


" Latex for ycm completion
let g:ycm_semantic_triggers = {
\  'tex'  : ['\ref{','\cite{'],
\ }

" Remove trailing whitespace from files on save
autocmd BufWritePre * %s/\s\+$//e
" Syntax check python files
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

let g:syntastic_mode_map = {
      \ "mode": "passive",
      \ "passive_filetypes": ["cpp", "js"] }

" Use spellcheck for tex files
autocmd FileType tex,bib set spell

" Remap Esc to close a terminal in neovim
if has('nvim')
tnoremap <Esc> <C-\><C-n>
end

" Shut down auto fold for latex documents
let g:tex_flavor='latex'
set grepprg=grep\ -nH\ $*
let g:Tex_Folding=0
set iskeyword+=:

" Remap ctrl to FZF
"map <C-P> :FZF<CR>

" Use ag/silver searcher with ctrlp
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  "     " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
nnoremap <C-a> :CtrlP ~/src/vricon/<CR>

" Remap ctags to F12 and Ctrl+-
nnoremap t <C-]>
" ctags optimization
" set autochdir
set tags=tags;
" Ctrlp for tags
nmap <F9> :CtrlPTag<cr>
nmap <F8> :TagbarToggle<CR>

" --column: Show column number
" --line-number: Show line number
" --no-heading: Do not show file headings in results
" --fixed-strings: Search term as a literal string
" --ignore-case: Case insensitive search
" --no-ignore: Do not respect .gitignore, etc...
" --hidden: Search hidden files and folders
" --follow: Follow symlinks
" --glob: Additional conditions for search (in this case ignore everything in the .git/ folder)
" --color: Search color options
"command! -bang -nargs=* Find call fzf#vim#grep('ag --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" GLSL on vricon shaders
autocmd BufRead *.fp,*.vp,*.gp,*.sp,*.sp,*.hlsl setf glsl
autocmd BufRead *.fp,*.vp,*.gp,*.sp,*.sp,*.hlsl set syntax=glsl
" XML on Vricon .fx files
autocmd BufRead *.fx,*.mat set syntax=xml

" Autoread buffers changed
set autoread
autocmd FocusGained * checktime

" Disable folding in markdown
let g:vim_markdown_folding_disabled = 1
autocmd BufWritePost *.md,*.mkd !pandoc <afile> -o /tmp/<afile>:t.pdf

" Pretty print json
nmap <C-j> :%!python -m json.tool<CR>

" Some breakpoitns for explorer and add GDB integration
nmap <F4> :BreakpointSetBreakpoint<CR> :BreakpointWriteBreakpoints<CR>
nmap <F5> :BreakpointPrintBreakpoints<CR>
nmap <F6> :BreakpointClearBreakpoints<CR> :BreakpointWriteBreakpoints<CR> :echo "Breakpoints cleared!"<CR>

