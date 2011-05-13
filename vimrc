" This is my .vimrc...I use gvim on linux, macvim on Mac OS. 7.3 required.
" Note that there's no particular ordering here (except pathogen stuff comes first).

" =========================================== Configure Pathogen ============================================
filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

" =========================================== Basic Settings ================================================
syntax on
filetype plugin indent on

" Text-wrapping stuff. (Also check out my cursorcolumn setting in .gvimrc.)
set textwidth=110 " 80-width lines is for 1995
let &wrapmargin= &textwidth
set formatoptions=croql " Now it shouldn't hard-wrap long lines as you're typing (annoying), but you can gq
                        " as expected.

set hidden "This allows vim to put buffers in the bg without saving, and then allows undoes when you fg them again.
set history=1000 "Longer history
set number
set hlsearch
set autoindent
set smartindent
set expandtab
set wildmenu
set wildmode=list:longest
set scrolloff=3 " This keeps three lines of context when scrolling
set title
set expandtab
set smarttab
set ts=2
set sw=2
set sts=2
set laststatus=2
set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%c\",getftime(expand(\"%:p\")))}%=\ lin:%l\,%L\ col:%c%V\ pos:%o\ ascii:%b\ %P
set ignorecase
set smartcase
set undofile
set backspace=indent,eol,start
set linespace=3
set incsearch

" Allow for modelines
set modeline

let mapleader = ","

" Bells == annoying
set vb
set t_vb=
if has("autocmd") && has("gui")
  au GUIEnter * set t_vb=
endif

" For some reason I accidentally hit this shortcut all the time...let's disable it. (I usually don't look at
" man pages from within vim anyway.)
map K <Nop>

" Textmate-style invisible char markers
set list
set listchars=tab:▸\ ,eol:¬

" Macvim default clipboard interaction is bullshit
set clipboard=unnamed

" Ensure the temp dirs exist
call system("mkdir -p ~/.vim/tmp/blah")
call system("mkdir -p ~/.vim/tmp/backup")
call system("mkdir -p ~/.vim/tmp/undo")

" Change where we store swap/undo files
set dir=~/.vim/tmp/swap//
set backupdir=~/.vim/tmp/backup//
set undodir=~/.vim/tmp/undo/

" Don't back up temp files
set backupskip=/tmp/*,/private/tmp/*

" ======================================= Colorscheme Settings ==============================================
set t_Co=16
set background=dark
colorscheme lucius

" Adjust colors as necessary
hi ColorColumn     guibg=#444444
hi ColorColumn     ctermbg=0
hi IncSearch       guifg=NONE     guibg=#353E44
hi IncSearch       ctermfg=NONE   ctermbg=67
hi Search          guifg=NONE     guibg=#545449
hi Search          ctermfg=NONE   ctermbg=22
hi Comment         guifg=#999999  gui=NONE
hi Comment         ctermfg=245    cterm=NONE

" Show extra whitespace
hi ExtraWhitespace guibg=#CCCCCC
hi ExtraWhitespace ctermbg=7
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" ======================================== Plugin-specific Settings =========================================
" Gundo settings
nnoremap <leader>g :GundoToggle<CR>

" NERDTree settings
let g:NERDTreeChDirMode=2
let g:NERDChristmasTree=1
nmap <leader>t :NERDTreeToggle<CR>

" Stupid NERDCommenter warning
let NERDShutUp=1

" ========================================== Custom Commands ================================================
" A command to delete all trailing whitespace from a file.
command! DeleteTrailingWhitespace %s:\(\S*\)\s\+$:\1:

" Preview the current markdown file:
command! MarkdownDoctor :%w ! markdown_doctor \| bcat<CR><CR>

" Toggle colorcolumn
function! ToggleColorColumn()
  if &colorcolumn == 0
    " Draw the color column wherever wrapmargin is set
    let &colorcolumn = &wrapmargin
  else
    let &colorcolumn = 0
  endif
endfunction
command! ToggleColorColumn call ToggleColorColumn()

" ============================================ My Mappings ==================================================
" Mappings:
map <F6> :b#<CR>
map <C-n> :noh<CR>

" I don't use s and S in normal mode much. Let's make them do something useful
" * s will break the line at the current spot and move it down.
" * S is the same, but moves it up.
nnoremap s i<CR><ESC>==
nnoremap S d$O<ESC>p==

" Make it easier to move around through blocks of text:
noremap <C-J> gj
noremap <C-k> gk
noremap U 30k
noremap D 30j

" Close a buffer without messing with the windows (vim-bclose)
nmap <leader>q <Plug>Kwbd


" Shortcuts for custom commands:
map <leader>m :MarkdownDoctor<CR>
map <leader>l :ToggleColorColumn<CR>

" ====================================== Language-specific Settings =========================================
" Nice ruby settings
let ruby_space_settings = 1

" Go specific settings
augroup golang
  au!
  au FileType go set noexpandtab
augroup END

" Markdown settings
augroup markdown
  au!
  au FileType markdown set comments=b:*,b:-,b:+,n:>h
augroup END

" Coffeescript settings (related to vim-coffee-script plugin)
vmap <leader>co :CoffeeCompile<CR>
