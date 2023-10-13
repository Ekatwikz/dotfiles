FROM alpine:edge
WORKDIR /root

# Prereqs + useful packages
RUN apk add git ripgrep neovim py3-pip make clang wget mandoc man-pages coreutils util-linux zsh

# Install OMZ
RUN sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Setup the dotfiles
COPY . dotfiles
RUN /root/dotfiles/setup.sh

# Install p10k theme, + some external omz plugins
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install nvm, it's so cursed that this requires specifically bash tho
RUN apk add bash
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# Install autojump
# We have to lie that we're already running zsh or it'll refuse
RUN git clone --depth=1 https://github.com/wting/autojump
RUN export SHELL=zsh && cd /root/autojump && ./install.py

# Cleanup... ?
# I'm not sure if I should do stuff like this, don't know Docker best practices
RUN apk del bash
RUN rm -rf autojump

# Run zsh
ENTRYPOINT [ "zsh" ]
