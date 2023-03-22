#!/bin/bash
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV HOME=/root

RUN apt-get -qq -y update
RUN apt-get -qq -y update --fix-missing
RUN apt-get -qq -y install curl
RUN apt-get -qq -y update
RUN apt-get -qq -y install git
RUN apt-get -qq -y install apt-file 
RUN apt-file update
RUN apt-get -qq -y install vim 
RUN apt-get -qq -y install apt-utils 
RUN apt-get -qq -y install curl git gcc 
RUN apt-get -qq -y update

RUN apt-get -qq -y install aptitude

RUN aptitude -y install build-essential
RUN aptitude -y install ruby
RUN curl -sL https://deb.nodesource.com/setup_16.x -o /tmp/nodesource_setup.sh
RUN bash /tmp/nodesource_setup.sh



# use your creds
RUN git config --global user.email "bcda0276@gmail.com"
RUN git config --global user.name "arnos-stuff"

RUN echo "#! /bin/bash\n\nshopt \$*\n" > /usr/local/bin/shopt
RUN chmod +x /usr/local/bin/shopt
RUN ln -s /usr/local/bin/shopt /usr/bin/shopt
RUN echo "alias shopt='/usr/bin/shopt'" >> ~/.zshrc


# install zsh & zi
RUN aptitude -y install zsh 
RUN /bin/bash -c "$(curl -fsSL git.io/get-zi)" -- -a annex

RUN aptitude -y install --without-recommends tzdata

# install brew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null

RUN echo '# Set PATH, MANPATH, etc., for Homebrew.' >> $HOME/.profile \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.profile \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.zshrc \
    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> $HOME/.bashrc \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
    echo 'export $PATH=$PATH:/home/linuxbrew/.linuxbrew/bin/brew' >> $HOME/.bashrc 

ENV PATH=$PATH:/home/linuxbrew/.linuxbrew/bin
RUN /bin/bash -c "source $HOME/.bashrc"
RUN /bin/bash -c "source $HOME/.profile"


RUN brew install z
RUN brew install gcc
RUN brew install jandedobbeleer/oh-my-posh/oh-my-posh
RUN brew install gh


ENV HOMEBREW=/home/linuxbrew/.linuxbrew

RUN curl https://cdn.jsdelivr.net/gh/arnos-stuff/vm-setup@latest/.js.zshrc >> $HOME/.zshrc
RUN curl https://cdn.jsdelivr.net/gh/arnos-stuff/vm-setup@latest/.ref.zshenv >> $HOME/.zshenv
RUN curl https://cdn.jsdelivr.net/gh/arnos-stuff/vm-setup@latest/arno-pure-bayes.omp.json >> arno-pure-bayes.omp.json

RUN echo ". /home/linuxbrew/.linuxbrew/etc/profile.d/z.sh" >> $HOME/.zshrc

RUN aptitude -y update

ENV BREW_HOME=/home/linuxbrew/.linuxbrew/opt

# micro editor with plugins
RUN brew install micro
RUN mkdir -p $HOME/.config/micro/plugins
RUN mkdir -p $HOME/.config/micro/colorschemes
RUN curl https://cdn.jsdelivr.net/gh/arnos-stuff/vm-setup@latest/micro/settings.json >> $HOME/.config/micro/settings.json
RUN curl https://cdn.jsdelivr.net/gh/arnos-stuff/vm-setup@latest/micro/colorschemes/arno-pure.micro >> $HOME/.config/micro/colorschemes/arno-pure.micro

RUN micro -plugin install goyo \
    micro -plugin install colorscheme \
    micro -plugin install nordcolors \
    micro -plugin install autofmt \
    micro -plugin install misspell \
    micro -plugin install filemanager

RUN mkdir -p $HOME/.config/micro/colorschemes
RUN mkdir -p $BREW_HOME/oh-my-posh/themes/
RUN eval "cp arno-pure-bayes.omp.json $BREW_HOME/oh-my-posh/themes/arno-pure.omp.json"

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

RUN echo 'export NVM_DIR="$HOME/.nvm"' >> $HOME/.zshrc
RUN echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm' >> $HOME/.zshrc
RUN echo '[ -s "$NVM_DIR/zsh_completion" ] && \. "$NVM_DIR/zsh_completion"' >> $HOME/.zshrc # This loads nvm bash_completion

RUN aptitude -y update
RUN aptitude -y install nodejs
RUN aptitude -y install npm

RUN npm install -g yarn
RUN npm install -g typescript
RUN npm install -g ts-node
RUN npm install -g @feathersjs/cli

RUN (echo; echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"') >> /root/.zprofile
RUN eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

RUN echo "source ~/.zi/bin/zi.zsh" >> $HOME/.zshrc \
    echo "source ~/.zi/bin/zi.zsh" >> $HOME/.zshenv \
    echo "source ~/.zi/bin/zi.zsh" >> $HOME/.bashrc \
    echo "source ~/.zi/bin/zi.zsh" >> $HOME/.profile

RUN chsh -s /bin/zsh
RUN exec zsh
RUN eval "oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/arno-pure.omp.json" >> $HOME/.zshrc
RUN eval "oh-my-posh init zsh --config $(brew --prefix oh-my-posh)/themes/arno-pure.omp.json" >> $HOME/.bashrc

RUN npm install -g d3 danfojs
RUN npm install -g @google-cloud/storage

ENTRYPOINT [ "/bin/zsh" ]