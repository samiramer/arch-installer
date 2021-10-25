#!/bin/sh

sudo timedatectl set-ntp true
sudo hwclock --systohc
sudo reflector --verbose -c Canada -a 4 --sort rate --save /etc/pacman.d/mirrorlist

# Install packages
sudo pacman -Sy --noconfirm xorg-server libx11 libxft xorg-xinit xorg-xset xorg-xrandr xorg-xsetroot feh lxappearance pcmanfm neovim tmux npm nodejs cbatticon network-manager-applet dunst pavucontrol flameshot alacritty redshift picom arandr autorandr pamixer brightnessctl gnupg pass openfortivpn fuse2

cd /tmp
git clone https://aur.archlinux.org/yay-git.git
cd yay-git/;makepkg -si --noconfirm
sleep 2

yay -S noto-fonts nerd-fonts-source-code-pro xss-lock betterlockscreen xclip brave-bin arc-gtk-theme arc-icon-theme i3-gaps i3blocks
sleep 2

mkdir -p $HOME/code/personal
mkdir -p $HOME/{documents,downloads}
sleep 2

# Pull Git repositories and install
cd $HOME/code/personal
repos=( "dmenu" "dwm" )
for repo in ${repos[@]}
do
    git clone https://github.com/samiramer/$repo.git
    cd $HOME/code/personal/$repo;make;sudo make install;cd $HOME/code/personal
    sleep 2
done

# Install dot files
cd $HOME/code/personal
git clone https://github.com/samiramer/dot-files.git
cd dot-files;./install.sh
sleep 2

# Generate lock screen background
betterlockscreen -u $HOME/.config/wall.png
sleep 2

# Install neovim v0.5.0
mkdir /tmp/nvim
cd /tmp/nvim
curl -LO "https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage"
chmod u+x nvim.appimage
mv nvim.appimage $HOME/.local/bin/nvim
cd $HOME
sleep 2

# Install starship prompt
sh -c "$(curl -vfsSL https://starship.rs/install.sh)" -- --verbose --yes --bin-dir $HOME/.local/bin
sleep 2

printf "\e[1;32mDone! you can now reboot.\e[0m\n"

