#!/bin/bash

# setup network, locale and clock stuff
ln -sf /usr/share/zoneinfo/Canada/Eastern /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-7" >> /etc/locale.conf
echo "minicell" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 mini.localdomain mini" >> /etc/hosts
echo root:password | chpasswd

# install required packages
pacman -Sy --noconfirm \
    alacritty \
    base-devel \
    blueman \
    bluez \
    bluez-utils \ 
    curl \
    docker \
    dunst \
    efibootmgr \
    feh \
    flameshot \
    fzf \
    gnome-keyring \
    gnome-themes-extra \
    gnupg \
    grub  \
    i3lock \
    imagemagick \
    lazygit \
    libnotify \
    libsecret \
    libx11 \
    libxft \
    lxappearance \
    man-db \
    man-pages \
    mkcert \
    neovim \
    networkmanager \
    networkmanager-openvpn \
    network-manager-applet \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    openssh \
    openvpn \
    os-prober \
    pamixer \
    pass \
    pasystray \
    pavucontrol \
    pcmanfm \
    pipewire \
    pipewire-alsa \
    pipewire-pulse \
    polkit \
    polkit-gnome \
    ripgrep \
    seahorse \
    secret-tool \
    sshd \
    stow \
    sudo \
    texinfo \
    tmux \
    wget \
    xautolock \
    xdg-user-dirs \
    xclip \
    xdotool \
    xorg \
    xorg-xinit \
    xsel \
    xss-lock \
    zip \
    zsh \
    unzip
    
# install local root CA
mkcert -install

# install yay
cd /tmp
git clone https://aur.archlinux.org/yay-git.git
cd yay-git/;makepkg -si --noconfirm
sleep 2

# install extra packages
yay -Sy --noconfirm \
    1password \
    google-chrome \
    picom-ftlabs-git \
    ttf-adwaita-mono-nerd \
    xautolock

# setup grub
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
echo 'GRUB_CMDLINE_LINUX_DEFAULT="usbcore.autosuspend=-1 loglevel=3"' >> /etc/default/grub
echo "GRUB_TIMEOUT=3" >> /etc/default/grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

# enable system services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable sshd
systemctl enable docker

# setup samer
useradd -m -s /usr/bin/zsh samer
echo samer:password | chpasswd
usermod -aG docker samer
chown -R samer:samer /home/samer
echo "samer ALL=(ALL) ALL" >> /etc/sudoers.d/samer


# prep the code folder
$CODEDIR="/files/code/personal"
mkdir -p $CODEDIR
chown -R samer:samer /files

# switch to samer user so we can install some stuff
su samer

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
