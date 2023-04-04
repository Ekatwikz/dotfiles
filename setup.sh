#!/usr/bin/env sh

main () {
	printf "Hard link? (y) Copy? (n)" 
	read -r SETUPMETHODCHOICE
	case $SETUPMETHODCHOICE in
		[Yy]* ) SETUPMETHOD="ln" ;;
		[Nn]* ) SETUPMETHOD="cp" ;;
		* ) SETUPMETHOD="ln" && printf "\nDefaulted to [y]es" ;;
	esac

	echo

	# Link/Copy config files to user home
	$SETUPMETHOD -iv .inputrc .vimrc .tmux.conf .p10k.zsh .zshrc .nvmrc .bashrc ~
}

main "$@"

