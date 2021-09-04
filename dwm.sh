#!/bin/sh

sudo timedatectl set-ntp true
sudo hwclock --systohc
sudo reflector -c Canada -a 4 --sort rate --save /etc/pacman.d/mirrorlist

cd /tmp
git clone https://aur.archlinux.org/paru.git
cd paru/;makepkg -si --noconfirm;cd

# Install packages
sudo pacman -S xorg polkit-gnome feh lxappearance pcmanfm

# Install fonts
sudo pacman -S --noconfirm nerd-fonts-hack cbatticon network-manager-applet zsh-autosuggestions zsh-syntax-highlighting

# Pull Git repositories and install
cd /tmp
repos=( "dmenu" "dwm" "st" )
for repo in ${repos[@]}
do
    git clone https://github.com/samiramer/$repo.git
    cd $repo;make;sudo make install;cd
done

mkdir -p /home/samer/Code/personal
cd /home/samer/Code/personal
git clone https://github.com/samiramer/dot-files.git
cd dot-files;./install.sh

sh -c "$(curl -fsSL https://starship.rs/install.sh)"

printf "\e[1;32mDone! you can now reboot.\e[0m\n"

