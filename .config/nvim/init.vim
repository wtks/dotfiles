let g:cache_home = empty($XDG_CACHE_HOME) ? expand('$HOME/.cache') : $XDG_CACHE_HOME
let g:config_home = empty($XDG_CONFIG_HOME) ? expand('$HOME/.config') : $XDG_CONFIG_HOME
let s:dein_cache_path = expand('$HOME/.cache/nvim/dein')

if &compatible
    set nocompatible
endif

augroup MyAutoCmd
    autocmd!
augroup END


" dein {{{

if &runtimepath !~# '/dein.vim'
    let s:dein_repo_dir = s:dein_cache_path . '/repos/github.com/Shougo/dein.vim'

    " Auto Download
    if !isdirectory(s:dein_repo_dir)
        call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
    endif

    " dein.vim をプラグインとして読み込む
    execute 'set runtimepath^=' . s:dein_repo_dir
endif

let g:dein#install_max_processes = 16
let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'
let g:dein#enable_notification = 1

if dein#load_state(s:dein_cache_path)
    call dein#begin(s:dein_cache_path)

    call dein#load_toml('~/.config/nvim/dein.toml', {'lazy' : 0})
    call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy' : 1})
    call dein#load_toml('~/.config/nvim/c_lazy.toml', {'lazy' : 1})

    call dein#end()
    call dein#save_state()
endif

if dein#check_install()
    call dein#install()
endif

" }}}

set nowritebackup
set nobackup
set noswapfile
set hidden
set wildmenu
set wildmode=list:full
set mouse=a
filetype plugin on
filetype indent on
set encoding=utf-8
set t_Co=256
if has('gui_running')
    set guifont=Roboto\ Mono\ Nerd\ Font\ Complete
    set guifontwide=Roboto\ Mono\ Nerd\ Font\ Complete
endif
"----------------------------------------
" 編集
"----------------------------------------
set virtualedit=block
set history=10000
set whichwrap=b,s,h,l,<,>,[,],~
set backspace=indent,eol,start
let mapleader = ","
set clipboard+=unnamedplus

"----------------------------------------
" 表示
"----------------------------------------
syntax enable
" set termguicolors
set background=dark
set number
set ruler
set cursorline
set title
set showtabline=2
set list listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set showmatch
source $VIMRUNTIME/macros/matchit.vim
set matchtime=1
set nrformats-=octal
set cmdheight=2
set laststatus=2
set showcmd
set display=lastline

"----------------------------------------
" タブ
"----------------------------------------
set ambiwidth=single "doubleにしないと記号ぶっ壊れる
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent

"----------------------------------------
" 検索
"----------------------------------------
set incsearch
set hlsearch
set wrapscan
set ignorecase
set smartcase
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>
