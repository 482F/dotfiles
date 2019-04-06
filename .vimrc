scriptencoding utf-8
set ignorecase
set smartcase
set tabstop=4
set expandtab
set smartindent
set backspace=indent,eol,start
set wrapscan
set showmatch
set wildmenu
set wildmode=longest,list:longest
set formatoptions+=mM
set number
set ruler
set nolist
set wrap
set laststatus=2
set cmdheight=2
set showcmd
set title
set background=light
colorscheme pencil
set directory=$HOME/.vim/bkfiles
set backupdir=$HOME/.vim/bkfiles
set undodir=$HOME/.vim/bkfiles
set undofile
set viminfo+=n$HOME/.vim/viminfo
set cursorline
set encoding=utf-8
set nrformats=alpha
set virtualedit=onemore

nnoremap j gj
nnoremap k gk
nnoremap <silent> S> :+tabm<CR>
nnoremap <silent> S< :-tabm<CR>
nnoremap <C-H> :%s///gc<LEFT><LEFT><LEFT>
nnoremap / /\v
nnoremap <C-W><C-V> <C-W><C-V><C-W><C-X><C-W><C-W>
nnoremap <C-Tab> gt
nnoremap <C-S-Tab> gT
nnoremap Y y$
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>
cnoremap <C-P> <UP>
cnoremap <C-N> <DOWN>
cnoremap <UP> <C-P>
cnoremap <DOWN> <C-N>
vnoremap <C-H> :s///gc<LEFT><LEFT><LEFT>
inoremap <silent> <C-CR> <END><CR>
inoremap <silent> jj <ESC>
inoremap <silent> ()H ()<LEFT>
inoremap <silent> {}H {}<LEFT>
inoremap <silent> []H []<LEFT>
inoremap <silent> ''H ''<LEFT>
inoremap <silent> ""H ""<LEFT>
inoremap <silent> )L <C-r>=EndSymbol(")")<CR>
inoremap <silent> }L <C-r>=EndSymbol("}")<CR>
inoremap <silent> ]L <C-r>=EndSymbol("]")<CR>
inoremap <silent> 'L <C-r>=EndSymbol("'")<CR>
inoremap <silent> "L <C-r>=EndSymbol('"')<CR>
command! Editvimrc e ~/.vimrc
command! Evimrc Editvimrc
command! Sourcevimrc source $VIM/vimrc
set clipboard=unnamed,autoselect
set autochdir
set shiftwidth=4
set foldmethod=indent
set pumheight=10
set scrolloff=2
set softtabstop=4

