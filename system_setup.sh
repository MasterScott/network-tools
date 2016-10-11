#!/bin/bash

up() {
    sudo apt-get update
    sudo apt-get -y upgrade
}

create_workspace() {
    mkdir -p ~/workspace
}

get_config_repo() {
    create_workspace
    git clone https://www.github.com/dimkarakostas/config ~/workspace/config
}

set_git() {
    if [ ! -d ~/workspace/config ]; then
        get_config_repo
    fi
    sudo apt-get -y install git
    git config --global user.name "Dimitris Karakostas"
    git config --global user.email "dimit.karakostas@gmail.com"
    cp ~/workspace/config/.gitconfig ~
}

set_zsh() {
    if [ ! -d ~/workspace/config ]; then
        get_config_repo
    fi
    sudo apt-get -y install zsh
    sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    cp -r ~/workspace/config/.zshrc ~/workspace/config/.zshrc.pre-oh-my-zsh ~/workspace/config/.zsh ~
}

set_vim() {
    if [ ! -d ~/workspace/config ]; then
        get_config_repo
    fi
    sudo apt-get -y install vim
    cp -r ~/workspace/config/.vim ~/workspace/config/.vimrc ~
    sudo apt-get -y install python-pip
    sudo pip install flake8
}

set_gpg() {
    if [ ! -d ~/workspace/config ]; then
        get_config_repo
    fi
    cp ~/workspace/config/.gnupg ~
    gpg --recv-keys A339D2E9
}

install_homebrew() {
    sudo apt-get install -y build-essential make cmake scons curl ruby autoconf automake autoconf-archive gettext libtool flex bison libbz2-dev libcurl4-openssl-dev libexpat-dev libncurses-dev
    git clone https://github.com/Homebrew/linuxbrew.git ~/.linuxbrew
}

set_hub() {
    install_homebrew
    brew install hub
}

set_basic_tools() {
    sudo apt-get -y install htop byobu
    set_git
    set_zsh
    set_vim
    set_gpg
}

set_extended_tools() {
    sudo apt-get -y install pdf-presenter-console
    set_hub
}

up
set_basic_tools
set_extended_tools
