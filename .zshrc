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
[ -d "/usr/local/texlive/2022/bin/x86_64-linux" ]\
    && PATH="/usr/local/texlive/2022/bin/x86_64-linux:$PATH"

# TODO?
#/usr/local/texlive/2022/texmf-dist/doc/man to MANPATH
#/usr/local/texlive/2022/texmf-dist/doc/info to INFOPATH

# Nvidia stuff
[ -d "/usr/local/cuda-12.0/bin" ]\
    && PATH="/usr/local/cuda-12.0/bin${PATH:+:${PATH}}"

# TODO: use this cool syntax everywhere else too?
[ -d "/usr/local/cuda-12.0/lib64" ]\
    && LD_LIBRARY_PATH="/usr/local/cuda-12.0/lib64\
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

# Autojump
[ -f /usr/share/autojump/autojump.sh ]\
    && . /usr/share/autojump/autojump.sh

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]]\
    || source ~/.p10k.zsh

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

