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

# User configuration

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

# Go > Python xdd
! command -v chroma &> /dev/null || export ZSH_COLORIZE_TOOL="chroma"

# Autojump
. /usr/share/autojump/autojump.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# slightly edited conda init, might be bad idea xdd?
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
