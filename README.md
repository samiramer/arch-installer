# arch-installer

## Instructions

1. Get the latest Archlinux iso
2. Boot into the Archlinux iso
3. Once booted execute the following command `timedatectl set-ntp true`
4. Find the name of the device to install Archlinux on using `lsblk`
5. Start partitioning the installation disk using `gdisk /dev/[device_name]`
6. Partitioning scheme
```
/efi -> size = 500MB, type = ef00 - EFI system partition
/ -> size = type = 8304 - Linux x86-64 root (/)
/home -> type = 8302 - Linux /home
```
7. Once partitioned, run `lsblk` to see the partitions
```
mkfs.fat -F32 /dev/[efi_partition]
mkfs.ext4 /dev/[root_partition]
mkfs.ext4 /dev/[home_partition]
```
8. Mount the partitions to /mnt
```
mount /dev/[root-partition] /mnt
mkdir /mnt/{efi,home}
mount /dev/[efi_partition] /mnt/efi
mount /dev/[home_partition] /mnt/home
```
9. Install the base linux packages
```
pacstrap /mnt base linux linux-firmware vim git intel-ucode
```
> Install amd-ucode instead of intel-ucode if it's an AMD system
10. Generate the fstab file
```
genfstab -U /mnt > /mnt/etc/fstab
```
11. Chroot into the /mnt folder - `arch-chroot /mnt`
12. Clone the arch-installer repo - `cd /; git clone https://github.com/samiramer/arch-installer`
13. Run the install-base.sh script - `cd /arch-installer; ./install-baase.sh`
14. Once finished, exit chroot - `exit`
15. Unmount all drives and reboot - `umount -a; reboot now`. The system will reboot and boot into the new system
16. Login, you will get a zsh welcome prompt, press 'q' to "quit and do nothing"
17. Run the dwm install script - `cd /arch-installer; ./install-dwm.sh`
18. Reboot again - `sudo reboot now`
19. Login and enjoy!
