#!/bin/sh

sudo timedatectl set-ntp true
sudo hwclock --systohc
sudo reflector --verbose -c Canada -a 4 --sort rate --save /etc/pacman.d/mirrorlist

# Install packages
sudo pacman -Sy --noconfirm xorg-server libx11 libxft xorg-xinit xorg-xset xorg-xrandr xorg-xsetroot feh lxappearance pcmanfm neovim tmux npm nodejs cbatticon network-manager-applet dunst pavucontrol flameshot alacritty redshift picom arandr autorandr pamixer brightnessctl gnupg pass openfortivpn

cd /tmp
git clone https://aur.archlinux.org/yay-git.git
cd yay-git/;makepkg -si --noconfirm

yay -S noto-fonts nerd-fonts-source-code-pro xss-lock betterlockscreen xclip brave-bin

mkdir -p $HOME/code/personal
sleep 3
mkdir -p $HOME/{documents,downloads}
sleep 3

# Pull Git repositories and install
cd $HOME/code/personal
sleep 3
repos=( "dmenu" "dwm" )
for repo in ${repos[@]}
do
    git clone https://github.com/samiramer/$repo.git
    cd $HOME/code/personal/$repo;make;sudo make install;cd $HOME/code/personal
    sleep 3
done

cd /home/samer/code/personal
git clone https://github.com/samiramer/dot-files.git
cd dot-files;./install.sh
sleep 3

betterlockscreen -u $HOME/.config/wall.jpg

sleep 3

sh -c "$(curl -vfsSL https://starship.rs/install.sh)" -- --verbose --yes --bin-dir $HOME/.local/bin

sleep 3

printf "\e[1;32mDone! you can now reboot.\e[0m\n"

