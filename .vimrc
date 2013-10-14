" Configuration file for vim (vimrc)

set viminfo='20,\"50    " read/write a .viminfo file -- limit to only 50
set history=100         " keep 50 lines of command history

set nocompatible        " Use Vim defaults (much better!)

filetype off            " for vundle

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'

Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-rsi'
Bundle 'tpope/vim-rake'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-rbenv'
Bundle 'tpope/vim-tbone'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-unimpaired'
Bundle 'thoughtbot/vim-rspec'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'kien/ctrlp.vim'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'vim-scripts/matchit.zip'
Bundle 'christoomey/vim-tmux-navigator'
"Bundle 'duskhacker/sweet-rspec-vim'
Bundle 'terryma/vim-multiple-cursors'

"clojure
Bundle 'tpope/vim-classpath'
Bundle 'tpope/vim-fireplace'
Bundle 'guns/vim-clojure-static'
Bundle 'vim-scripts/paredit.vim'

Bundle 'vim-ruby/vim-ruby'

" File type detection
filetype plugin on
" Language-dependent indenting
filetype indent on


" Tab completion for files: first tab show longest match, second show list of
" competions, more tabs cycle through completions
set wildmode=longest,list,full

set et                  " Automatically expand tabs to spaces
set shiftwidth=4        " wide, otherwise it's tabstop wide.
set softtabstop=4       " Simulated tabstop of 4 by using spaces and tabs
set bs=2                " Allow backspacing over everything in insert mode
set autoindent          " Always set auto-indenting on
set backup              " Keep a backup file
set backupdir=~/.backup,.,~/    " in a less obtrusive place
set ruler               " Show the cursor position all the time
set nowrap              " Don't wrap display of long lines
set smarttab            " A tab as the first character on a line is shiftwidth
set shiftround		" round indent to shiftwidth

set textwidth=78        " Set wrap at 78
set formatoptions=crq   " Format options for code, only wrap in comments

set linebreak           " when in wrap mode break at reasonable places

set tagstack            " Keep track of visited tags in a stack
set hidden              " Allow buffers to become hidden and keep unwritten changes

set background=light
colorscheme solarized

set showmatch           " Show matching brackets
set showcmd             " Show (partial) command in status line.

" searching
set incsearch           " Incremental search
set nohlsearch          " No highlighted searches

set infercase           " Handle case in a smart way in autocompletes
set ignorecase          " Case insensitive searching, needed to enable smartcase
set smartcase           " Do smart case search

set diffopt=filler,foldcolumn:2,context:10

set sidescroll=1        " Smooth sidescroll
set relativenumber      " Show line numbers relative to current line
set sidescrolloff=4     " Scroll when this many characters from edge.
set scrolloff=4         " Scroll when this many characters from top or bottom.

" Standard statusline
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

set splitright          " Vertical split puts new window on the right

" Set statusline to show current highlight group
"set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}

" make grep always generate a filename--for latex-suite
set grepprg=grep\ -nH\ $*

set mouse=a             " Use the mouse

" Prevent modelines in files from being evaluated (avoids a potential
" security problem wherein a malicious user could write a hazardous
" modeline into a file) (override default value of 5)
set modelines=0

set listchars=eol:$,tab:>-,trail:-,extends:>,precedes:<
if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
    set fileencodings=utf-8,latin1
endif

" Toggle highlighting characters past textwidth (or 80 if tw=0)
nmap <silent> <Leader>l :call <SID>ToggleTWHi()<CR>
function! <SID>ToggleTWHi()
    if exists('w:long_line_match')
        silent! call matchdelete(w:long_line_match)
        unlet w:long_line_match
    elseif &textwidth > 0
        let w:long_line_match = matchadd('ErrorMsg', '\%>'.&tw.'v.\+', -1)
    else
        let w:long_line_match = matchadd('ErrorMsg', '\%>80v.\+', -1)
    endif
endfunction

" Show highlight groups of text under the cursor
nmap <Leader>sI :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" Display info about the highlight group currently being used to color the
" text under the cursor
nmap <Leader>sC :call <SID>SynInfo()<CR>
function! <SID>SynInfo()
    let l:id = synID(line('.'), col('.'), 1)
    let l:idt = synIDtrans(id)
    echo synIDattr(id, 'name') '->' synIDattr(idt, 'name')
    echo 'fg:' synIDattr(idt, 'fg')
    echon ' (' synIDattr(idt, 'fg#') ")\n"
    for attr in ['bg', 'sp']
        if synIDattr(idt, attr)
            echo (attr . ':') synIDattr(idt, attr)
            echon ' (' synIDattr(idt, attr . '#') ")\n"
        endif
    endfor
    for attr in ['bold', 'italic', 'reverse', 'inverse', 'underline', 'undercurl']
        if synIDattr(idt, attr)
            echon attr ' '
        endif
    endfor
endfunction

" Toggle color display mode
nmap <silent> <Leader>c :call <SID>ToggleHLDisplay()<CR>
function! <SID>ToggleHLDisplay()
    if exists("w:statusline_save")
        let &statusline = w:statusline_save
        unlet w:statusline_save
    else
        let w:statusline_save = &statusline
        set statusline=%{synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name')}\ %{synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'fg')}
    endif
endfunction

" For use in templates set up for various file types
fun! s:SetFileName()
    exe "%s/filename/" . expand("%") . "/"
endfun

command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
	 	\ | wincmd p | diffthis

" Only do this part when compiled with support for autocommands
if has("autocmd")
    " In text files, always limit the width of text to 78 characters
    autocmd BufRead,BufNewFile *.txt setlocal tw=78 fo=tcrq
    " When editing a file, always jump to the last cursor position
    autocmd BufReadPost *
    \ if line("'\"") > 0 && line ("'\"") <= line("$") |
    \   exe "normal g'\"" |
    \ endif

    " Gentoo-specific settings for ebuilds.  These are the federally-mandated
    " required tab settings.  See the following for more information:
    " http://www.gentoo.org/doc/en/xml/gentoo-howto.xml
    augroup gentoo
        au!
        au BufRead,BufNewFile *.e{build,class} let is_bash=1|setlocal ft=sh
        au BufRead,BufNewFile *.e{build,class} setlocal ts=4 sw=4 noexpandtab
    augroup END

    augroup c
        au!
        au BufRead,BufNewFile *.c,*.h setlocal ts=8 sw=4 tw=78 et
        au BufEnter     *.c     abbr MAIN int main(int argc, char **argv) {<CR>return(0);<CR>}<Esc>2k$a
        au BufLeave     *.c     unabbr MAIN
    augroup END

    augroup ruby
        au!
        au FileType ruby setlocal tw=72 ts=2 sw=2 et
    augroup END

    augroup haskell
        au!
        au FileType haskell setlocal ts=2 sw=2 et
    augroup END

    autocmd FileType haskell nmap <C-c><C-l> :GhciRange<CR>
    autocmd FileType haskell vmap <C-c><C-l> :GhciRange<CR>
    autocmd FileType haskell nmap <C-c><C-f> :GhciFile<CR>
    
    augroup python
        au!
        au FileType python setlocal ts=8 sw=4 et tw=72 foldmethod=indent
        au FileType python normal zR
    augroup END

    augroup rdoc
        au!
        au BufRead,BufNewFile *.rdoc setlocal ts=2 sw=2 tw=78
    augroup END
    
    augroup shell
        au!
        au BufNewFile   *.sh    call append(0,"#!/bin/sh")
    augroup END

    augroup tex
        au BufRead *.tex setlocal tw=78 fo+=t
    augroup END

    augroup markdown
        au!
        au FileType markdown setlocal tw=72 ts=2 sw=2 et
    augroup END
endif

" Switch syntax highlighting on, when the terminal has colors
" since this information is used by other scripts like indent files maybe we
" want it on even when we don't have color - what happens if we try?
if &t_Co > 2 || has("gui_running")
      syntax on
endif

if &term=="xterm"
        set t_RV=          " don't check terminal version
        set t_Co=16
        set t_Sb=^[4%dm
        set t_Sf=^[3%dm
endif

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.class,.pyc,.hi

" netrw file browser settings

" comma separated pattern list for hiding files
let g:netrw_list_hide = '.*\.pyc$'

" MiniBufExplorer settings
"let g:miniBufExplSplitBelow=1   " Show the explorer at the bottom
let g:miniBufExplMapCTabSwitchBufs = 1  " <C-Tab> and <C-S-Tab> switches buffers
let g:miniBufExplMapWindowNavArrows = 1 " Shift-arrows changes window
let g:miniBufExplModSelTarget = 1       " Don't open buffers in unmodifiable windows (e.g. an explorer window)


" Select colormap: 'soft', 'softlight', 'standard' or 'allblue'
let xterm16_colormap    = 'softlight'
" Select brightness: 'low', 'med', 'high', 'default' or custom levels.
let xterm16_brightness  = 'high'
"set bg=light
"colo xterm16

" Location of exuberant ctags for taglist plugin
let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
" Don't attempt to resize the window
let Tlist_Inc_Winwidth=0

" Language specific syntax and indent options:
" see ft-language-* help for more

" Python
let pyindent_open_paren = '&sw'
let pyindent_continue = '&sw'

" Old version of python.vim:
let python_highlight_space_errors = 1   " Highlight trailing spaces and mixed tabs and spaces
let python_highlight_numbers = 1
let python_highlight_builtins = 1
let python_highlight_exceptions = 1

"New version of python.vim:
let python_space_error_highlight = 1

let python_79_char_line_limit = 1 " python.vim from moin uses this

" C
"let c_space_errors = 1      " Highlight trailing white space and spaces before a <Tab>
let c_syntax_for_h = 1      " Use C syntax for .h files instead of C++
let c_gnu = 1               " Highlight GNU gcc specific keywords
let c_minlines = 100        " How far back syntax synchronization starts. Disable this is redrawing becomes slow.

" Ruby
let ruby_space_errors = 1   " Highlight whitespace errors
"let ruby_fold = 1           " Enable folding

let filetype_i = "asm"      " *.i files are always asm because I don't edit Progress files

"let g:rspec_command = "!bundle exec rspec {spec}"
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  let g:ackprg = 'ag --nogroup --column'

  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif


au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces
