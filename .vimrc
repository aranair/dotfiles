call plug#begin()

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-unimpaired'
Plug 'godlygeek/tabular'
" Plug 'preservim/vim-markdown'
Plug 'skywind3000/asyncrun.vim'
Plug 'Raimondi/delimitMate'
Plug 'ervandew/supertab'
Plug 'scrooloose/nerdtree'
Plug 'altercation/vim-colors-solarized'
Plug 'vim-scripts/L9'
Plug 'rking/ag.vim'
Plug 'flazz/vim-colorschemes'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'fatih/vim-go'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'airblade/vim-gitgutter'
Plug 'metakirby5/codi.vim'
Plug 'leafgarland/typescript-vim'
Plug 'hashivim/vim-terraform'
Plug 'mustache/vim-mustache-handlebars'
Plug 'github/copilot.vim'
Plug 'google/vim-jsonnet'

" All of your Plugs must be added before the following line
call plug#end()            " required
syntax enable

" colorscheme solarized
" highlight clear SignColumn
" highlight GitGutterAdd ctermfg=green
" highlight GitGutterChange ctermfg=yellow
" highlight GitGutterDelete ctermfg=red
" highlight GitGutterChangeDelete ctermfg=yellow
" let g:solarized_termtrans = 1 
colorscheme papercolor
" colorscheme northland
" colorscheme Monokai

let mapleader = "\<Space>"

set autoindent
set background=light
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
" set colorcolumn=100
set statusline+=%F
set noswapfile

" Persistent undo
set undofile
set undodir=$HOME/.vim/backup
set undolevels=1000
set undoreload=10000
set hidden "keeps undo history across buffers

autocmd FileType text setlocal textwidth=78
autocmd FileType markdown setlocal wrap
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType scss  setlocal shiftwidth=2 tabstop=2
autocmd FileType css   setlocal shiftwidth=2 tabstop=2
autocmd FileType html  setlocal shiftwidth=2 tabstop=2

" vim-fugitive
let g:netrw_http_cmd = 'wget -q -O'


" FZF
" let g:fzf_command_prefix = 'Fzf'
set rtp+=~/.fzf
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }
nmap <c-p> :FZF<CR>
nmap ; :Buffers<CR>

" vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
let g:javascript_plugin_ngdoc = 0
let g:javascript_conceal_function             = "ƒ"
let g:javascript_conceal_null                 = "ø"
let g:javascript_conceal_this                 = "@"
let g:javascript_conceal_return               = "⇚"
let g:javascript_conceal_undefined            = "¿"
let g:javascript_conceal_NaN                  = "ℕ"
let g:javascript_conceal_prototype            = "¶"
let g:javascript_conceal_static               = "•"
let g:javascript_conceal_super                = "Ω"
let g:javascript_conceal_arrow_function       = "⇒"

let g:flow#showquickfix = 1
let g:flow#timeout = 4
let g:flow#enable = 1

let g:go_autodetect_gopath = 1

"Use locally installed flow
let local_flow = finddir('node_modules', '.;') . '/.bin/flow'
if matchstr(local_flow, "^\/\\w") == ''
    let local_flow= getcwd() . "/" . local_flow
endif
if executable(local_flow)
  let g:flow#flowpath = local_flow
endif

" Themes stuff
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
let g:solarized_bold = "1"
let g:markdown_fenced_languages = ['html', 'python', 'ruby']

" air-line
let g:airline_powerline_fonts = 1
let g:airline_theme = 'papercolor'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" vim-go
let g:go_metalinter_enabled = ['vet', 'golint', 'deadcode', 'errcheck']

" rust
let g:rustfmt_autosave = 1

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Movements and custom
" inoremap jj <ESC>
nnoremap j gj
nnoremap k gk
nnoremap <tab> %
vnoremap <tab> %
autocmd FileType ruby map <Leader>1 :w<CR>:!ruby -c %<CR>
" autocmd FileType ruby map <F9> :w<CR>:!ruby -c %<CR>
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
nnoremap <CR> G

" Dispatch
nnoremap <F1> :AsyncRun 

" Smooth-scroll
" noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
" noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>

" Search
map <C-f> :Ag --mmap -i 

" Nerdtree-git-Plug
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "•",
    \ "Staged"    : "+",
    \ "Untracked" : "*",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "-",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }

" Nerdtree
map <C-n> :NERDTreeToggle<CR>
map <Leader>r :NERDTreeFind<CR>
map <Leader>t :tabnew<CR>
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1
let g:NERDTreeWinSize=55
let g:NERDTreeIgnore=['\~$', 'vendor', '.bundle']

" Writes
nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>e :wq<CR>

" This prevents `v, p` from replacing paste buffer
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

" set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

" Backups & Files
set backup                     " Enable creation of backup file.
set backupdir=~/.vim/backup/   " Where backups will go.
set directory=~/.vim/swp/     " Where temporary files will go.

" Git Browse
map <Leader>gg :GBrowse<cr>
map <Leader>gb :Git blame<cr>

" vim-gitgutter
set updatetime=300
set signcolumn=yes

" Custom Prompt
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

if exists("+showtabline")
  set stal=2
  set tabline=%!MyTabLine()
endif

" Cursor Column
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
set cursorline
nnoremap <Leader>c :set cursorcolumn!<CR>

hi CursorLine   cterm=NONE ctermbg=NONE
" hi CursorLine   cterm=NONE ctermbg=234
" hi CursorLineNr cterm=NONE ctermbg=NONE
hi CursorLineNr term=bold cterm=bold ctermfg=012 gui=bold
hi CursorColumn cterm=NONE ctermbg=237

" Strip White space
function! <SID>StripTrailingWhitespaces()
  " Don't strip on these filetypes
  if &ft =~ 'vim\|perl'
    return
  endif
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
autocmd BufNewFile,BufReadPost *.markdown set filetype=markdown

" Folding
function! NeatFoldText()
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = matchstr(&fillchars, 'fold:\zs.')
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()
set foldcolumn=2

" Colorscheme overrides
" Dark background - white/gray text
" hi Normal ctermfg=231 ctermbg=NONE cterm=NONE guifg=#f8f8f2 guibg=#272822 gui=NONE
" Light background - dark text
" hi Normal ctermfg=235 ctermbg=NONE cterm=NONE guifg=#272822 guibg=NONE gui=NONE

" hi LineNr ctermbg=235
hi foldcolumn ctermbg=None
" hi Folded ctermbg=none
hi VertSplit ctermbg=None ctermfg=NONE cterm=NONE
" hi SignColumn ctermbg=235
"
" Dark background
hi Normal ctermbg=none
" Light background
" hi Normal ctermbg=none
"
hi LineNr ctermbg=none
hi Folded ctermbg=none
hi NonText ctermbg=none
hi SpecialKey ctermbg=none
" hi VertSplit ctermbg=none
hi SignColumn ctermbg=none

" Dark background
hi TabLineFill ctermbg=None
hi TabLine ctermbg=None
hi TabLineSel ctermfg=BLUE ctermbg=None
hi TabLineSel ctermfg=BLUE
"
" Light background
" hi TabLineFill ctermbg=None
" hi TabLine ctermbg=None ctermfg=240
" hi TabLineSel ctermfg=235 ctermbg=None cterm=bold
