set nocompatible              " be iMproved, required
filetype off                  " required

set encoding=utf-8
set fileencoding=
setglobal fileencoding=utf-8
set fileencodings=ucs-bom,utf-8,latin1
set termencoding=latin1


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
Plugin 'rust-lang/rust.vim'
Plugin 'mkitt/tabline.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'gerw/vim-latex-suite'
Plugin 'chiedo/vim-case-convert'
Plugin 'zcodes/vim-colors-basic'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'rking/ag.vim'
Plugin 'majutsushi/tagbar'
Plugin 'jaxbot/semantic-highlight.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'danro/rename.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'autozimu/LanguageClient-neovim'
Plugin 'roxma/nvim-yarp'
Plugin 'ncm2/ncm2'
Plugin 'ncm2/ncm2-bufword'
Plugin 'ncm2/ncm2-path'
Plugin 'ncm2/ncm2-racer'

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

" --------------- Rust support
autocmd BufReadPost *.rs setlocal filetype=rust
autocmd BufEnter *.rs call ncm2#enable_for_buffer()

" suppress the annoying 'match x of y', 'The only match' and 'Pattern not
" found' messages
set shortmess+=c

" CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead.
inoremap <c-c> <ESC>

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" wrap existing omnifunc
" Note that omnifunc does not run in background and may probably block the
" editor. If you don't want to be blocked by omnifunc too often, you could
" add 180ms delay before the omni wrapper:
"  'on_complete': ['ncm2#on_complete#delay', 180,
"               \ 'ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
au User Ncm2Plugin call ncm2#register_source({
        \ 'name' : 'css',
        \ 'priority': 9,
        \ 'subscope_enable': 1,
        \ 'scope': ['css','scss'],
        \ 'mark': 'css',
        \ 'word_pattern': '[\w\-]+',
        \ 'complete_pattern': ':\s*',
        \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
        \ })

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" NOTE: you need to install completion sources to get completions. Check
" our wiki page for a list of sources: https://github.com/ncm2/ncm2/wiki

" Required for operations modifying multiple buffers like rename.
set hidden

let g:LanguageClient_serverCommands = {
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ }

" Automatically start language servers.
let g:LanguageClient_autoStart = 1

" Maps K to hover, gd to goto definition, F2 to rename
nnoremap <C-h> :call LanguageClient_textDocument_hover()<CR>
nnoremap gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <F2> :call LanguageClient_textDocument_rename()<CR>
" ---------- END RUST

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
set autoindent
set smartindent
set smarttab

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
set showcmd

" Make Ycm close preview window after completion
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_python_binary_path = 'python3'
nmap <C-f> :YcmCompleter FixIt<CR>
nmap <C-d> :YcmCompleter GoTo<CR>
let g:ycm_semantic_triggers = { 'cpp': [ 're!.' ] }
let g:ycm_confirm_extra_conf = 0
let g:ycm_filetype_blacklist = { 'rust': 1 }

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
let blacklist = ['mkd', 'md']
autocmd BufWritePre * if index(blacklist, &ft) < 0 |

" Use spellcheck for tex files
"autocmd FileType * set nospell
"autocmd FileType md,mkd,tex set spell

" Remap Esc to close a terminal in neovim
if has('nvim')
tnoremap <Esc> <C-\><C-n>
end

" Shut down auto fold for latex documents
let g:tex_flavor='latex'
set grepprg=grep\ -nH\ $*
let g:Tex_Folding=0
set iskeyword+=:

" Use ag/silver searcher with ctrlp
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  "     " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
" nnoremap <C-a> :CtrlP ~/src/vricon/<CR>

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
" CSS on QSS
autocmd BufRead *.qss set syntax=css

" Autoread buffers changed
set autoread
autocmd FocusGained * checktime

" Disable folding in markdown
let g:vim_markdown_folding_disabled = 1
"autocmd BufWritePost *.md,*.mkd !pandoc <afile> -o /tmp/<afile>:t.pdf
"autocmd BufWritePost *.tex !pdflatex -output-directory /tmp <afile>

" Pretty print json
nmap <C-j> :%!python -m json.tool<CR>

" Gitgutter max
let g:gitgutter_max_signs = 1000

" easy comment toggle
" Comment current line
nmap <C-Space> v<leader>c<Space>
vmap <C-Space> <leader>cm
