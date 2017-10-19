filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rhubarb'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
" Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-endwise'
" Plugin 'tpope/vim-dispatch'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'Raimondi/delimitMate'
" Plugin 'kien/ctrlp.vim'
Plugin 'docunext/closetag.vim'
Plugin 'ervandew/supertab'
Plugin 'scrooloose/nerdtree'
Plugin 'mileszs/ack.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'L9'
Plugin 'rking/ag.vim'
Bundle 'flazz/vim-colorschemes'
Bundle 'bling/vim-airline'
" Bundle 'derekwyatt/vim-scala'
" Plugin 'tpope/vim-rsi'
" Plugin 'editorconfig/editorconfig-vim'
Plugin 'fatih/vim-go'
Plugin 'junegunn/goyo.vim'
" Plugin 'vim-syntastic/syntastic'
Plugin 'easymotion/vim-easymotion'
Plugin 'vim-scripts/SearchComplete'
Plugin 'SirVer/ultisnips'
" Plugin 'garbas/vim-snipmate'
" Plugin 'honza/vim-snippets'
" Plugin 'kchmck/vim-coffee-script'
Plugin 'elixir-lang/vim-elixir'
Plugin 'janko-m/vim-test'
" Plugin 'terryma/vim-smooth-scroll'
Plugin 'tpope/vim-markdown'
" Plugin 'flowtype/vim-flow'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'junegunn/fzf.vim'
" Plugin 'w0rp/ale'
" Plugin 'vim-scripts/indentpython.vim'
" Plugin 'nvie/vim-flake8' -- python
" Plugin 'tpope/vim-fireplace'
" Plugin 'Shougo/neocomplete'

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
set colorcolumn=100
set statusline+=%F
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

autocmd FileType text setlocal textwidth=78
autocmd FileType markdown setlocal wrap
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType scss  setlocal shiftwidth=2 tabstop=2
autocmd FileType css   setlocal shiftwidth=2 tabstop=2
autocmd FileType html  setlocal shiftwidth=2 tabstop=2

" FZF
set rtp+=/usr/local/opt/fzf
nmap <c-p> :GFiles<CR>
nmap ; :Buffers<CR>

" vim-javascript
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1
let g:javascript_plugin_ngdoc = 1
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

" Eslint
" let g:syntastic_javascript_jslint_args = "--white --nomen --regexp --browser --devel --windows --sloppy --vars"
let g:syntastic_javascript_jslint_args = "--rulesdir /Users/homan/Projects/tulip/tools/eslint-rules/lib/rules/"
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint', 'flow']
let g:syntastic_javascript_flow_exe = 'flow'
let g:syntastic_javascript_eslint_exe = '$(npm bin)/eslint --rulesdir /Users/homan/Projects/tulip/tools/eslint-rules/lib/rules'


let g:ale_javascript_flow_executable = "$(npm bin)/flow"
let g:ale_javascript_eslint_executable = "$(npm bin)/eslint"
let g:ale_javascript_eslint_options = "--rulesdir /Users/homan/Projects/tulip/tools/eslint-rules/lib/rules"
let g:ale_sign_column_always = 1
let g:flow#showquickfix = 1
let g:ale_lint_on_enter = 0
let g:ale_linters = {
\   'javascript': ['eslint', 'flow'],
\}

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
let g:airline_powerline_fonts = 1
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'ruby']

" Tagbar
" nmap <F8> :TagbarToggle<CR>
" nmap ; :CtrlPBuffer<CR>

" Movements and custom
" inoremap jj <ESC>
nnoremap j gj
nnoremap k gk
nnoremap <tab> %
vnoremap <tab> %
nnoremap <Leader>1 yypk
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>
nnoremap <CR> G

" Dispatch
nnoremap <F1> :AsyncRun 

" Smooth-scroll
" noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
" noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>

" Easymotion
map <Leader>s <Plug>(easymotion-s)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>f <Plug>(easymotion-bd-w)
map \ <Plug>(easymotion-prefix)

" Search
map <C-f> :Ag 

" Nerdtree-git-plugin
let g:NERDTreeIndicatorMapCustom = {
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
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinSize=60

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

" Cursor Column
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>
:set cursorline!
nnoremap <Leader>c :set cursorcolumn!<CR>

" CtrlP
" let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlP'
" let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$|node_modules'
" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
" let g:ctrlp_use_caching = 0
" " let g:ctrlp_working_path_mode = 'ra'
" let g:ctrlp_working_path_mode = 0
" " let g:ctrlp_match_window_bottom = 0
" " let g:ctrlp_match_window_reversed = 0
" let g:ctrlp_dotfiles = 0
" let g:ctrlp_switch_buffer = 0
" set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

" Backups & Files
set backup                     " Enable creation of backup file.
set backupdir=~/.vim/backup/   " Where backups will go.
set directory=~/.vim/swp/     " Where temporary files will go.

colorscheme Monokai

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

hi TabLineFill term=NONE cterm=NONE ctermbg=233
hi TabLineSel term=NONE cterm=NONE ctermbg=240
hi TabLine term=NONE cterm=NONE ctermbg=233
hi CursorLine   cterm=NONE ctermbg=237
hi CursorColumn cterm=NONE ctermbg=237

" GOYO"
function! s:goyo_enter()
  set number
endfunction

function! s:goyo_leave()
  set showtabline=2
  hi TabLineFill term=NONE cterm=NONE ctermbg=233
  hi TabLineSel term=NONE cterm=NONE ctermbg=240
  hi TabLine term=NONE cterm=NONE ctermbg=233
  hi CursorLine   cterm=NONE ctermbg=237
  hi CursorColumn cterm=NONE ctermbg=237

  set stal=2
  set tabline=%!MyTabLine()
  set number
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
nnoremap <Leader>z :Goyo<CR>
let g:goyo_width = 200
let g:goyo_height = 100

" ------------------- Strip White space --------------------- "
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

hi LineNr ctermbg=bg
set foldcolumn=2
hi foldcolumn ctermbg=bg
hi VertSplit ctermbg=bg ctermfg=bg
