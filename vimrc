
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-endwise'
Plugin 'Raimondi/delimitMate'
Plugin 'kien/ctrlp.vim'
Plugin 'docunext/closetag.vim'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/nerdtree'
Plugin 'mileszs/ack.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'L9'
Plugin 'rking/ag.vim'
Bundle 'flazz/vim-colorschemes'
Bundle 'bling/vim-airline'
Bundle 'derekwyatt/vim-scala'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
syntax enable
" Put your non-Plugin stuff after this line
"
let mapleader = "\<Space>"
set autoindent
set background=dark
set number
" set t_Co=256
set pastetoggle=<F2>
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set backspace=indent,eol,start
set incsearch             " But do highlight as you type your search.
set ignorecase            " Make searches case-insensitive.
set ruler                 " Always show info along bottom."
set laststatus=2          " last window always has a statusline"
set smarttab              " use tabs at the start of a line, spaces elsewhere"
set smartindent
set colorcolumn=80
set statusline+=%F

let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
let g:solarized_bold = "1"
let g:airline_powerline_fonts = 1

" This helps with jruby stuff?
let g:ruby_path='/usr/bin/ruby'

nnoremap j gj
nnoremap k gk

map <C-n> :NERDTreeToggle<CR>
map <C-f> :Ag 
map <Leader>r :NERDTreeFind<CR>
map <Leader>t :tabnew<CR>
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>e :wq<CR>
nnoremap <CR> G
nnoremap <BS> gg

" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" Copy paste with <Space>y/p
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

nnoremap <Leader>c :set cursorline! cursorcolumn!<CR>

let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
let g:ctrlp_use_caching = 0
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

" colorscheme solarized
" colorscheme ir_black
" colorscheme Tomorrow-Night
colorscheme Monokai

if exists("+showtabline")
  function MyTabLine()
    let s = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
      let buflist = tabpagebuflist(i)
      let winnr = tabpagewinnr(i)
      let s .= '%' . i . 'T'
      let s .= (i == t ? '%1*' : '%2*')
      let s .= '  '
      let s .= i . ')'
      let s .= '%*'
      let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
      let file = bufname(buflist[winnr - 1])
      let file = fnamemodify(file, ':p:t')
      if file == ''
        let file = '[No Name]'
      endif
      let s .= file
      let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
    return s
  endfunction
  set stal=2
  set tabline=%!MyTabLine()
endif
hi TabLineFill term=NONE cterm=NONE ctermbg=233
hi TabLineSel term=NONE cterm=NONE ctermbg=240
hi TabLine term=NONE cterm=NONE ctermbg=233
hi CursorLine   cterm=NONE ctermbg=237
hi CursorColumn cterm=NONE ctermbg=237
