""" useful to have a base to build on
" +Cheap hack to make this work with neovim too, will fix later
so $VIMRUNTIME/../../vim/vim90/defaults.vim

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

""" extra
set sc
set confirm

" colors:
set tgc

" highlight current line no.
" looks kinda ugly in vim for now tho
if has("nvim")
	set cul
	set culopt=number
end

