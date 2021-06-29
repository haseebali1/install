#!/bin/bash

username=""
myhostname=""

timedatectl set-ntp true
ln -sf /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
hwclock --systohc
sed -i '177s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "$myhostname" >> /etc/hostname
echo -e "127.0.0.1\tlocalhost" >> /etc/hosts
echo -e "::1\t\tlocalhost" >> /etc/hosts
echo -e "127.0.1.1\t$myhostname.localdomain $myhostname" >> /etc/hosts
echo "root password"
passwd

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

pacman -S grub efibootmgr networkmanager

# pacman -S --noconfirm xf86-video-amdgpu
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager

useradd -m $username
echo "$username password"
passwd $username
usermod -aG libvirt lp wheel $username

echo "$username ALL=(ALL) ALL" >> /etc/sudoers.d/$username


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m\n"




