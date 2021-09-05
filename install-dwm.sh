#!/bin/sh

sudo timedatectl set-ntp true
sudo hwclock --systohc
sudo reflector --verbose -c Canada -a 4 --sort rate --save /etc/pacman.d/mirrorlist

# Install packages
sudo pacman -S --noconfirm xorg-server libx11 libxft xorg-xinit polkit-gnome feh lxappearance pcmanfm neovim tmux npm nodejs cbatticon network-manager-applet zsh-autosuggestions zsh-syntax-highlighting openfortivpn

cd /tmp
git clone https://aur.archlinux.org/yay-git.git
cd yay-git/;makepkg -si --noconfirm

yay -S nerd-fonts-hack xss-lock betterlockscreen

mkdir -p $HOME/code/personal
mkdir -p $HOME/{documents,downloads}

# Pull Git repositories and install
repos=( "dmenu" "dwm" "st" )
for repo in ${repos[@]}
do
    git clone https://github.com/samiramer/$repo.git
    cd $HOME/code/personal/$repo;make;sudo make install;cd $HOME/code/personal
done

cd /home/samer/code/personal
git clone https://github.com/samiramer/dot-files.git
cd dot-files;./install.sh

betterlockscreen -u $HOME/.config/wall.jpg

sh -c "$(curl -vfsSL https://starship.rs/install.sh)" -- --verbose --yes --bin-dir $HOME/.local/bin

printf "\e[1;32mDone! you can now reboot.\e[0m\n"

