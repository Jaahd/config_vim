" auto install plugin manager vim-plug {{{
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif
" }}}

" plugins {{{
call plug#begin('~/.vim/plugged')

" linter
Plug 'w0rp/ale'

" completion
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --tern-completer' }

" ide like
Plug 'ctrlpvim/ctrlp.vim'               " file fuzzy search
Plug 'vim-airline/vim-airline'          " status bar
Plug 'vim-airline/vim-airline-themes'   " status bar themes
Plug 'tpope/vim-surround'               " sourround modifyer helper
Plug 'tpope/vim-fugitive'               " git helper
Plug 'SirVer/ultisnips'                 " snippet engine
Plug 'honza/vim-snippets'               " snippets for Ultisnips
Plug 'nathanaelkane/vim-indent-guides'  " indentation helper
Plug 'godlygeek/tabular'                " vertical alignment helper
Plug 'mileszs/ack.vim'                  " ack/ag from vim
Plug 'Raimondi/delimitMate'             " smart pairs

" colorscheme
Plug 'morhetz/gruvbox'

" language improvement
Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'maxmellon/vim-jsx-pretty', { 'for': 'javascript' }
Plug 'marijnh/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }
Plug 'digitaltoad/vim-pug', { 'for': 'pug' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'cespare/vim-toml', { 'for': 'toml' }

" add plugin to runtimepath
call plug#end()
" }}}

" Vimscript file settings {{{

augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" auto-reload .vimrc
augroup reload_vimrc
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END

" }}}

" swap files {{{

" swap files (.swp) in a common location

" Create directories if needed.
fun! RequireDirectory(directory)
    if !isdirectory(a:directory)
        call mkdir(a:directory)
    endif
endf

" // means use the file's full path
set dir=~/.vim/_swap//
call RequireDirectory(expand("~") . "/.vim/_swap")

" backup files (~) in a common location if possible
set backup
set backupdir=~/.vim/_backup/,~/tmp,/tmp
call RequireDirectory(expand("~") . "/.vim/_backup")

" turn on undo files, put them in a common location
set undofile
set undodir=~/.vim/_undo/
call RequireDirectory(expand("~") . "/.vim/_undo")

" }}}

"set relativenumber  " ruler with relative line number
set number          " ruler with line number
set hidden          " let change buffer without saving

" remove trailing whitespaces
function! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd BufWritePre *.py,*.js,*.hs,*.rs,*.html,*.css,*.scss,*.c,*.h,*.cpp,*.hpp silent! :call <SID>StripTrailingWhitespaces()

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Searching configurations {{{
set incsearch   " Incremental search. Best search feature ever
set ignorecase
set smartcase   " Makes case sensitivity in search only matter if one of the letters is upper case.
set hlsearch    " highlight search result
" }}}

" completion {{{
set wildmenu                     " show more than one suggestion for completion
set wildmode=list:longest,full   " shell-like completion (up to ambiguity point)
set wildignore=*.o,*.out,*.obj,*.pyc,.git,.hgignore,.svn,.cvsignore,*/tmp/*,*.so,*.swp,*.zip
" }}}

" visuals {{{1

"set t_Co=256            " force vim to use 256 colors
set background=dark
syntax on               " syntax highlighting
colorscheme gruvbox

" look improvement
"set fillchars=stl:─,stlnc:─,vert:│,fold:─,diff:─

" break long lines visually (not actual lines)
set wrap linebreak
set textwidth=0 wrapmargin=0

" status line {{{2
set laststatus=2                 " always display the status line
set shortmess=atI                " short messages to avoid scrolling
set title
set ruler                        " show the cursor position all the time
set showcmd                      " display incomplete commands
" }}}2

if exists('+colorcolumn')
    set colorcolumn=80
endif

" when scrolling, keep space around cursor
set scrolloff=2
set sidescrolloff=5

" split screen below and right instead of vim natural
set splitbelow
set splitright

" gvim
set guioptions-=m  " remove menu bar
set guioptions-=T  " remove toolbar
set guioptions-=r  " remove right-hand scroll bar
set guioptions-=L  " remove left-hand scroll bar
set guioptions-=e  " tab appearance like in term

" }}}1

" Arrow desactivation {{{
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
noremap <home> <nop>
noremap <End> <nop>
noremap <Up> <nop>
" }}}

" convenient shortcut {{{
" default macro
nnoremap Q @q
"}}}

" leader {{{
map <space> <leader>

nnoremap <silent> <Leader>/ :nohlsearch<CR>
"}}}

" Indentation {{{
" Defaut indentation
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" Language specific
autocmd FileType javascript setlocal ts=2 sts=2 sw=2 noet ai nocindent
autocmd FileType html setlocal ts=2 sts=2 sw=2 noet ai
autocmd FileType css setlocal ts=2 sts=2 sw=2 noet ai
" }}}

" Plugins configurations

" linter {{{
let g:ale_sign_column_always = 1
let g:ale_c_gcc_options = '-Wall -Werror -Wextra -I./include -I./../include'
let g:ale_cpp_gcc_options = '-Wall -Werror -Wextra -I./include -I./../include -std=c++11'
" }}}

" CtrlP {{{
" set the ignore file for ctrlp plugin
set wildignore+=*.so,*.swp,*.zip     " MacOSX/Linux

let g:ctrlp_user_command = ['.git', 'git --git-dir=%s/.git ls-files -oc --exclude-standard |& egrep -v "\.(png|jpg|jpeg|gif)$|node_modules|bower_components"']

nnoremap <silent> <Leader>o :CtrlP<CR>
nnoremap <silent> <Leader>b :CtrlPBuffer<CR>
nnoremap <silent> <Leader>f :CtrlPMRUFiles<CR>
" }}}

" airline {{{
let g:airline_powerline_fonts = 1
let g:airline_theme='distinguished'
" }}}

" vim-cpp-enhanced-highlight {{{
let g:cpp_class_scope_highlight = 1
"}}}

" YouCompleteMe {{{
let g:ycm_key_list_select_completion = ['<C-TAB>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-S-TAB>', '<Up>']
" }}}

" Ultisnips {{{
let g:UltisnipsUsePythonVersion = 3

let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsListSnippets="<c-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-j>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
" }}}

" vim-indent-guides {{{
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_auto_colors = 0
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=darkgrey
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=black
" }}}

" Tern {{{
"let g:tern_show_argument_hints='on_hold'
"let g:tern_map_keys=1
" }}}

" Ack / ag {{{
if executable('ag')
    let g:ackprg = 'ag --vimgrep'
endif

nnoremap <silent> <Leader>a :Ack!<space>
" }}}

" delimitMate {{{
let delimitMate_expand_cr = 1
let delimitMate_expand_space = 1
nnoremap <silent> <Leader>d :DelimitMateSwitch<CR>
" }}}
