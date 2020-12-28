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
if filereadable(expand("$HOME/.vim/colors/pencil.vim"))
    colorscheme pencil
endif
if isdirectory(expand("$HOME/.vim/bkfiles"))
    set directory=$HOME/.vim/bkfiles
    set backupdir=$HOME/.vim/bkfiles
    set undodir=$HOME/.vim/bkfiles
    set undofile
    set viminfo+=n$HOME/.vim/viminfo
endif
set cursorline
set encoding=utf-8
set nrformats=alpha
set virtualedit=onemore
set virtualedit+=block

function! SwitchCommentOut()
    let com = ""
    let dict = {
\        "python": "#",
\        "sh": "#",
\        "c": "//",
\        "vim": "\"",
\        "go": "//",
\        "haskell": "--"
\    }
    let com = get(dict, &syntax, "")
    if (com == "")
        return
    endif
    let length = len(com)
    let head = matchstr(getline('.'), '[^ ]\{' . length . '\}')
    if (head == com)
        execute "normal ^" . length . "x=="
    else
        execute "normal I" . com
    endif
endfunction
function! BracketSurround(bracket) range
    let b = a:bracket
    if (visualmode() ==# "V")
        let b = strpart(b, 0, 1) . "\n" . strpart(b, 1, 1)
    endif
    silent normal gvy
    execute "silent normal gvc" . b
    silent normal P
endfunction

nnoremap j gj
nnoremap k gk
nnoremap <silent> S> :+tabm<CR>
nnoremap <silent> S< :-tabm<CR>
nnoremap <C-H> :%s///gc<LEFT><LEFT><LEFT>
nnoremap / /\v
nnoremap <C-W><C-V> <C-W><C-V><C-W><C-X><C-W><C-W>
nnoremap [1;5I gt
nnoremap [1;6I gT
nnoremap Y y$
nnoremap <silent> <C-j> :bprev<CR>
nnoremap <silent> <C-k> :bnext<CR>
nnoremap [1;5m[1;5m :call SwitchCommentOut()<CR>
nnoremap  :call SwitchCommentOut()<CR>
cnoremap <C-P> <UP>
cnoremap <C-N> <DOWN>
cnoremap <UP> <C-P>
cnoremap <DOWN> <C-N>
vnoremap [1;5m[1;5m :call SwitchCommentOut()<CR>
vnoremap   :call SwitchCommentOut()<CR>
vnoremap <C-H> :s///gc<LEFT><LEFT><LEFT>
vnoremap <silent> s{ :call BracketSurround("{}")<CR>
vnoremap <silent> s( :call BracketSurround("()")<CR>
vnoremap <silent> s< :call BracketSurround("<>")<CR>
vnoremap <silent> s[ :call BracketSurround("[]")<CR>
vnoremap <silent> s$ :call BracketSurround("$$")<CR>
vnoremap <silent> s" :call BracketSurround("\"\"")<CR>
vnoremap <silent> s' :call BracketSurround("\'\'")<CR>
vnoremap <silent> s` :call BracketSurround("\`\`")<CR>
vnoremap <silent> <C-R> :call RunCmd()<CR>
inoremap <silent> <C-CR> <END><CR>
inoremap <silent> jj <ESC>
inoremap <silent> ()H ()<LEFT>
inoremap <silent> {}H {}<LEFT>
inoremap <silent> []H []<LEFT>
inoremap <silent> ''H ''<LEFT>
inoremap <silent> ""H ""<LEFT>
command! Editvimrc e ~/.vimrc
command! Evimrc Editvimrc
command! Sourcevimrc source ~/.vimrc
set clipboard=unnamed,autoselect
set autochdir
set shiftwidth=4
set foldmethod=indent
set pumheight=10
set scrolloff=2
set softtabstop=4

command! Delete call delete(expand("%"))
command! -nargs=1 Rename call RenameFunc(<f-args>)
command! Backup w! %_bac
command! Restore call RestoreFunc(expand("%"), expand("%") . "_bac")

function! RunCmd()
    silent normal gvy
    execute ":r!" . @"
endfunction

function! RenameFunc(name)
    execute "f " . a:name . " | call delete(expand(\"#\")) | w"
endfunction

function! RestoreFunc(cname, bname)
    execute "Delete"
    execute "e " a:bname
    execute "w " a:cname
    execute "e " a:cname
endfunction
let &t_SI.="\e[5 q"
let &t_EI.="\e[1 q"

" Windows Subsystem for Linux で、ヤンクでクリップボードにコピー
if system('uname -a | grep Microsoft') != ''
    augroup myYank
    autocmd!
    autocmd TextYankPost * :call system('/mnt/d/utl/clip.exe', @")
    augroup END
endif
