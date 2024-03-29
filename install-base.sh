#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime
hwclock --systohc
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "cell" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 cell.localdomain cell" >> /etc/hosts
echo root:password | chpasswd

pacman -Sy --noconfirm grub efibootmgr networkmanager network-manager-applet zsh wpa_supplicant reflector rsync base-devel linux-headers inetutils dnsutils bluez bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack openssh acpi acpi_call tlp thermald acpid terminus-font wget curl htop powertop man-db man-pages texinfo os-prober wireguard-tools mkcert fzf ripgrep openvpn networkmanager-openvpn docker

echo "GRUB_DISABLE_OS_PROBER=false" > /etc/default/grub
echo 'GRUB_CMDLINE_LINUX_DEFAULT="usbcore.autosuspend=-1"' >> /etc/default/grub
echo "GRUB_TIMEOUT=3" >> /etc/default/grub

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

cp bluetooth-resume.service /etc/systemd/system/bluetooth-resume.service
sed -i 's/#AutoEnable=false/AutoEnable=true/g' /etc/bluetooth/main.conf

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable sshd
systemctl enable tlp
systemctl enable fstrim.timer
systemctl enable acpid
systemctl enable thermald
systemctl enable docker

useradd -m -s /usr/bin/zsh samer
echo samer:password | chpasswd

echo "samer ALL=(ALL) ALL" >> /etc/sudoers.d/samer

chown -R samer:samer /home/samer
usermod -aG docker samer


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m\n"
