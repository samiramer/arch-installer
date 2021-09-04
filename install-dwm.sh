#!/bin/sh

sudo timedatectl set-ntp true
sudo hwclock --systohc
sudo reflector --verbose -c Canada -a 4 --sort rate --save /etc/pacman.d/mirrorlist

# Install packages
sudo pacman -S --noconfirm xorg-server libx11 libxft xorg-xinit polkit-gnome feh lxappearance pcmanfm neovim

# Install fonts
sudo pacman -S --noconfirm cbatticon network-manager-applet zsh-autosuggestions zsh-syntax-highlighting

cd /tmp
git clone https://aur.archlinux.org/yay-git.git
cd yay-git/;makepkg -si --noconfirm

yay -S nerd-fonts-hack xss-lock betterlockscreen

mkdir -p /home/samer/Code/personal

# Pull Git repositories and install
repos=( "dmenu" "dwm" "st" )
for repo in ${repos[@]}
do
    git clone https://github.com/samiramer/$repo.git
    cd $HOME/Code/personal/$repo;make;sudo make install;cd $HOME/Code/personal
done

cd /home/samer/Code/personal
git clone https://github.com/samiramer/dot-files.git
cd dot-files;./install.sh

sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --verbose --yes --bin-dir $HOME/.local/bin

printf "\e[1;32mDone! you can now reboot.\e[0m\n"

