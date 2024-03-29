#!/bin/bash

dotfiles_location=$HOME/.dotfiles
backup_location_if_file_or_directory_exists=$HOME/.backup
location_for_link=$HOME
wallpaper=$HOME/Pictures
suckless_location=$HOME/.dotfiles/suckless
crontab_file_location=$HOME/install/crontab_file

#packages to be installed
install_program()
{
    sudo pacman -S dmenu vlc firefox tor libreoffice-fresh clamav feh picom xorg xorg-xinit dunst libnotify ttf-font-awesome numlockx networkmanager network-manager-applet curl cronie graphicsmagick mariadb php apache php-apache phpmyadmin picom transmission-gtk ufw virtualbox virtualbox-guest-utils htop scrot zathura zathura-pdf-mupdf xclip openssh mpv xorg-xbacklight python-setuptools python2-setuptools gimp scrot i3lock imagemagick wget ttf-roboto sxhkd cups cups-pdf sane ttf-jetbrains-mono neovim hunspell hunspell-en_us hyphen hyphen-en libmythes mythes-en polybar vifm yt-dlp scrcpy pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber helvum
}

#create the necessary directories for where the files will go
create_directories()
{
    if [ ! -d "$dotfiles_location" ]
    then
        mkdir "$dotfiles_location"
        echo creating "$dotfiles_location"
    fi

    if [ ! -d "$backup_location_if_file_or_directory_exists" ]
    then
        mkdir "$backup_location_if_file_or_directory_exists"
        echo creating "$backup_location_if_file_or_directory_exists"
    fi

    if [ ! -d "$wallpaper" ]
    then
        mkdir "$wallpaper"
        echo creating "$wallpaper"
    fi
}

create_links()
{
    # ls -A to also get the hidden files but ignore . and ..
    for input in `ls -A -1 $1`
    do
       # check if the file is a directory or not if it is continue
        if [ -d "${1}/$input" ]
        then
            #if the directory is .git do nothing
            if [ "$input" != ".git" ] && [  "$input" != "scripts" ] && [ "$input" != "firefox" ] && [ "$input" != "vlc" ] && [ "input" != "suckless" ]
            then
                # if the directory is .vim or .config create the link without going into the directory
                if [ "$input" = ".vim" ] || [ "$input" = ".config" ]
                then
                    # check if the .vim file already exists in the location or not.
                    # if it does move it to backup
                    if [ -d "${location_for_link}/${input}" ]
                    then
                        mv "${location_for_link}/${input}" "$backup_location_if_file_or_directory_exists"
                        echo "$input" already exists moving to "$backup_location_if_file_or_directory_exists"
                    fi
                    #echo found .vim
                    `ln -sf "${1}/$input" $location_for_link`
            fi
        fi
        # else the input is a file
        else
            # ignore the .gitignore and the README.md file
            if [ "$input" != ".gitignore" -a "$input" != "README.md" -a "$input" != ".bash_aliases" ]
            then
                    if [ -f "${location_for_link}/${input}" ]
                    then
                        mv "${location_for_link}/${input}" "$backup_location_if_file_or_directory_exists"
                        echo "${location_for_link}/${input}" already exists. moving to "$backup_location_if_file_or_directory_exists"
                    fi
                    #echo "$input"
                    `ln -sf "${1}/$input" $location_for_link`
                #fi
            fi
        fi
    done
}

#enable parallel downloads
sed -i '/ParallelDownloads/s/^#//g' /etc/pacman.conf

#enable colors
sed -i '/Color/s/^#//g' /etc/pacman.conf

#use pacman
echo "ILoveCandy" >> /etc/pacman.conf

#make a backup of the default mirrorlist
sudo cp /etc/pacman.d/mirrorlist $HOME/mirrorlist_backup

#install reflector
sudo pacman -S reflector

#run reflector
reflector --latest 200 --sort rate --save /etc/pacman.d/mirrorlist

install_program

# create all the necessary directories first
create_directories

cd

git clone https://github.com/haseebali1/Wallpaper.git "$wallpaper"

git clone https://github.com/haseebali1/dotfiles.git "$dotfiles_location"

#start the link creating function.
# $dotfiles_location is the path given to the program where the dotfiles are located
create_links "$dotfiles_location"

cd

#get yay
git clone https://aur.archlinux.org/yay.git
cd $HOME/yay
makepkg -si
cd

#get MultiMC
git clone https://github.com/MultiMC/multimc-pkgbuild.git
cd $HOME/multimc-pkgbuild
makepkg -si
cd

yay -S python-ueberzug-git st simple-mtpfs brave-bin brscan4 sane-airscan libreoffice-extension-languagetool

cd $suckless_location/dwm
sudo make install
make clean
cd

#get st from github

cd $suckless_location/st
sudo make install
make clean
cd

#get dmenu from github
cd $suckless_location/dmenu
sudo make install
make clean
cd

# get dwmblocks
cd $suckless_location/dwmblocks
sudo make install
make clean
cd

#default to deny any incoming
sudo ufw default deny incoming

#default to allow any outgoing
sudo ufw default allow outgoing

#enable ufw
sudo ufw enable

#enable services
sudo systemctl enable NetworkManager.service
sudo systemctl enable cups.service
sudo systemctl enable avahi-daemon.service
sudo systemctl enable paccache.timer
sudo systemctl enable fstrim.timer
sudo systemctl enable fstrim.service
sudo systemctl enable ufw.service
sudo systemctl enable cronie.service
sudo systemctl enable pipewire.socket
sudo systemctl enable pipewire-pulse.socket
sudo systemctl enable wireplumber.service

#edit crontab tasks
crontab $crontab_file_location

#restart for changes to take place

reboot
