#!/bin/sh

sudo timedatectl set-ntp true
sudo hwclock --systohc
sudo reflector --verbose -c Canada -a 4 --sort rate --save /etc/pacman.d/mirrorlist

# Install packages
sudo pacman -Sy --noconfirm xorg libx11 libxft xorg-xinit feh lxappearance pcmanfm neovim tmux network-manager-applet dunst pavucontrol flameshot alacritty redshift picom arandr autorandr pamixer gnupg pass fuse2 xdotool xautolock xss-lock ttf-noto-nerd xsel stow blueman polkit polkit-gnome i3lock mkcert gnome-keyring secret-tool libsecret seahorse gnome-themes-extra xdg-user-dirs lazygit libnotify zip unzip imagemagick

# Install local root CA
mkcert -install

cd /tmp
git clone https://aur.archlinux.org/yay-git.git
cd yay-git/;makepkg -si --noconfirm
sleep 2

mkdir -p $HOME/Code/Personal
sleep 2

# Pull Git repositories and install
cd $HOME/Code/Personal
repos=( "dmenu" "dwm" "dwmblocks" )
for repo in ${repos[@]}
do
    git clone https://github.com/samiramer/$repo.git
    cd $HOME/Code/Personal/$repo;make;sudo make clean install;cd $HOME/Code/Personal
    sleep 2
done

# Install dot files
git clone https://github.com/samiramer/dot-files.git $HOME/Code/Personal/dot-files
cd $HOME/Code/Personal/dot-files

stow -t ~ alacritty gitconfig scripts tmux xinit zsh
cd $HOME
sleep 2

# Install neovim v0.5.0
mkdir /tmp/nvim
cd /tmp/nvim
curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
chmod u+x nvim.appimage
mkdir -p $HOME/.local/bin
mv nvim.appimage $HOME/.local/bin/nvim
cd $HOME
sleep 2

# Install Neovim config
git clone https://github.com/samiramer/neovim-config $HOME/.config/nvim

# Install tmux plugin manager
git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm

# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# Install 1password
yay -Sy --noconfirm 1password

printf "\e[1;32mDone! you can now reboot.\e[0m\n"

