#!/bin/bash

# This script installs/updates my dotfiles.

# Clone the repo
git clone --recurse-submodules https://github.com/some-natalie/dotfiles.git ~/.dotfiles

# Install .bashrc
mv -f ~/.dotfiles/.bashrc ~/.bashrc

# Install git configs
if [ ! -e ~/.git ]; then
  mkdir -p ~/.git
fi
mv -f ~/.dotfiles/.gitconfig ~/.gitconfig
mv -f ~/.dotfiles/.gitignore_global ~/.gitignore_global

# Install vim files
mv -f ~/.dotfiles/.vimrc ~/.vimrc
if [ ! -e ~/.vim_runtime ]; then
  mkdir -p ~/.vim_runtime
fi
cp -rf ~/.dotfiles/vimrc/* ~/.vim_runtime

# Install nano files
mv -f ~/.dotfiles/nanorc/nanorc ~/.nanorc
if [ ! -e ~/.nano ]; then
  mkdir -p ~/.nano
fi
cp -rf ~/.dotfiles/nanorc/* ~/.nano

# Remove the remainder of the repo
rm -rf ~/.dotfiles

# Done now
echo "Done"
