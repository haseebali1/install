#!/bin/bash

dotfiles_location=~/.dotfiles
backup_location_if_file_or_directory_exists=~/.backup
location_for_link=~
location_for_compton_link=~/.config
location_for_i3_link=~/.config/i3
location_for_i3status_link=~/.config/i3status
wallpaper=~/Pictures

install_program()
{
    sudo pacman -S i3-wm i3status dmenu vlc firefox tor libreoffice-fresh clamav feh compton flashplugin vim pulseaudio pulseaudio-alsa xorg xorg-xinit rxvt-unicode dunst libnotify noto-fonts-emoji numlockx networkmanager network-manager-applet i3lock curl cronie deja-dup graphicsmagick mariadb php apache php-apache phpmyadmin ranger transmission-gtk ufw virtualbox virtualbox-guest-utils 
}

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

    if [ ! -d "$location_for_compton_link" ]
    then
        mkdir "$location_for_compton_link"
        echo creating "$location_for_compton_link"
    fi

    if [ ! -d "$location_for_i3_link" ]
    then
        mkdir "$location_for_i3_link"
        echo creating "$location_for_i3_link"
    fi

    if [ ! -d "$location_for_i3status_link" ]
    then
        mkdir "$location_for_i3status_link"
        echo creating "$location_for_i3status_link"
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
            if [ "$input" != ".git" ]
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
            if [ "$input" != ".gitignore" -a "$input" != "README.md" ]
            then 
                #check if the path has i3wm to create the link in the i3wm link
                if [[ "$1" == *i3wm* ]]
                then
                    #make sure the i3 config file does not already exist otherwise move it to backup
                    if [ -f "${location_for_i3_link}/${input}" ]
                    then
                        mv "$location_for_i3_link" "$backup_location_if_file_or_directory_exists"
                        echo "$location_for_i3_link" already exists. moving to "$backup_location_if_file_or_directory_exists"
                    fi

                    #echo found i3wm
                    `ln -sf "${1}/$input" $location_for_i3_link`
                #check if the path has i3status to create the link in the 13status link
                elif [[ "$1" == *"i3status"* ]]
                then
                    #make sure the i3status config file does not already exist otherwise move it to backup
                    if [ -f "${location_for_i3status_link}/${input}" ]
                    then
                        mv "$location_for_i3status_link" "$backup_location_if_file_or_directory_exists"
                        echo "$location_for_i3status_link" already exists. moving to "$backup_location_if_file_or_directory_exists"
                    fi

                    #echo found i3status
                    `ln -sf "${1}/$input" $location_for_i3status_link`
                # check if the file is compton.conf and link it to where it goes
                elif [ "$input" == "compton.conf" ]
                then
                    #make sure the compton config file does not already exist otherwise move it to backup
                    if [ -f "${location_for_compton_link}/${input}" ]
                    then
                        mv "${location_for_compton_link}/${input}" "$backup_location_if_file_or_directory_exists"
                        echo "${location_for_compton_link}/${input}" already exists. moving to "$backup_location_if_file_or_directory_exists"
                    fi
                    #echo found compton.conf
                    `ln -sf "${1}/$input" $location_for_compton_link`
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

git clone https://github.com/haseebali1/Wallpaper "$wallpaper"

git clone https://github.com/haseebali1/dotfiles "$dotfiles_location"

#start the link creating function.
# $dotfiles_location is the path given to the program where the dotfiles are located
create_links "$dotfiles_location"

touch ~/.xinitrc
echo exec i3 > ~/.xinitrc

