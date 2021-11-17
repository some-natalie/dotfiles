#!/bin/bash

setup-files() {
  echo "----- setup files -----"
  git clone --depth=1 https://github.com/some-natalie/dotfiles.git ~/.dotfiles
  mv ~/.dotfiles/.gitconfig ~/.gitconfig
  mv ~/.dotfiles/.gitignore_global ~/.gitignore_global
  mv ~/.dotfiles/.mongorc.js ~/.mongorc.js
}

setup-bash() {
  echo "----- setup bash -----"
  git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
  ~/.bash_it/install.sh
}

setup-vim() {
  echo "----- setup vim -----"
  git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
  ~/.vim_runtime/install_awesome_vimrc.sh
}

setup-files
setup-bash
setup-vim
