#!/bin/bash

dotfiles_location=$HOME/.dotfiles
backup_location_if_file_or_directory_exists=$HOME/.backup
location_for_link=$HOME
location_for_picom_link=$HOME/.config
#location_for_i3_link=$HOME/.config/i3
#location_for_i3status_link=$HOME/.config/i3status
wallpaper=$HOME/Pictures

#packages to be installed
install_program()
{
    sudo pacman -S dmenu vlc firefox tor libreoffice-fresh clamav feh picom gvim pulseaudio pulseaudio-alsa xorg xorg-xinit dunst libnotify otf-font-awesome numlockx networkmanager network-manager-applet i3lock curl cronie graphicsmagick mariadb php apache php-apache phpmyadmin composer ranger transmission-gtk ufw virtualbox virtualbox-guest-utils htop scrot light zathura zathura-pdf-mupdf xclip openssh
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

    if [ ! -d "$location_for_picom_link" ]
    then
        mkdir "$location_for_picom_link"
        echo creating "$location_for_picom_link"
    fi

    #if [ ! -d "$location_for_i3_link" ]
    #then
    #    mkdir "$location_for_i3_link"
    #    echo creating "$location_for_i3_link"
    #fi

    #if [ ! -d "$location_for_i3status_link" ]
    #then
    #    mkdir "$location_for_i3status_link"
    #    echo creating "$location_for_i3status_link"
    #fi

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
            if [ "$input" != ".git" ] && [  "$input" != "scripts" ]
            then
                # if the directory is .vim create the link without going into the directory
                if [ "$input" = ".vim" ]
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
                    # otherwise if the input is a directory do the process again
                else
                    create_links "${1}/$input"
            fi
        fi
        # else the input is a file
        else
            # ignore the .gitignore and the README.md file
            if [ "$input" != ".gitignore" -a "$input" != "README.md" -a "$input" != ".bash_aliases" -a "$input" != "config" ]
            then 
                #check if the path has i3wm to create the link in the i3wm link
                #if [[ "$1" == *i3wm* ]]
                #then
                #    #make sure the i3 config file does not already exist otherwise move it to backup
                #    if [ -f "${location_for_i3_link}/${input}" ]
                #    then
                #        mv "$location_for_i3_link" "$backup_location_if_file_or_directory_exists"
                #        echo "$location_for_i3_link" already exists. moving to "$backup_location_if_file_or_directory_exists"
                #    fi

                #    #echo found i3wm
                #    `ln -sf "${1}/$input" $location_for_i3_link`
                ##check if the path has i3status to create the link in the 13status link
                #elif [[ "$1" == *"i3status"* ]]
                #then
                #    #make sure the i3status config file does not already exist otherwise move it to backup
                #    if [ -f "${location_for_i3status_link}/${input}" ]
                #    then
                #        mv "$location_for_i3status_link" "$backup_location_if_file_or_directory_exists"
                #        echo "$location_for_i3status_link" already exists. moving to "$backup_location_if_file_or_directory_exists"
                #    fi

                #    #echo found i3status
                #    `ln -sf "${1}/$input" $location_for_i3status_link`
                ## check if the file is picom.conf and link it to where it goes
                if [ "$input" == "picom.conf" ]
                then
                    #make sure the picom config file does not already exist otherwise move it to backup
                    if [ -f "${location_for_picom_link}/${input}" ]
                    then
                        mv "${location_for_picom_link}/${input}" "$backup_location_if_file_or_directory_exists"
                        echo "${location_for_picom_link}/${input}" already exists. moving to "$backup_location_if_file_or_directory_exists"
                    fi
                    #echo found picom.conf
                    `ln -sf "${1}/$input" $location_for_picom_link`
                #otherwise link it to the normal location
                else
                    #make sure the file does not already exist otherwise move it to backup
                    #.bash_aliases .bashrc .vimrc
                    if [ -f "${location_for_link}/${input}" ]
                    then
                        mv "${location_for_link}/${input}" "$backup_location_if_file_or_directory_exists"
                        echo "${location_for_link}/${input}" already exists. moving to "$backup_location_if_file_or_directory_exists"
                    fi
                    #echo "$input"
                    `ln -sf "${1}/$input" $location_for_link`
                fi
            fi
        fi
    done
}

install_program

# create all the necessary directories first
create_directories

cd

git clone https://github.com/haseebali1/Wallpaper.git "$wallpaper"

git clone https://github.com/haseebali1/dotfiles.git "$dotfiles_location"

#start the link creating function.
# $dotfiles_location is the path given to the program where the dotfiles are located
create_links "$dotfiles_location"

#get dwm from github

git clone https://github.com/haseebali1/dwm.git

cd $HOME/dwm
sudo make clean install
cd

#get st from github

git clone https://github.com/haseebali1/st.git

cd $HOME/st
sudo make clean install
cd

#add dwmbar and refbar to bin to execute from anywhere
sudo cp $HOME/.dotfiles/scripts/dwmbar.sh /usr/local/bin/dwmbar
sudo cp $HOME/.dotfiles/scripts/refbar.sh /usr/local/bin/refbar

#restart for changes to take place

reboot
