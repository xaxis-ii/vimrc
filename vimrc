" URL: https://github.com/xaxis-ii/vimrc
" Authors: Simon Koch (https://github.com/xaxis-ii/)
" Description: Vim, how I like it. Reworked to use Vim 8's new inbuilt plugin management feature.

" Set 'nocompatible' to ward off unexpected things that your distro might
" have made, as well as sanely reset options when re-sourcing .vimrc
set nocompatible

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

"------------------------------------------------------------
" Features {{{1
 
" Enable syntax highlighting
syntax on
set background=dark
colorscheme solarized

" Vim with default settings does not allow easy switching between multiple files
" in the same editor window. Users can use multiple split windows or multiple
" tab pages to edit multiple files, but it is still best to enable an option to
" allow easier switching between files.
"
" One such option is the 'hidden' option, which allows you to re-use the same
" window and switch from an unsaved buffer without saving it first. Also allows
" you to keep an undo history for multiple files when re-using the same window
" in this way. Note that using persistent undo also lets you undo in multiple
" files even in the same window, but is less efficient and is actually designed
" for keeping undo history after closing Vim entirely. Vim will complain if you
" try to quit without saving, and swap files will keep you safe if your computer
" crashes.
set hidden
 
" Note that not everyone likes working this way (with the hidden option).
" Alternatives include using tabs or split windows instead of re-using the same
" window as mentioned above, and/or either of the following options:
" set confirm
" set autowriteall

" Better command-line completion
set wildmenu
 
" Show partial commands in the last line of the screen
set showcmd
 
" Highlight searches (use <C-L> to temporarily turn off highlighting; see the
" mapping of <C-L> below)
set hlsearch

"------------------------------------------------------------
" Usability options {{{1
 
" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" Allow backspacing over autoindent, line breaks and start of insert action
set backspace=indent,eol,start

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on. Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most users
" coming from other editors would expect.
set nostartofline

" Display the cursor position on the last line of the screen or in the status
" line of a window
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Instead of failing a command because of unsaved changes, instead raise a
" dialogue asking if you wish to save changed files.
set confirm

" Use visual bell instead of beeping when doing something wrong
set visualbell

" And reset the terminal code for the visual bell. If visualbell is set, and
" this line is also included, vim will neither flash nor beep. If visualbell
" is unset, this does nothing.
set t_vb=

" Enable use of the mouse for all modes
set mouse=a

" Set the command window height to 2 lines, to avoid many cases of having to
" press <Enter> to continue
set cmdheight=2

" Display line numbers on the left
set number

" Quickly time out on keycodes, but never time out on mappings
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>

"------------------------------------------------------------
" Statusline {{{1
"
" Statusline components and format

set statusline =
" Buffer number
set statusline +=[%n]
" File description
set statusline +=\ %f\ %h%m%r%w
" Name of the current function (needs taglist.vim)
set statusline +=\ \{%{Tlist_Get_Tagname_By_Line()}\}
" Name of the current branch (needs fugitive.vim)
set statusline +=\ %{fugitive#statusline()}
" Date of the last time the file was saved
set statusline +=\ %{strftime(\"[%d/%m/%y\ %T]\",getftime(expand(\"%:p\")))} 
" Total number of lines in the file
set statusline +=%=%-10L
" Line, column and percentage
set statusline +=%=%-14.(%l,%c%V%)\ %P

"------------------------------------------------------------
" Indentation options {{{1
"
" Indentation settings according to personal preference.

" Indentation settings for using 4 spaces instead of tabs.
" Do not change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab


" Indentation settings for using hard tabs for indent. Display tabs as
" four characters wide.
"set shiftwidth=4
"set tabstop=4

"------------------------------------------------------------
" Fold options {{{1
"
" Folding settings according to preference
 
" Turn on folding based on syntax
set foldmethod=syntax
set foldlevel=0
"set foldclose=all
let c_no_comment_fold = 1

"------------------------------------------------------------
" Automated Processes {{{1
"
" == Save folds on exit

augroup AutoSaveFolds
  function! LoadView() abort
    try
      silent loadview | filetype detect
    catch /E32/
      return
    catch /E788/
      return
    endtry
  endfunction
  function! MkView() abort
    try
      mkview | filetype detect
    catch /E32/
      return
    endtry
  endfunction

  autocmd!
  autocmd BufWinLeave ?* call MkView()
  autocmd BufWinEnter ?* call LoadView()
augroup END

" Set HTML, CSS, JS, TS to tabstop 2
autocmd FileType html,css,javascript,typescript setlocal shiftwidth=2 softtabstop=2 expandtab

"------------------------------------------------------------
" Mappings {{{1
"
" == Useful mappings

" Map Y to act like D and C, i.e. to yank until EOL, rather than act as yy,
" which is the default
map Y y$

" Map <C-L> (redraw screen) to also turn off search highlighting until the
" next search
nnoremap <C-L> :nohl<CR><C-L>

" == <ESC> replacement(s)

" Can be typed even faster than jj, and if you are already in
"    normal mode, you (usually) don't accidentally move:
:imap jk <Esc>
:imap kj <Esc>

" == Turn off cheats (i.e. no <up> <down> <left> <right> for you!)
" Better idea - why not use them for subwindow navigation; that way they're
"               more useful to us, and we're not tempted to cheat.

nnoremap <up>    <C-w>k
nnoremap <down>  <C-w>j
nnoremap <left>  <C-w>h
nnoremap <right> <C-w>l
inoremap <up>    <C-w>k
inoremap <down>  <C-w>j
inoremap <left>  <C-w>h
inoremap <right> <C-w>l
vnoremap <up>    <C-w>k
vnoremap <down>  <C-w>j
vnoremap <left>  <C-w>h
vnoremap <right> <C-w>l

" Toggle TagList with <F8> in normal mode
nnoremap <silent> <F8> :TlistToggle<CR>

" Toggle NERDTree with <F4> in normal mode
nnoremap <silent> <F4> :NERDTreeToggle<CR>


"------------------------------------------------------------
" ALE Linter {{{1
"

let g:ale_completion_enabled = 1

"------------------------------------------------------------



