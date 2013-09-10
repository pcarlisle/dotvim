" Configuration file for gvim

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Switch syntax highlighting on, when the terminal has colors
if has("syntax") && (&t_Co > 2 || has("gui_running"))
    syntax on
endif

"set background=light
colorscheme solarized

" Set gui options
if has("gui")
    set columns=120               " Use a larger window by default
    set lines=36
    set guifont=Consolas\ 13   " A nice monospace font at a good size
    set mousehide                 " Hide the cursor when typing
    set go-=T                     " No toolbar
    set laststatus=2              " Show a status bar even with only one window
endif

" MacVim-Specific gui options
if has("gui_macvim")
    " Set fullscreen options, maximize vertical size and set unused areas to 
    " almost black. Add maxhorz to maximize width.
    set fuopt=maxvert,maxhorz,background:#FF0A0A0A
endif

" No bell of any sort
set vb t_vb=
