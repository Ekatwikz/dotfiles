# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

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

    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

### User configuration:

# set PATH so it includes texlive path if it exists
if [ -d "/usr/local/texlive/2022/bin/x86_64-linux" ] ; then
    PATH="/usr/local/texlive/2022/bin/x86_64-linux:$PATH"
fi

# TODO?
#/usr/local/texlive/2022/texmf-dist/doc/man to MANPATH
#/usr/local/texlive/2022/texmf-dist/doc/info to INFOPATH

# Nvidia stuff
if [ -d "/usr/local/cuda-12.0/bin" ] ; then
    PATH="/usr/local/cuda-12.0/bin${PATH:+:${PATH}}"
fi

# TODO: use this cool syntax everywhere else too?
if [ -d "/usr/local/cuda-12.0/lib64" ] ; then
    LD_LIBRARY_PATH="/usr/local/cuda-12.0/lib64\
        ${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
fi

# Android stuff
if [ -d "$HOME/Android/Sdk/emulator" ] ; then
    PATH="$HOME/Android/Sdk/emulator:$PATH"
fi

# Rust stuff
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

# TODO: less specific?
if [ -d "$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/man" ] ; then
    export MANPATH="$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/share/man:${MANPATH:-`manpath`}"
fi

# Buildroot stuff
if [ -d "$HOME/buildroot/output/host/bin" ] ; then
    PATH="$HOME/buildroot/output/host/bin:$PATH"
fi

# Go > Python xdd
! command -v chroma &> /dev/null || export ZSH_COLORIZE_TOOL="chroma"

# Autojump
if [ -f /usr/share/autojump/autojump.sh ] ; then
    . /usr/share/autojump/autojump.sh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# idk, could be useful?
if [ -z $PKG_CONFIG_PATH ] && [ -d "/usr/lib/x86_64-linux-gnu/pkgconfig" ] ; then
    export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig
fi

# for alacritty maybe? idk
if [ -d ${ZDOTDIR:-~}/.zsh_functions ] ; then
    fpath+=${ZDOTDIR:-~}/.zsh_functions
fi

### Semi-auto setups:

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
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use 1>/dev/null
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc
