#!/bin/bash

dotfiles_location=~/Desktop/dotfiles

location_for_link=~/Desktop/links
location_for_compton_link=~/Desktop/links/.config
location_for_i3_link=~/Desktop/links/.config/i3wm
location_for_i3status_link=~/Desktop/links/.config/i3status

create_directories()
{
    if [ ! -d "$dotfiles_location" ]
    then
        mkdir "$dotfiles_location"
        echo creating "$dotfiles_location"
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
                    echo found .vim
                    #`ln -sf "${1}/$input" $location_for_link`
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
                    echo found i3wm
                    #`ln -sf "${1}/$input" $location_for_i3_link`
                #check if the path has i3status to create the link in the 13status link
                elif [[ "$1" == *"i3status"* ]]
                then
                    echo found i3status
                    #`ln -sf "${1}/$input" $location_for_i3status_link`
                # check if the file is compton.conf and link it to where it goes
                elif [ "$input" == "compton.conf" ]
                then
                    echo found compton.conf
                    #`ln -sf "${1}/$input" $location_for_compton_link`
                #otherwise link it to the normal location
                else
                    echo "$input"
                    #`ln -sf "${1}/$input" $location_for_link`
                fi
            fi
        fi
    done
}

# create all the necessary directories first
create_directories

git clone https://github.com/haseebali1/dotfiles "$dotfiles_location"

#start the link creating function. remove the / from the input
# $1 is the path given to the program where the dotfiles are located
create_links "$dotfiles_location"

