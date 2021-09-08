#!/bin/sh

sudo timedatectl set-ntp true
sudo hwclock --systohc
sudo reflector --verbose -c Canada -a 4 --sort rate --save /etc/pacman.d/mirrorlist

# Install packages
sudo pacman -Sy --noconfirm xorg-server libx11 libxft xorg-xinit xorg-xset xorg-xbacklight xorg-xsetroot gnome-keyring polkit-gnome feh lxappearance pcmanfm neovim tmux npm nodejs cbatticon network-manager-applet zsh-autosuggestions zsh-syntax-highlighting openfortivpn dunst pavucontrol

cd /tmp
git clone https://aur.archlinux.org/yay-git.git
cd yay-git/;makepkg -si --noconfirm

yay -S noto-fonts nerd-fonts-hack xss-lock betterlockscreen xclip

mkdir -p $HOME/media/code/personal
mkdir -p $HOME/media/{documents,downloads}

# Pull Git repositories and install
cd $HOME/media/code/personal
repos=( "dmenu" "dwm" "st" )
for repo in ${repos[@]}
do
    git clone https://github.com/samiramer/$repo.git
    cd $HOME/media/code/personal/$repo;make;sudo make install;cd $HOME/media/code/personal
done

cd /home/samer/media/code/personal
git clone https://github.com/samiramer/dot-files.git
cd dot-files;./install.sh

betterlockscreen -u $HOME/.config/wall.jpg

sh -c "$(curl -vfsSL https://starship.rs/install.sh)" -- --verbose --yes --bin-dir $HOME/.local/bin

printf "\e[1;32mDone! you can now reboot.\e[0m\n"

