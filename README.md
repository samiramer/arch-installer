# arch-installer

## Instructions

1. Get the latest Archlinux iso
2. Boot into the Archlinux iso
3. Once booted execute the following command `timedatectl set-ntp true`
4. Find the name of the device to install Archlinux on using `lsblk`
5. Start partitioning the installation disk using `cfdisk /dev/[device_name]`
6. Partitioning scheme
```
/boot -> size = 1G, type = EFI system partition
/ -> size = type = Linux x86-64 root (/)
/home -> type = Linux /home
/files -> type = Linux filesystem
```
7. Once partitioned, run `lsblk` to see the partitions and format them accordingly
```
mkfs.fat -F32 /dev/[efi_partition]
mkfs.ext4 /dev/[root_partition]
mkfs.ext4 /dev/[home_partition]
mkfs.ext4 /dev/[files_partition]
```
8. Mount the partitions to /mnt
```
mount /dev/[root-partition] /mnt
mkdir -p /mnt/{boot,home}
mount /dev/[efi_partition] /mnt/boot
mount /dev/[home_partition] /mnt/home
```
9. Install the base linux packages
```
pacstrap /mnt base linux linux-firmware git amd-ucode
```
> Install intel-ucode instead of amd-ucode if it's an Intel system
10. Generate the fstab file
```
genfstab -U /mnt > /mnt/etc/fstab
```
11. Chroot into the /mnt folder - `arch-chroot /mnt`
12. Clone the arch-installer repo - `cd /tmp; git clone https://github.com/samiramer/arch-installer`
13. Run the install.sh script - `cd /tmp/arch-installer; ./install.sh`
14. Once finished, exit chroot - `exit`
15. Unmount all drives and reboot - `umount -a; reboot now`. The system will reboot and boot into the new system
16. Login with `samer`
17. Run the post install script `cd /tmp/arch-installer; ./install-post.sh`
18. Login and enjoy
