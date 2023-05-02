""" useful to have a base to build on
""" I don't source this in neovim tho
if !has('nvim')
	so $VIMRUNTIME/defaults.vim
endif

""" must have
" line numbers
set nu

" useful mouse modes, not all imo
set mouse=nv

" no annoying bells
set vb t_vb=

""" useful
" auto-indentation stuff
set ai
set si

" F12 toggles paste mode
set pastetoggle=<F12>

""" extra
set sc
set confirm

