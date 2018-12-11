#!/bin/bash

location_for_link=~/Desktop/links
location_for_i3_link=~/Desktop/links/i3wm
location_for_i3status_link=~/Desktop/links/i3status

test()
{
    for input in `ls -A -1 $1`
    do
        if [ -d ${1}/$input ]
        then
            if [ "$input" != ".git" ]
            then
                if [ "$input" = ".vim" ]
                then
                    `ln -sf "${1}/$input" $location_for_link`
                    #echo found .vim
               # fi
                else
                    test ${1}/$input
            fi
        fi
        else
            if [ "$input" != ".gitignore" -a "$input" != "README.md" ]
            then 
                #if [ "$1" == *_"i3wm"_* ]
                if [[ $1 == *i3wm* ]]
                then
                        `ln -sf "${1}/$input" $location_for_i3_link`
                elif [[ $1 == *"i3status"* ]]
                    then
                        `ln -sf "${1}/$input" $location_for_i3status_link`
                    else
                        `ln -sf "${1}/$input" $location_for_link`
                fi
            fi
        fi
    done
}

test ${1%?}
