#!/usr/bin/env sh

# -H to hardlink instead of copy
# -n to disallow downloads
USAGE="Usage: $0 { [-H] [-n] | -h }"

SETUPMETHOD="cp"
CANDOWNLOAD=1

main () {
	# Link/Copy config files to user home
	$SETUPMETHOD -fv .inputrc .vimrc .tmux.conf .p10k.zsh .zshrc .nvmrc .bashrc ~

	# TODO: download p10k recommended font?

	# Link/Copy alacritty config
	mkdir -pv ~/.config/alacritty
	$SETUPMETHOD -fv ./.config/alacritty/alacritty.yml ~/.config/alacritty/

	# Set up packer for neovim
	[ $CANDOWNLOAD -ne 0 ] && [ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ] && \
		git clone --depth 1 https://github.com/wbthomason/packer.nvim \
		~/.local/share/nvim/site/pack/packer/start/packer.nvim

	# Symlink Nvim config, too lazy to continue the usual hard/cp thingy rn
	ln -sfv "$(realpath .config/nvim)" ~/.config

	# Download dracula theme for alacritty
	[ $CANDOWNLOAD -ne 0 ] && [ ! -d ~/.config/alacritty/alacritty-dracula ] && \
		git clone https://github.com/dracula/alacritty \
		~/.config/alacritty/alacritty-dracula
}

check_opts() {
	while getopts ":Hnh" opt; do
		case "${opt}" in
			H)
				SETUPMETHOD="ln" ;;
			n)
				CANDOWNLOAD=0 ;;
			h)
				printf "%s\n" "$USAGE" && exit ;;
			*)
				err_msg "$USAGE" ;;
		esac
	done
	shift $((OPTIND-1))

	[ $CANDOWNLOAD -eq 0 ] || command -v git >/dev/null \
		|| err_msg "No git??"

	main "$@"
}

err_msg() {
    printf "%s\n" "$1" >&2
    exit 1
}

check_opts "$@"

