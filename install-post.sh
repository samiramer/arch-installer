#!/bin/bash

# install extra packages
yay -Syu --noconfirm - < /tmp/arch-installer/aur-packages.txt

cd $CODEDIR
repos=( "dmenu" "dwm" "dwmblocks" )
for repo in ${repos[@]}
do
    git clone https://github.com/samiramer/$repo.git
    cd $CODEDIR/$repo;make;sudo make clean install;cd $PERSONALDIR
    sleep 1
done

# install dot files
git clone https://github.com/samiramer/dot-files.git $CODEDIR/dot-files
cd $CODEDIR/dot-files
stow -t /home/samer alacritty fontconfig gitconfig scripts tmux ssh xinit zsh

# install Neovim config
git clone https://github.com/samiramer/neovim-config $CODEDIR/neovim-config
ln -s $CODEDIR/neovim-config /home/samer

# install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm /home/samer/.tmux/plugins/tpm

# install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
