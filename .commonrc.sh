source_if_exists() {
    [ ! -f "$1" ] \
        || . "$1"
}

add_to_path() {
    [ ! -d "$1" ] \
        || PATH="$1${PATH:+:${PATH}}"
}

add_to_ld_lib_path() {
    [ ! -d "$1" ] \
        || LD_LIBRARY_PATH="$1${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
}

add_to_path "/usr/local/texlive/2022/bin/x86_64-linux"

# LocalBin; this wasn't already on PATH??
# Hopefully that's just random and it wasn't for a good reason
# that I'll find out the hard way...
add_to_path "$HOME/.local/bin"

# Nvidia stuff
add_to_path "/usr/local/cuda-12/bin"
add_to_ld_lib_path "/usr/local/cuda-12/lib64"

# Android stuff
add_to_path "$HOME/Android/Sdk/emulator" 

# Rust stuff
add_to_path "$HOME/.cargo/bin:$PATH"

# TODO: less specific?
[ ! -d "$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/man" ]\
	|| export MANPATH="$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/man:${MANPATH:-$(manpath)}"

# GHC!
source_if_exists "$HOME/.ghcup/env"

# Go
add_to_path "/usr/local/go/bin"

# idk, could be useful?
{ [ -n "$PKG_CONFIG_PATH" ] || [ ! -d "/usr/lib/x86_64-linux-gnu/pkgconfig" ] ; } \
    || export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig

# laaaaaaaazy
{ ! command -v lazygit || command -v lg ; } 1> /dev/null\
    || alias lg=lazygit
{ ! command -v lazydocker || command -v lzd ; } 1> /dev/null\
    || alias lzd=lazydocker

# Neovim!
{ ! command -v nvim || command -v nv ; } 1> /dev/null \
    || { alias nv=nvim && export EDITOR=nvim ; }

# nnn autocd thingy, don't bother if it's not installed or whatever
# Also turn off the goofy auto-enter thing
{ ! command -v nnn || command -v n ; } 1> /dev/null || \
n () {
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The command builtin allows one to alias nnn to n, if desired, without
    # making an infinitely recursive alias
    command nnn -A "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    }
}

# My beginner nnn plugins
# https://github.com/jarun/nnn/tree/master/plugins#list-of-plugins
export NNN_PLUG='j:autojump;o:fzopen;d:dragdrop'

# Dracula Theme for nnn
BLK="E4" CHR="E4" DIR="8D" EXE="54" REG="00" HARDLINK="00" SYMLINK="75" MISSING="00" ORPHAN="CB" FIFO="E4" SOCK="D4" OTHER="8D"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

# TODO: clean up this wget_and_... stuff?

command -v wget_and_dpkg_install 1> /dev/null ||
wget_and_dpkg_install() {
        [ -n "$1" ] \
            || { echo 'URL??' && return 1 ; }

        TMP_PACKAGE="$(mktemp)" \
        && wget -O "$TMP_PACKAGE" "$1" \
        && sudo dpkg -i "$TMP_PACKAGE"

        RET=$?
        rm -fv "$TMP_PACKAGE"
        return $RET
}

command -v wget_and_untar 1> /dev/null ||
wget_and_untar() {
        [ -n "$1" ] \
            || { echo 'URL??' && return 1 ; }

        TMP_PACKAGE="$(mktemp)" \
        && wget -O "$TMP_PACKAGE" "$1" \
        && FILENAME_WITH_EXT="${1##*/}" \
        BASE_FILENAME="${FILENAME_WITH_EXT%.tar.gz}"
        mkdir -v "$BASE_FILENAME" \
        && tar -C "$BASE_FILENAME" -xvf "$TMP_PACKAGE"

        RET=$?
        rm -fv "$TMP_PACKAGE"
        [ $RET -eq 0 ] || rm -rfv "$BASE_FILENAME"
        return $RET
}

command -v wget_and_unzip 1> /dev/null ||
wget_and_unzip() {
        [ -n "$1" ] \
            || { echo 'URL??' && return 1 ; }

        TMP_PACKAGE="$(mktemp)" \
        && wget -O "$TMP_PACKAGE" "$1"

        FILENAME_WITH_EXT="${1##*/}"
        BASE_FILENAME="${FILENAME_WITH_EXT%.zip}"
        mkdir -v "$BASE_FILENAME" \
        && unzip "$TMP_PACKAGE" -d "$BASE_FILENAME"

        RET=$?
        rm -fv "$TMP_PACKAGE"
        [ $RET -eq 0 ] || rm -rfv "$BASE_FILENAME"
        return $RET
}

