# Fetch if there's some fetch script
# See: https://github.com/romkatv/powerlevel10k/issues/1883
[ ! -f "$HOME/.fetch_on_shell_start.sh" ] \
    || { typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet \
    && $HOME/.fetch_on_shell_start.sh }

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# p10k renders wayyy to goofy in a tty
if [[ $TERM == "linux" ]]; then
    ZSH_THEME="gnzh"
else
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
    git
    zsh-autosuggestions
    gh
    colored-man-pages
    node
    npm
    command-not-found
    aliases
    colorize
    jfrog

    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Add deno completions to search path
if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then export FPATH="$HOME/.zsh/completions:$FPATH"; fi
[ ! -f "$HOME/.deno/env" ] || \
    . "$HOME/.deno/env"

### User configuration:

# set PATH so it includes texlive path if it exists
[ -d "/usr/local/texlive/2022/bin/x86_64-linux" ]\
    && PATH="/usr/local/texlive/2022/bin/x86_64-linux:$PATH"

# TODO?
#/usr/local/texlive/2022/texmf-dist/doc/man to MANPATH
#/usr/local/texlive/2022/texmf-dist/doc/info to INFOPATH

# LocalBin; this wasn't already on PATH??
# Hopefully that's just random and it wasn't for a good reason
# that I'll find out the hard way...
[ -d "$HOME/.local/bin" ]\
    && PATH="$HOME/.local/bin${PATH:+:${PATH}}"

# Nvidia stuff
[ -d "/usr/local/cuda-12.3/bin" ]\
    && PATH="/usr/local/cuda-12.3/bin${PATH:+:${PATH}}"

# TODO: use this cool syntax everywhere else too?
[ -d "/usr/local/cuda-12.3/lib64" ]\
    && LD_LIBRARY_PATH="/usr/local/cuda-12.3/lib64\
        ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"

# Android stuff
[ -d "$HOME/Android/Sdk/emulator" ]\
    && PATH="$HOME/Android/Sdk/emulator:$PATH"

# Rust stuff
[ -d "$HOME/.cargo/bin" ]\
    && PATH="$HOME/.cargo/bin:$PATH"

# TODO: less specific?
[ -d "$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/man" ]\
    && export MANPATH="$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/man:${MANPATH:-`manpath`}"

# Go > Python xdd
command -v chroma 1> /dev/null\
    && export ZSH_COLORIZE_TOOL="chroma"

# Autojump, first one is the old one or something, idk
[ -f /usr/share/autojump/autojump.sh ]\
    && . /usr/share/autojump/autojump.sh
[[ -s /root/.autojump/etc/profile.d/autojump.sh ]]\
    && source /root/.autojump/etc/profile.d/autojump.sh

# idk, could be useful?
[ -z $PKG_CONFIG_PATH ] && [ -d "/usr/lib/x86_64-linux-gnu/pkgconfig" ]\
    && export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig

# for alacritty maybe? idk
[ -d ${ZDOTDIR:-~}/.zsh_functions ]\
    && fpath+=${ZDOTDIR:-~}/.zsh_functions

# laaaaaaaazy
(command -v lazygit && ! command -v lg) 1> /dev/null\
    && alias lg=lazygit
(command -v lazydocker && ! command -v lzd) 1> /dev/null\
    && alias lzd=lazydocker

# Neovim!
(command -v nvim && ! command -v nv) 1> /dev/null\
    && alias nv=nvim

# Neovim as editor?
export EDITOR=nvim

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]]\
    || source ~/.p10k.zsh

# GHC!
[ ! -f "$HOME/.ghcup/env" ] \
    || source "$HOME/.ghcup/env" # ghcup-env

# Databricks CLI
command -v databricks 1> /dev/null\
    && . <(databricks completion zsh)

# nnn autocd thingy, don't bother if it's not installed or whatever
(command -v nnn && ! command -v n) 1> /dev/null && \
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
    command nnn "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    }
}

# My beginner nnn plugins
# https://github.com/jarun/nnn/tree/master/plugins#list-of-plugins
export NNN_PLUG='j:autojump;o:fzopen'

# Dracula Theme for nnn
BLK="E4" CHR="E4" DIR="8D" EXE="54" REG="00" HARDLINK="00" SYMLINK="75" MISSING="00" ORPHAN="CB" FIFO="E4" SOCK="D4" OTHER="8D"
export NNN_FCOLORS="$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"

### Semi-auto setups:
# (ie: stuff that was generated by various programs)

# Conda
__conda_setup="$($HOME'/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup

# Miniconda
__miniconda_setup="$($HOME'/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__miniconda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __miniconda_setup

# NVM stuff
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# TODO: add quiet mode here?
autoload -U add-zsh-hook
load-nvmrc() {
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install 1>/dev/null
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use 1>/dev/null
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    #echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc


# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

