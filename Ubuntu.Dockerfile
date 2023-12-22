FROM ubuntu:rolling
WORKDIR /root

RUN apt-get update && apt-get install -y \
	git \
	ripgrep \
	vim \
	make \
	g++ \
	wget \
	zsh \
	python3-pip

#RUN apk add git ripgrep neovim py3-pip make clang wget mandoc man-pages coreutils util-linux zsh lazygit

# Install nvim
RUN apt-get install -y ninja-build gettext cmake
RUN git clone --depth=1 https://github.com/neovim/neovim
# installs to /usr/local/bin, TODO: move to build stage
RUN cd /root/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo all install

# Install Lazgit
RUN export LAZYGIT_VERSION=$(wget -qO- "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
	wget -O lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
RUN tar xf lazygit.tar.gz lazygit
# TODO: move to build stage
RUN install lazygit /usr/local/bin

# Install OMZ
RUN wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

# Install p10k theme, + some external omz plugins
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Install nvm
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash

# Install autojump
# We have to lie that we're already running zsh or it'll refuse
RUN git clone --depth=1 https://github.com/wting/autojump
RUN export SHELL=zsh && cd /root/autojump && ./install.py

# TODO: Move this "cleanup" somewhere else
RUN rm -rv autojump

# Setup the dotfiles
COPY . dotfiles
COPY ./.fetch_on_shell_start.sh .
RUN /root/dotfiles/setup.sh -H

# Tryna give zsh and nvim a bit of a "dry run" so they can setup what they need as part of the build
# not sure if this is proper though, especially for the neovim part
RUN echo exit | script -ec zsh /dev/null
RUN nvim --headless +"q"

# Run zsh
ENTRYPOINT [ "zsh" ]
