""" useful to have a base to build on
" +Cheap hack to make this work with neovim too, will fix later
if has("nvim")
	so ~/.vimdefaults.vim
else
	so $VIMRUNTIME/defaults.vim
end

""" must have
" line numbers
set nu

" useful mouse modes, not all imo
set mouse=nv

" no annoying bells
set vb t_vb=

""" useful
" indentation stuff
set ai
set si
set bri

" F12 toggles paste mode
set pt=<F12>

" case insensitivity for ez searches (unless \C, see :h /ignorecase)
set ic
set scs

" goofy ahh search highlight shouldn't hang around
set nohls

" make jumping through wrapped lines more comfortable
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

""" extra
set sc
set confirm

" 24-bit colors if not in tty:
if $TERM != 'linux'
	set tgc
end

" highlight current line no.
" looks kinda ugly in vim for now tho
if has("nvim")
	set cul
	set culopt=number
end

""" Stuff I yoinked from Prime's config
" "select-and-move" (mad epic I do say)
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" some clipboard stuff
" not sure if I should check for clipboard like this
if has("clipboard")
	nnoremap <leader>y "+y
	nnoremap <leader>Y "+Y
	vnoremap <leader>y "+y

	nnoremap <leader>d "_d
	vnoremap <leader>d "_d

	" + a dangerous experiment of my own,
	" not sure if I should keep this at all
	set clipboard+=unnamedplus
end

