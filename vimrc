set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'Raimondi/delimitMate'
Plugin 'kien/ctrlp.vim'
Plugin 'docunext/closetag.vim'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/nerdtree'
Plugin 'mileszs/ack.vim'
Plugin 'altercation/vim-colors-solarized'

" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
let mapleader = ","
set autoindent
syntax enable

set background=dark
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
let g:solarized_bold = "1"

let g:scheme_bg = "dark"

set number
nnoremap j gj
nnoremap k gk

set t_Co=256
let g:Powerline_symbols = 'fancy'


map <C-l> :tabn<CR>
map <C-h> :tabp<CR>
map <C-n> :NERDTreeToggle<CR>
map <C-f> :Ack 
map <Leader>r :NERDTreeFind<CR>
map <Leader>t :tabnew<CR>

set pastetoggle=<F2>

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab

let g:ctrlp_cmd = 'CtrlP'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
set backspace=indent,eol,start

colorscheme solarized
