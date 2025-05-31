#!/bin/bash

# install yay
cd /tmp
git clone https://aur.archlinux.org/yay-git.git
cd yay-git/;makepkg -si --noconfirm

# import 1password's signing key, required for yay install to work
curl -sS https://downloads.1password.com/linux/keys/1password.asc | sudo gpg --import

# install extra packages
yay -Syu --noconfirm - < /tmp/arch-installer/aur-packages.txt

mkdir --parents /files/code/personal
cd /files/code/personal
repos=( "dmenu" "dwm" "dwmblocks" )
for repo in ${repos[@]}
do
    git clone https://github.com/samiramer/$repo.git
    cd /files/code/personal/$repo;make;sudo make clean install;cd /files/code/personal
    sleep 1
done

# install dot files
git clone https://github.com/samiramer/dot-files.git /files/code/personal/dot-files
cd /files/code/personal/dot-files
stow -t /home/samer alacritty fontconfig gitconfig scripts tmux ssh xinit zsh

# install Neovim config
git clone https://github.com/samiramer/neovim-config /files/code/personal/neovim-config
ln -s /files/code/personal/neovim-config /home/samer/.config/nvim

# install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm /home/samer/.tmux/plugins/tpm

# install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
