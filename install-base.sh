#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Toronto /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "cell" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 cell.localdomain cell" >> /etc/hosts
echo root:password | chpasswd

pacman -S --noconfirm grub efibootmgr networkmanager network-manager-applet zsh dialog wpa_supplicant mtools dosfstools reflector rsync base-devel linux-headers avahi inetutils dnsutils bluez bluez-utils alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack openssh reflector acpi acpi_call tlp bridge-utils acpid terminus-font

pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable sshd
systemctl enable tlp
systemctl enable fstrim.timer
systemctl enable acpid

useradd -m -s /usr/bin/zsh samer
echo samer:password | chpasswd

echo "samer ALL=(ALL) ALL" >> /etc/sudoers.d/samer


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m\n"
