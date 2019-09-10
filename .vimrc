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
Plugin 'roxma/nvim-yarp'
Plugin 'ncm2/ncm2'
Plugin 'ncm2/ncm2-bufword'
Plugin 'ncm2/ncm2-path'
Plugin 'ncm2/ncm2-racer'
Plugin 'rhysd/vim-clang-format'
Plugin 'FelikZ/ctrlp-py-matcher'
Plugin 'tpope/vim-fugitive.git'
Plugin 'nvie/vim-flake8'
Plugin 'vim-syntastic/syntastic'

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
autocmd! bufwritepost init.vim source %
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
" Python/pep8 requires slightly differing
autocmd FileType python setlocal tabstop=8 shiftwidth=4 softtabstop=4 expandtab
let g:pyindent_continue = '&sw'
let g:pyindent_open_paren = '&sw'
"autocmd FileType python map <buffer> <F8> :call flake8#Flake8()<CR>
" Let's add syntastic for pep8
let g:syntastic_mode_map = { 'mode': 'passive',
                          \ 'active_filetypes': ['python'],
                          \ 'passive_filetypes': [] }
let g:syntastic_auto_loc_list=1
nnoremap <silent> <F8> :SyntasticCheck<CR>

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

autocmd BufRead *.cc,*.h,*.hpp,*.cpp,*.c ClangFormat

" Remove trailing whitespace from files on save
autocmd BufWritePre * %s/\s\+$//e
let blacklist = ['mkd', 'md', "*.cc", "*.h", "*.hpp", "*.cpp", "*.c"]
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

" Root marker for ctrlp
let g:ctrlp_root_markers = ['.ctrlp']
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
"let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
"let g:ctrlp_custom_ignore = '\v[\/](out_gn_*)|(\.(git))$'

" Set delay to prevent extra search
let g:ctrlp_lazy_update = 350

" Do not clear filenames cache, to improve CtrlP startup
" You can manualy clear it by <F5>
let g:ctrlp_clear_cache_on_exit = 0

" Set no file limit, we are building a big project
let g:ctrlp_max_files = 0

" Use ag/silver searcher with ctrlp
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  "     " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  "let g:ctrlp_user_command = ['.git/', 'git ls-files --cached --others  --exclude-standard %s']
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


" SYNTAX HIGLIGHTING
" GLSL on vricon shaders
autocmd BufRead *.fp,*.vp,*.gp,*.sp,*.sp,*.hlsl setf glsl
autocmd BufRead *.fp,*.vp,*.gp,*.sp,*.sp,*.hlsl set syntax=glsl
" XML on Vricon .fx files
autocmd BufRead *.fx,*.mat set syntax=xml
" CSS on QSS
autocmd BufRead *.qss set syntax=css
" OMI files from TvSDK
autocmd BufRead *.omi set syntax=cpp


" Autoread buffers changed
set autoread
autocmd FocusGained * checktime

" Disable folding in markdown
let g:vim_markdown_folding_disabled = 1
"autocmd BufWritePost *.md,*.mkd !pandoc <afile> -o /tmp/<afile>:t.pdf
"autocmd BufWritePost *.tex !pdflatex -output-directory /tmp <afile>

" Pretty print json
nmap <C-j> :%!python -m json.tool<CR>
command! PrettyJson :%!python -m json.tool

" Gitgutter max
let g:gitgutter_max_signs = 1000

" easy comment toggle
" Comment current line
nmap <F12> v<leader>c<Space>
vmap <F12> <leader>cm

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CSCOPE settings for vim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
" This file contains some boilerplate settings for vim's cscope interface,
" plus some keyboard mappings that I've found useful.
"
" USAGE:
" -- vim 6:     Stick this file in your ~/.vim/plugin directory (or in a
"               'plugin' directory in some other directory that is in your
"               'runtimepath'.
"
" -- vim 5:     Stick this file somewhere and 'source cscope.vim' it from
"               your ~/.vimrc file (or cut and paste it into your .vimrc).
"
" NOTE:
" These key maps use multiple keystrokes (2 or 3 keys).  If you find that vim
" keeps timing you out before you can complete them, try changing your timeout
" settings, as explained below.
"
" Happy cscoping,
"
" Jason Duell       jduell@alumni.princeton.edu     2002/3/7
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" This tests to see if vim was configured with the '--enable-cscope' option
" when it was compiled.  If it wasn't, time to recompile vim...
if has("cscope")

    """"""""""""" Standard cscope/vim boilerplate

    set nocscopeverbose
    " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set cscopetag

    " check cscope for definition of a symbol before checking ctags: set to 1
    " if you want the reverse search order.
    set csto=0

    " add any cscope database in current directory
    if filereadable("cscope.out")
        cs add cscope.out
    " else add the database pointed to by environment variable
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif

    " show msg when any other cscope db added
    set cscopeverbose


    """"""""""""" My cscope/vim key mappings
    "
    " The following maps all invoke one of the following cscope search types:
    "
    "   's'   symbol: find all references to the token under cursor
    "   'g'   global: find global definition(s) of the token under cursor
    "   'c'   calls:  find all calls to the function name under cursor
    "   't'   text:   find all instances of the text under cursor
    "   'e'   egrep:  egrep search for the word under cursor
    "   'f'   file:   open the filename under cursor
    "   'i'   includes: find files that include the filename under cursor
    "   'd'   called: find functions that function under cursor calls
    "
    " Below are three sets of the maps: one set that just jumps to your
    " search result, one that splits the existing vim window horizontally and
    " diplays your search result in the new window, and one that does the same
    " thing, but does a vertical split instead (vim 6 only).
    "
    " I've used CTRL-\ and CTRL-@ as the starting keys for these maps, as it's
    " unlikely that you need their default mappings (CTRL-\'s default use is
    " as part of CTRL-\ CTRL-N typemap, which basically just does the same
    " thing as hitting 'escape': CTRL-@ doesn't seem to have any default use).
    " If you don't like using 'CTRL-@' or CTRL-\, , you can change some or all
    " of these maps to use other keys.  One likely candidate is 'CTRL-_'
    " (which also maps to CTRL-/, which is easier to type).  By default it is
    " used to switch between Hebrew and English keyboard mode.
    "
    " All of the maps involving the <cfile> macro use '^<cfile>$': this is so
    " that searches over '#include <time.h>" return only references to
    " 'time.h', and not 'sys/time.h', etc. (by default cscope will return all
    " files that contain 'time.h' as part of their name).


    " To do the first type of search, hit 'CTRL-\', followed by one of the
    " cscope search types above (s,g,c,t,e,f,i,d).  The result of your cscope
    " search will be displayed in the current window.  You can use CTRL-T to
    " go back to where you were before the search.
    "

    nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-_>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>


    " Using 'CTRL-spacebar' (intepreted as CTRL-@ by vim) then a search type
    " makes the vim window split horizontally, with search result displayed in
    " the new window.
    "
    " (Note: earlier versions of vim may not have the :scs command, but it
    " can be simulated roughly via:
    "    nmap <C-@>s <C-W><C-S> :cs find s <C-R>=expand("<cword>")<CR><CR>

    nmap <C-Space>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-Space>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-Space>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-Space>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>


    " Hitting CTRL-space *twice* before the search type does a vertical
    " split instead of a horizontal one (vim 6 and up only)
    "
    " (Note: you may wish to put a 'set splitright' in your .vimrc
    " if you prefer the new window on the right instead of the left

    nmap <C-@><C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@><C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@><C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>


    """"""""""""" key map timeouts
    "
    " By default Vim will only wait 1 second for each keystroke in a mapping.
    " You may find that too short with the above typemaps.  If so, you should
    " either turn off mapping timeouts via 'notimeout'.
    "
    "set notimeout
    "
    " Or, you can keep timeouts, by uncommenting the timeoutlen line below,
    " with your own personal favorite value (in milliseconds):
    "
    "set timeoutlen=4000
    "
    " Either way, since mapping timeout settings by default also set the
    " timeouts for multicharacter 'keys codes' (like <F1>), you should also
    " set ttimeout and ttimeoutlen: otherwise, you will experience strange
    " delays as vim waits for a keystroke after you hit ESC (it will be
    " waiting to see if the ESC is actually part of a key code like <F1>).
    "
    "set ttimeout
    "
    " personally, I find a tenth of a second to work well for key code
    " timeouts. If you experience problems and have a slow terminal or network
    " connection, set it higher.  If you don't set ttimeoutlen, the value for
    " timeoutlent (default: 1000 = 1 second, which is sluggish) is used.
    "
    "set ttimeoutlen=100

endif

