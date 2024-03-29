#!/bin/bash

setup-files() {
  echo "----- setup files -----"
  git clone --depth=1 https://github.com/some-natalie/dotfiles.git ~/.dotfiles
  mv ~/.dotfiles/git/.gitconfig_codespaces ~/.gitconfig
  mv ~/.dotfiles/git/.gitignore_global ~/.gitignore_global
}

setup-bash() {
  echo "----- setup bash -----"
  git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it
  bash ~/.bash_it/install.sh -s
  sed -i 's/bobby/powerline-plain/g' ~/.bashrc
  mv ~/.dotfiles/bash-it/aliases.bash ~/.bash_it/aliases/custom.aliases.bash
  mv ~/.dotfiles/bash-it/functions.bash ~/.bash_it/lib/custom.bash
  bash-it update
  bash-it enable alias curl docker git
}

setup-vim() {
  echo "----- setup vim -----"
  git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
  bash ~/.vim_runtime/install_awesome_vimrc.sh
}

setup-files
setup-bash
setup-vim

rm -rf ~/.dotfiles
