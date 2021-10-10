set nocompatible	" Really important option, must be first
set history=50		" remember 50 lines of history
set title			" show a nice title
set showcmd			" display incomplete commands
set showmode		" display which mode we are in
set showmatch		" highlights matching parenthesis/braces
set smartindent		" smart autoindenting
set textwidth=72	" default line length is 72 characters
set ruler			" show line and colum number of the cursor position
set backspace=2		" as backspace=indent,eol,start
set shiftwidth=4	" number of spaces of indentation
set smarttab		" use whitespaces instead of tabs at beginning of line
set softtabstop=4	" number of spaces for tabs when editing
set tabstop=4		" number of spaces that a tab in the file counts for
set modeline		" enable modeline
set modelines=3		" number of lines checked for set commands
set listchars=tab:»\ ,trail:·,nbsp:· " which characters to show when :list is enabled
set backupdir=~/.backup,/tmp	" backup directory
set whichwrap=b,s	" backspace and space keys can move to next/previous line
set viminfo='1000,f1,\"500	" enable writing viminfo files
set noerrorbells	" no sounds or flashing when errors
set autoread		" auto reload files changed outside vim (but not if deleted)
set laststatus=2	" always have statuslines for every window
set encoding=utf-8	" default encoding
set fileencoding=utf-8	" encoding for file in current buffer
set termencoding=utf-8	" encoding used for terminal
set hidden				" hide buffers when not displayed
set pastetoggle=<leader>tp	" switch to paste mode with ,tp
set spelllang=en,it,es,pl	" spell languages (english,italian,spanish,polish)
set formatoptions=tcqw	" some formatting options, see fo-table
set wildmenu			" enable ctrl-n and ctrl-p to scroll through matches
set wildmode=longest,list,full " complete longest common string first, then list alternatives, then full matches
set wildignore=*.sw?,*.bak,*.pyc,*.luac,*.png,*.gif,*.jpg,*.zip,*.jar,*.rar	" ignore those file extensions when Tab completing
set printoptions=header:0,paper:A4,left:0.5in,right:0.5in,top:0.5in,bottom:0.5in " options for hardprinting
set pumheight=20	" number of items to show in popup menu for insert mode completion
set ttyfast			" tell ViM we have a fast terminal
set cryptmethod=blowfish2 	" crypt with blowfish2. Incompatible with Vim 7.3 and earlier
let mapleader=","	" comma as <leader>
set lazyredraw " don't redraw while executing macros (good for performance)
set termguicolors

"persistent undo
set undodir=~/.vim/undodir
set undofile
set undolevels=200		" maximum number of changes that can be undone
set undoreload=1000		" maximum number of lines to save for undo on a buffer reload

" set various tags' files
set tags+=~/.vim/tags/*/tags

" Hexokinase variables
let g:Hexokinase_highlighters = [ 'sign_column' ]
let g:Hexokinase_ftEnabled = ['css', 'html', 'javascript']

if has("autocmd")
	filetype plugin on
	filetype plugin indent on
	" resize splits when the window is resized
	au VimResized * :wincmd =
	" save fold before closing
	au BufWinLeave * mkview
	au BufWinEnter * silent! loadview
endif

" set a color scheme
if &t_Co == 256 || &t_Co == 88
	set t_Co=256		" number of colors in terminal, default=88
	"color ubaryd
	"color laederon
else
	color desert
endif

" switch syntax highlighting on when the terminal has colours and also
" highlights the last search pattern.
if &t_Co > 2 || has("gui_running")
	syntax on
	set hlsearch
	set incsearch
endif

" Templates
augroup Templates
	au BufNewFile *.py 0read ~/.vim/skel/python.skel | normal G
	au BufNewFile *.tex 0r ~/.vim/skel/tex.skel | normal G
	au BufNewFile *.lua 0r ~/.vim/skel/lua.skel | normal G
	au BufNewFile *.asm 0r ~/.vim/skel/assembler.skel | normal G
	au BufNewFile *.go 0r ~/.vim/skel/go.skel | normal G
	au BufNewFile README.md 0r ~/.vim/skel/README.md | normal G
augroup END

"
" --- MAIL ---
"
" A few snippets for emails
let g:MailJobRefusal="While I am sad that I won't get a chance to work
\ for you, it would greatly help me for the future if you could be so kind
\ to tell me where in my experiences and resume I am more lacking so I
\ could concentrate on improving these specific areas. Thank you."
let g:MailFormalBye="Best Regards,\nGianluca Fiore"
if has("autocmd")
	autocmd FileType mail set fo=tcrqw textwidth=72 spell
	autocmd FileType mail call Mail_AutoCmd()
endif
" set mail fileformat for mails, mboxes and news messages
au BufRead,BufNewFile /tmp/mutt-*,~/Maildir/.*,.followup*,.article* :set ft=mail
" various functions for mail and news
function Mail_AutoCmd()
	silent! %s/^\(>*\)\s\+>/\1>/g " wrong quoting
	silent! %s/^> >/>>/ " wrong quoting 2
	silent! %s/  \+/ /g " multiple spaces
	silent! %s/^\s\+$//g " rows with only spaces
	silent! %s/^[>]\+$// " empty quoted rows
endfunction
"
" some mappings
"
" insert the mail snippets as above
noremap <leader>mjob :put=MailJobRefusal
noremap <leader>mbye :put=MailFormalBye
" delete rows with just spaces
noremap <leader>del :%s/^\s\+$//g
" delete empty rows (not even with spaces)
noremap <leader>delempty :%s/^\n//g
" delete empty quoted rows
nnoremap <leader>ceql :%s/^[>]\+$//
nnoremap <leader>cqel :%s/^> \s*$//<CR>^M
vnoremap <leader>ceql :s/^[><C-I> ]\+$//
" delete quoted rows with only spaces
noremap <leader>qesl :%s/^[>]\s\+$//g
" substitute a dot with various spaces with a single dot and 2 spaces
vnoremap <leader>dotsub :s/\.\+ \+/.  /g
" substitute multiple spaces with just one
nnoremap <leader>ksr :%s/  \+/ /g
vnoremap <leader>ksr :s/  \+/ /g
" substitute various consecutive empty rows with just one
noremap <leader>emptyblock :g/^$/<leader>/./-j
" as above but with rows of only spaces
noremap <leader>Sbl :g/^\s*$/<leader>/\S/-j
" regroup multiple Re:
noremap <leader>re :%s/Subject: \(Re\?: \)\+/Subject: Re: /g<CR>
" delete every header
noremap <leader>noheader :0<leader>/^$/d
"
" --- MAIL END ---
"
" --- PROGRAMMING ---

" remove Wordpress tags from a file
noremap <leader>nowordpress :g/^<!--/d
" remove html tags from a file
noremap <leader>notags :%s/<\_.\{-1,\}>//g

if has("autocmd")
	" some options for python files
	autocmd FileType python setlocal textwidth=0
	autocmd FileType python setlocal tabstop=4
	autocmd FileType python setlocal expandtab " spaces instead of tabs
	autocmd FileType python setlocal softtabstop=4 " treat 4 spaces as a tab
	" call pydoc with the name of the python module from which we want
	" help
	:command -nargs=+ Pyhelp :call ShowPydoc("<args>")
	function ShowPydoc(module, ...)
		let fPath = "/tmp/pyHelp_" . a:module . ".pydoc"
		execute ":!pydoc " . a:module . " > " . fPath
		execute ":sp " .fPath
	endfunction
	" folding follow indentation
	autocmd FileType python set foldmethod=indent
	autocmd FileType python set foldlevel=99

	" Show current python class and method name or function name
	" (with <Leader>? or :EchoPythonLocation)
	" based on:
	" http://vim.1045645.n5.nabble.com/editing-Python-files-how-to-keep-track-of-class-membership-td1189290.html
	function! s:get_last_python_class()
		let l:retval = ""
		let l:last_line_declaring_a_class = search('^\s*class', 'bnW')
		let l:last_line_starting_with_a_word_other_than_class = search('^\ \(\<\)\@=\(class\)\@!', 'bnW')
		if l:last_line_starting_with_a_word_other_than_class < l:last_line_declaring_a_class
			let l:nameline = getline(l:last_line_declaring_a_class)
			let l:classend = matchend(l:nameline, '\s*class\s\+')
			let l:classnameend = matchend(l:nameline, '\s*class\s\+[A-Za-z0-9_]\+')
			let l:retval = strpart(l:nameline, l:classend, l:classnameend-l:classend)
		endif
		return l:retval
	endfunction

	function! s:get_last_python_def()
		let l:retval = ""
		let l:last_line_declaring_a_def = search('^\s*def', 'bnW')
		let l:last_line_starting_with_a_word_other_than_def = search('^\ \(\<\)\@=\(def\)\@!', 'bnW')
		if l:last_line_starting_with_a_word_other_than_def < l:last_line_declaring_a_def
			let l:nameline = getline(l:last_line_declaring_a_def)
			let l:defend = matchend(l:nameline, '\s*def\s\+')
			let l:defnameend = matchend(l:nameline, '\s*def\s\+[A-Za-z0-9_]\+')
			let l:retval = strpart(l:nameline, l:defend, l:defnameend-l:defend)
		endif
		return l:retval
	endfunction

	function! s:compose_python_location()
		let l:pyloc = s:get_last_python_class()
		if !empty(pyloc)
			let pyloc = pyloc . "."
		endif
		let pyloc = pyloc . s:get_last_python_def()
		return pyloc
	endfunction

	function! <SID>EchoPythonLocation()
		echo s:compose_python_location()
	endfunction

	command! PythonLocation :call <SID>EchoPythonLocation()
	nnoremap <Leader>? :PythonLocation<CR>

	" Simple re-format for minified Javascript
	" by https://coderwall.com/tapanpandita
	command! UnMinify call UnMinify()
	function! UnMinify()
		%s/{\ze[^\r\n]/{\r/g
		%s/){/) {/g
		%s/};\?\ze[^\r\n]/\0\r/g
		%s/;\ze[^\r\n]/;\r/g
		%s/[^\s]\zs[=&|]\+\ze[^\s]/ \0 /g
		normal ggVG=
	endfunction

	autocmd FileType c setlocal cindent
	autocmd FileType c setlocal noexpandtab
	autocmd FileType c ab #i #include
	autocmd FileType c ab #d #define
	" some options for ruby files
	autocmd FileType ruby setlocal tabstop=2
	autocmd FileType ruby setlocal textwidth=80
	" options for Go files
	autocmd FileType go setlocal textwidth=80
	autocmd FileType go nnoremap <leader>b :!go build %<CR>
	autocmd FileType go nnoremap <leader>r :!go run %<CR>
	"autocmd BufWritePost *.go silent! !ctags -R --quiet=yes &
	autocmd FileType go set makeprg=go\ build\ %
	"" options for markdown files
	autocmd FileType markdown setlocal textwidth=0
	autocmd FileType markdown nnoremap <leader>* i**<Esc>ea**<Esc>
	autocmd FileType markdown nnoremap <leader>_ i_<Esc>ea_<Esc>
	"" options for javascript files
	autocmd FileType javascript setlocal ts=4 sw=4
	"" options for json files
	" Pretty-print current JSON file
	autocmd FileType json nnoremap <leader>jp :!json_pp < %<CR>
	autocmd FileType json setlocal textwidth=0
	" options for java files
	autocmd FileType java setlocal sw=4
	autocmd FileType java setlocal cindent
	autocmd FileType java setlocal foldmethod=marker
	autocmd FileType java setlocal foldmarker={,}
	autocmd FileType java let java_comment_strings=1
	autocmd FileType java let java_highlight_all=1
	autocmd FileType java let java_highlight_debug=1
	autocmd FileType java let java_highlight_java_lang_ids=1
	autocmd FileType java let java_ignore_javadoc=1
	autocmd FileType java let java_highlight_functions=1
	autocmd FileType java let java_mark_braces_in_parens_as_errors=1
	autocmd FileType java let java_minlines=150
	" options for lisp files
	autocmd FileType lisp setlocal expandtab
	autocmd FileType lisp setlocal shiftwidth=2
	autocmd FileType lisp setlocal tabstop=2
	autocmd FileType lisp setlocal softtabstop=2
	" options for haskell files
	autocmd FileType haskell setlocal expandtab tabstop=4 shiftwidth=4 textwidth=79
	" options for html files
	autocmd FileType html setlocal expandtab
	autocmd FileType html setlocal shiftwidth=2
	" options for gopass secret files (this disable saving temp files to
	" not leak any info)
	au BufNewFile,BufRead /dev/shm/gopass.* setlocal noswapfile nobackup noundofile
	" options for css files
	autocmd FileType css :silent HexokinaseToggle	" for Hexokinase
	" options for Svelte files
	autocmd BufNewFile,BufRead *.svelte		setlocal filetype=html
	" options for Git commit messages
	autocmd FileType gitcommit setlocal textwidth=72
	if exists("+omnifunc")
		augroup Omnifunctions
			" enable function-complete for supported files
			autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
			autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
			autocmd FileType lua setlocal omnifunc=luacomplete#Complete
			autocmd FileType java setlocal omnifunc=javacomplete#Complete
			autocmd FileType javascript setlocal omnifunc=javascript#Complete
			autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
			autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
			autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
			autocmd FileType c setlocal omnifunc=ccomplete#Complete
			" use syntax complete if nothing else available
			autocmd FileType * if &omnifunc == "" |
						\	setlocal omnifunc=syntaxcomplete#Complete |
						\	endif
		augroup END
	endif

	augroup filedetection
		" precise filetype settings
		autocmd BufRead,BufNewFile Gemfile,Rakefile,Thorfile,config.ru,Rules,Vagrantfile,Guardfile,Capfile set filetype=Ruby
		autocmd BufRead,BufNewFile *.json set filetype=json
		autocmd BufRead,BufNewFile *tmux.conf* set filetype=tmux
		autocmd BufRead,BufNewFile *.{md,mkd,mdown,markdown} set filetype=markdown
		autocmd BufRead,BufNewFile *.asm setlocal filetype=nasm
	augroup END

	" no tabs in spaces for make files
	autocmd FileType make set noexpandtab shiftwidth=8
	" Max 78 characters for line in text files
	autocmd BufRead *.txt set tw=78
	" No limit of characters for line in csv files
	autocmd BufRead *.csv set tw=0
	" options for YAML files
	autocmd BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
	autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
	" options for TOML files
	autocmd BufNewFile,BufReadPost *.toml set filetype=toml foldmethod=indent
	autocmd FileType toml setlocal ts=4 sts=4 sw=4 expandtab
	" enable Hexokinase plugin for files ending in .theme (supposedly
	" they may contain RGB color codes)
	autocmd BufRead *.theme :silent HexokinaseToggle
	" make every script executable
	autocmd BufWritePost * if getline(1) =~ "^#!/" | silent exe "!chmod u+x <afile>" | endif
	" add vim options at the end of every script (currently not working)
	"autocmd BufWritePost * if getline(1) =~ "^#!/" && if getline($) =~ "^# vi" | silent :$s/^/# vim: set ft=sh tw=0:/ | endif
endif

"
" comments' functions
function! ShellComment()
	noremap - :s/^/#/<CR>
	noremap _ :s/^\s*#\=//<CR>
	set comments=:#
	" trick vim by remapping the comment to 'X' and comment again, so
	" preventing the comment to override the current indentation
	inoremap # X#
endfunction

function! XdefaultsComment()
	noremap - :s/^/!/<CR>
	noremap _ :s/^\s*!\=//<CR>
	set comments=:!
	" trick vim by remapping the comment to 'X' and comment again, so
	" preventing the comment to override the current indentation
	inoremap ! X!
endfunction

function! CComment()
	noremap - :s/^/\/\*/<CR> \| :s/$/ \*\//<CR> \| :nohls<CR>
	noremap _ :s/^\s*\/\* \=//<CR> \| :s/\s*\*\/$//<CR> \| :nohls<CR>
	set comments=sO:*\ -,mO:*\ \ ,exO:*/,s1:/*,mb:*,ex:*/,://
endfunction

function! LuaComment()
	noremap - :s/^/--/ \| :nohls<CR>
	noremap _ :s/^\s*--// \| :nohls<CR>
	set comments=:--
	" trick vim by remapping the comment to 'X' and comment again, so
	" preventing the comment to override the current indentation
	inoremap - X-
endfunction

function! VimComment()
	noremap - :s/^/\"/<CR>
	noremap _ :s/^\s*\"//<CR>
	set comments=:\"
endfunction

function! LispComment()
	noremap - :s/^/\;/<CR>
	noremap _ :s/^\s*\;//<CR>
	set comments=:\;
endfunction

" ...and enabling them
if has("autocmd")
	autocmd FileType perl	call ShellComment()
	autocmd FileType cgi	call ShellComment()
	autocmd FileType sh		call ShellComment()
	autocmd FileType python	call ShellComment()
	autocmd FileType java	call CComment()
	autocmd FileType c,cpp	call CComment()
	autocmd FileType go		call CComment()
	autocmd FileType javascript call CComment()
	autocmd FileType lua	call LuaComment()
	autocmd FileType sql	call LuaComment()
	autocmd FileType haskell call LuaComment()
	autocmd FileType vim	call VimComment()
	autocmd FileType lisp	call LispComment()
	autocmd FileType xdefaults call XdefaultsComment()
endif

" --- PROGRAMMING END ---
"
" --- VARIOUS STUFF ---
"
"  all the text on a single row
noremap <leader>line  :%s/\n/ /g
" save the buffer content in a temporary file with "_Y and import it
" back in another with "_P
nnoremap _Y :!echo ""> /tmp/.vi_tmp<CR><CR>:w! /tmp/.vi_tmp<CR>
vnoremap _Y :w! /tmp/.vi_tmp<CR>
nnoremap _P :r /tmp/.vi_tmp<CR>
" Leader+q removes search hightlights
nnoremap <leader>q :nohls<CR>
" Ctrl+hjkl to navigate in insert mode
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
inoremap <C-h> <Left>

" Add parentheses around current word; use it from the beginning
" of the word
nnoremap <leader>( i(<Esc>ea)<Esc>

" command line abbreviations
cabbrev Wq wq

" paste the content of clipboard on a new line, leave a empty line after
" it and return in normal mode
nnoremap <leader>u o<Esc>"*p<Esc>o<Esc>
" same as above but without a trailing new line
nnoremap <leader>U o<Esc>"*p<Esc>

" uppercase current word and return to insert mode
inoremap <c-u> <Esc>viwUi
"
" two , in insert mode to exit insertion instead of Esc
inoremap ,, <Esc>
" modify the colors of not found dictionary words highlighting because
" sometimes changing terminal colors make them unreadable
" other similar options are: SpellCap SpellRare and SpellLocal
hi SpellBad term=reverse ctermfg=white ctermbg=darkred guifg=#FFFFFF guibg=#7F0000 gui=underline

" Aspell checking
map <leader>ss :setlocal spell!<CR>
noremap <leader>I :w!<CR>:!aspell -d it -x check %<CR>:e! %<CR>
noremap <leader>E :w!<CR>:!aspell -d en -x check %<CR>:e! %<CR>

" Vim-Airline
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif
let g:airline_left_sep='»'
let g:airline_left_sep='▶'
let g:airline_right_sep='«'
let g:airline_right_sep='◀'
let g:airline_symbols.linenr = 'ƪ'
let g:airline_symbols.linenr = 'ƚ'
let g:airline_symbols.linenr = 'Ł'
let g:airline_symbols.branch='↝'
let g:airline_symbols.paste = 'Ⴜ'
let g:airline_symbols.paste = 'ᵽ'
let g:airline_symbols.paste = 'Ƥ'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.readonly = ''
let g:airline_theme='laederon'

" open link in the current row in the browser
function! Browser ()
	let line0 = getline (".")
	let line = matchstr (line0, "http[^ ]*")
	:if line==""
	let line = matchstr (line0, "ftp[^ ]*")
	:endif
	:if line==""
	let line = matchstr (line0, "file[^ ]*")
	:endif
	let line = escape (line, "#=?&;|%")
	if line==""
		let line = "\"" . (expand("%:p")) . "\""
		:endif
		exec ':silent !firefox ' . line
	endfunction

	noremap ,w :call Browser ()<CR>
