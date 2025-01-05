FROM ubuntu:rolling

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
	zsh \
	git \
	ripgrep \
	vim \
	make \
	g++ \
	wget \
	python3-pip \
	file \
	sudo \
	&& apt-get clean

# https://docs.docker.com/reference/dockerfile/#user
# https://github.com/moby/moby/issues/5419#issuecomment-41478290
RUN groupadd -r dotsuser \
	&& useradd -s /usr/bin/zsh -lrm -g dotsuser -G sudo dotsuser \
	&& echo dotsuser:. | chpasswd

ENV HOME=/home/dotsuser
WORKDIR /home/dotsuser/.src

# nvim (installs to "/usr/local/bin"?)
# TODO: clean me, idk
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	ninja-build \
	gettext \
	cmake \
	&& apt-get clean \
	&& git clone --depth=1 https://github.com/neovim/neovim \
	&& cd neovim \
	&& make CMAKE_BUILD_TYPE=RelWithDebInfo all install \
	&& make distclean

# Lazygit
RUN LAZYGIT_VERSION=$(wget -qO- "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') \
	&& wget -O lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
	&& tar xf lazygit.tar.gz lazygit \
	&& install -v lazygit /usr/local/bin

# Yazi (NB: depends on file)
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	unzip \
	&& apt-get clean \
	&& wget https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip \
	&& unzip yazi-x86_64-unknown-linux-gnu.zip yazi-x86_64-unknown-linux-gnu/yazi yazi-x86_64-unknown-linux-gnu/ya \
	&& cd yazi-x86_64-unknown-linux-gnu \
	&& install -v yazi ya /usr/local/bin

# delta
RUN DELTA_VERSION_LATEST=$(wget -qO- "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*') \
	&& wget -O git-delta_amd64.deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_${DELTA_VERSION_LATEST}_amd64.deb" \
	&& dpkg -i git-delta_amd64.deb

# Yuck.
RUN chown -Rv dotsuser:dotsuser "${HOME}"
USER dotsuser

# OMZ
RUN wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh

# p10k theme, + some external omz plugins
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
RUN git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
RUN git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# nvm
RUN NVM_VERSION_LATEST=$(wget -qO- "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep -Po '"tag_name": "\K[^"]*') \
	&& wget -qO- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION_LATEST}/install.sh" | bash

# autojump
# We have to lie that we're already running zsh or it'll refuse
RUN git clone --depth=1 https://github.com/wting/autojump \
	&& cd autojump \
	&& SHELL=zsh ./install.py

# Zoxide
RUN wget -qO- https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# Setup the dotfiles
WORKDIR /home/dotsuser
COPY --chown=dotsuser:dotsuser . dotfiles
COPY --chown=dotsuser:dotsuser ./.fetch_on_shell_start.sh .
RUN ${HOME}/dotfiles/setup.sh -Hn
# might wanna try and be smarter about this later on:
RUN cat ${HOME}/dotfiles/.includes.gitconfig >> ${HOME}/.gitconfig

# Tryna give zsh and nvim a bit of a "dry run" so they can setup what they need as part of the build
# not sure if this is proper though, especially for the neovim part
RUN echo exit | script -ec zsh /dev/null
RUN nvim --headless +"q"

ENV COLORTERM=truecolor

# Run zsh
ENTRYPOINT [ "zsh" ]

