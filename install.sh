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
pacman -Syu --noconfirm - < packages.txt
    
# install local root CA
mkcert -install

# install yay
cd /tmp
git clone https://aur.archlinux.org/yay-git.git
cd yay-git/;makepkg -si --noconfirm
sleep 2

# install extra packages
yay -Syu --noconfirm - < aur-packages.txt

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
