inoremap ;; <esc>
set nocompatible
set expandtab
set shiftwidth=2
set softtabstop=2
set autochdir
set clipboard=unnamed

""call pathogen#infect()
  " Some Linux distributions set filetype in /etc/vimrc.
  " Clear filetype flags before changing runtimepath to force Vim to reload them.
  "" if exists("g:did_load_filetypes")
    filetype off 
    filetype plugin indent off 
  "" endif
" Plugin 'slimv'
""  set runtimepath+=~/.vim/bundle/slimv/ftplugin " replace $GOROOT with the output of: go env GOROOT
""  set runtimepath+=~/.vim/bundle/slimv/plugin " replace $GOROOT with the output of: go env GOROOT
""  set runtimepath+=~/.vim/bundle/slimv " replace $GOROOT with the output of: go env GOROOT
  filetype plugin indent on
  syntax on

"" Lisp. start swank
let g:paredit_mode = 0
"" let g:slimv_swank_cmd ='! xterm -e sbcl --load ~/quicklisp/dists/quicklisp/software/slime-2.13/start-swank.lisp &'
"" #let g:slimv_swank_cmd ='! xterm -e clisp ~/quicklisp/dists/quicklisp/software/slime-2.13/start-swank.lisp &'
""nnoremap <F3> :ToggleNumbers
if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif
nnoremap <F4> :set invnumber<CR>
set backspace=indent,eol,start


inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
nnoremap H gT
nnoremap L gt


if has("syntax")
  syntax on
endif

set nofoldenable                " disable code folding
let g:DisableAutoPHPFolding = 1 " disable PIV's folding

"transparent colors
autocmd ColorScheme * highlight Normal ctermbg=None
autocmd ColorScheme * highlight NonText ctermbg=None
set background=dark

set t_Co=256
"let g:solarized_termcolors = 256
"let g:solarized_contrast = "high"
"let g:solarized_termtrans = 1
" colorscheme transparent
" colorscheme solarized
"colorscheme molokai
" colorscheme wombat256

hi SpellBad ctermbg=none
hi SpellRare ctermbg=none
hi SpellCap ctermbg=none

if has("autocmd")
filetype plugin indent on
endif

"let g:spf13_no_fastTabs = 1 "Enable L and H for beginning and end of file
set mouse= "disable mouse
set ttymouse= "disable mouse
set nu "Default to absolute line numbers
filetype plugin on
set ofu=syntaxcomplete#Complete


set ignorecase		" Do case insensitive matching
set nogdefault
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching bracketsi
"set smartcase		" Do smart case matching
set incsearch		" Incremental search
set hidden             " Hide buffers when they are abandoned
set wrap
set nolist
"klet g:autoclose_on = 0


function MyManualCompilation()
    silent! call system('!killall pdflatex &>/dev/null')
    silent! call system('!killall xelatex &>/dev/null')
    silent! call system('!killall live-latex-check.sh &>/dev/null')
    silent! call system('!killall live-latex-update.sh &>/dev/null')
    silent update
    if b:Liveupdating == "yes"
        silent! call system("live-latex-check.sh \"" . b:Rootfile . "\" \"" . expand("%") . "\" " . b:MuPDFWindowID . " &>/dev/null &")
    else
        exec "!live-latex-update.sh \"" . b:Rootfile . "\" " . b:MuPDFWindowID 
        "call CheckLiveUpdateStatus()
    endif 
endfunction

autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal softtabstop=4
autocmd FileType go setlocal shiftwidth=4
autocmd FileType go setlocal list
autocmd FileType java let b:jcommenter_class_author='Robert "Legogris" Edström (legogris@legogris.se)'
autocmd FileType java let b:jcommenter_file_author='Robert "Legogris" Edström (legogris@legogris.se)'
autocmd FileType java source /config/vim/macros/jcommenter.vim
autocmd FileType java map <M-c> :call JCommentWriter()<CR>


"set autowrite		" Automatically save before commands like :next and :make

" Configuration file for jcommenter
"
" Copy the necessary contents from this file to your .vimrc, or modify this
" file and add a source command to vimrc to read this file.
"
" The initial settings correspond with Sun's coding conventions.


" map the commenter:
map <C-c> :call JCommentWriter()<CR>
imap <C-c> <esc>:call JCommentWriter()<CR>

" map searching for invalid comments. meta-n for next invalid comment, meta-p
" for previous. "Invalid" in this case means that the "main" comments are missing
" or the tag description is missing. Handy when searching for missing comments
" or when jumping to next tag (no need to use cursor keys (yuck!) or quit insert
" mode).
map <M-n> :call SearchInvalidComment(0)<cr>
imap <M-n> <esc>:call SearchInvalidComment(0)<cr>a
map <M-p> :call SearchInvalidComment(1)<cr>
imap <M-p> <esc>:call SearchInvalidComment(1)<cr>a

" modeline:

" A way to automate the creation of the comments. Works only if the
" class/method declaration is on one row. Comments are generated when the
" beginning '{' is entered, if the proper function/class declaration is found.
" Should work independet of the location of the '{'. Recognizing whether the 
" '{' starts a class/method or something else might fail, and comments might
" be generated for example for an 'if' clause. Has not happened yet, though.
" Uncomment to activate:
" imap <silent> { {<esc>:call search('\w', 'b')<cr>:call ConditionalWriter()<cr>0:call search('{')<cr>a

" a nice trick:
" If you type '}-' and a space/enter/esc, jcommenter will be
" automatically called on the function/class declaration whose end the '}' is:
" iabbrev }- }<esc>h%?\w<cr>:nohl<cr>:call JCommentWriter()<cr>

" Move cursor to the place where inserting comments supposedly should start
let b:jcommenter_move_cursor = 1

" Defines whether to move the cursor to the line which has "/**", or the line
" after that (effective only if b:jcommenter_move_cursor is enabled)
let b:jcommenter_description_starts_from_first_line = 0

" Start insert mode after calling the commenter. Effective only if 
" b:jcommenter_move_cursor is enabled.
let b:jcommenter_autostart_insert_mode = 1

" The number of empty rows (containing only the star) to be added for the 
" description of the method
let b:jcommenter_method_description_space = 2

" The number of empty rows (containing only the star) to be added for the´
" description of the field. Can be also -1, which means that "/**  */" is added
" above the field declaration 
let b:jcommenter_field_description_space = 1

" The number of empty rows (containing only the star) to be added for the 
" description of the class
let b:jcommenter_class_description_space = 2

" If this option is enabled, and a method has no exceptions, parameters or
" return value, the space for the description of that method is allways one
" row. This is handy if you want to keep an empty line between the description
" and the tags, as is defined in Sun's java code conventions
let b:jcommenter_smart_method_description_spacing = 1

" the default content for the author-tag of class-comments. Leave empty to add
" just the empty tag, or outcomment to prevent author tag generation
let b:jcommenter_class_author = ''

" the default content for the version-tag of class-comments. Leave empty to add
" just the empty tag, or outcomment to prevent version tag generation
let b:jcommenter_class_version = ''

" The default author added to the file comments. leave empty to add just the
" field where the autor can be added, or outcomment to remove it.
let b:jcommenter_file_author = ''

" The default copyright holder added to the file comments. leave empty to
" add just the field where the copyright info can be added, or outcomment
" to remove it.
let b:jcommenter_file_copyright = ''

" Change this to true, if you want to use "@exception" instead of "@throws".
let b:jcommenter_use_exception_tag = 0

" set to true if you don't like the automatically added "created"-time
let b:jcommenter_file_noautotime = 0 

" define whether jcommenter tries to parse and update the existing Doc-comments
" on the item it was executed on. If this feature is disabled, a completely new
" comment-template is written
let b:jcommenter_update_comments = 1

" If you want to put some text where the parameter text, return text etc. would
" normally go, uncomment and add the wanted text to these variables (this feature
" is considered "unsupported", which means it will not work perfectly with every
" other aspect of this script. For example, this will break the logic used to
" find "invalid" comments, see mappings above):
"let b:jcommenter_default_param  = ''
"let b:jcommenter_default_return = ''
"let b:jcommenter_default_throw  = ''

" Another "unsupported" feature: define the number of lines added after each
" "tag-group" (except exceptions, which is often the last group). does not work
" well with comment updating currently:
"let b:jcommenter_tag_space = 1


" define wheter jcommenter should remove old tags (eg. if the return value was
" changed from int to void). Will not work for exceptions, since it should not
" remove RuntimeExceptions, and recognizing whether an exception is RTE is very
" hard.
" This feature is not throughly tested, and might delete something it was not
" supposed to, so use with care. Only applicable if 
" b:jcommenter_update_comments is enabled.
let b:jcommenter_remove_tags_on_update = 1

" Whether to prepend an empty line before the generated comment, if the
" line just above the comment would otherwise be non-empty.
let b:jcommenter_add_empty_line = 1

" Uncomment and modify if you're not happy with the default file
" comment-template:
"function! JCommenter_OwnFileComments()
"  call append(0, '/* File name   : ' . bufname("%"))
"  call append(1, ' * authors     : ')
"  call append(2, ' * created     : ' . strftime("%c"))
"  call append(3, ' *')
"  call append(4, ' */')
"endfunction


